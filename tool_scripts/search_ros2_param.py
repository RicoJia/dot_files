#!/usr/bin/env python3
import argparse, time
import rclpy
from rclpy.node        import Node
from rcl_interfaces.srv import ListParameters, GetParameters
from rcl_interfaces.msg import ParameterType

PINK, RESET = "\033[35m", "\033[0m"

def pretty_value(pv):
    t = pv.type
    if t == ParameterType.PARAMETER_BOOL:    return pv.bool_value
    if t == ParameterType.PARAMETER_INTEGER: return pv.integer_value
    if t == ParameterType.PARAMETER_DOUBLE:  return pv.double_value
    if t == ParameterType.PARAMETER_STRING:  return pv.string_value
    return pv        # fallback (arrays etc.)

class ParamSearch(Node):
    def __init__(self, query, timeout=1.0):
        super().__init__('ros2_param_search')
        self.query, self.timeout = query, timeout

    # -------------- helper --------------------------------------------------
    def _batch(self, clients, build_req):
        futs = {cli: cli.call_async(build_req()) for cli in clients}
        deadline = self.get_clock().now() + rclpy.duration.Duration(seconds=self.timeout)
        while rclpy.ok() and any(not f.done() for f in futs.values()) \
                and self.get_clock().now() < deadline:
            rclpy.spin_once(self, timeout_sec=0.1)
        return {cli: (f.result() if f.done() else None) for cli, f in futs.items()}

    # -------------- main ----------------------------------------------------
    def run(self):
        start = time.time()

        # TODO
        warmup_deadline = start + 1.0
        while time.time() < warmup_deadline:
            rclpy.spin_once(self, timeout_sec=0.05)

        # discover *current* list_parameter services
        # DDS discovery is eventually consistent, but only with enough spin time. Without the spin_once() above, this node may not be able to 
        # see all services here
        svcs = dict(self.get_service_names_and_types())
        list_svcs = [n for n, types in svcs.items()
                     if 'rcl_interfaces/srv/ListParameters' in types]
        print(f'Found {len(list_svcs)} / {len(svcs)} nodes exposing /list_parameters')
        if not list_svcs:
            print("No nodes expose /list_parameters.")
            return

        list_clis = [self.create_client(ListParameters, s) for s in list_svcs]
        for c in list_clis: c.wait_for_service(timeout_sec=0.5)

        list_res = self._batch(list_clis,
                               lambda: ListParameters.Request(prefixes=[], depth=10))

        matches = {}
        for cli, resp in list_res.items():
            if not resp: continue
            node = cli.srv_name[:-len('/list_parameters')]
            hits = [n for n in resp.result.names if self.query in n]
            if hits: matches[node] = hits

        if not matches:
            print(f"(no parameters containing “{self.query}” found)")
            return

        # build get_parameter clients + inverse map
        get_clis, inverse = {}, {}
        for node in matches:
            cli = self.create_client(GetParameters, f'{node}/get_parameters')
            cli.wait_for_service(timeout_sec=0.5)
            get_clis[node], inverse[cli] = cli, node

        get_res = self._batch(
            get_clis.values(),
            lambda: GetParameters.Request(names=matches[inverse[cli]])
        )

        for node, cli in get_clis.items():
            resp = get_res.get(cli)
            if not resp: continue
            for name, val in zip(matches[node], resp.values):
                print(f"{PINK}{node} → {name}: {pretty_value(val)}{RESET}")

        print(f"[completed in {time.time()-start:.3f}s]")

def main():
    p = argparse.ArgumentParser(description="Substring search across live ROS 2 parameters")
    p.add_argument('query', help='substring to search for')
    p.add_argument('--timeout', type=float, default=1.0,
                   help='seconds to wait for each service batch (default: 1)')
    args = p.parse_args()

    rclpy.init()
    node = ParamSearch(args.query, args.timeout)
    try:    node.run()
    finally:
        node.destroy_node()
        rclpy.shutdown()

if __name__ == '__main__':
    main()
