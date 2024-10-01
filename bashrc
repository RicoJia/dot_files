# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

##########################Personal

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias pdfstudio2022='~/pdfstudio2022/pdfstudio2022'
############################Moxi

source /opt/ros/noetic/setup.bash
export MOXI_DEV=~/repos/moxi_dev
export PATH=$MOXI_DEV/scripts:~/repos/do-diligent/tools:$PATH
export PATH=~/repos/do-diligent/ansible/roles/roc_machine_provisioning/files/opt/diligent/bin:$PATH
source $MOXI_DEV/diligent_ws/devel/setup.bash
export WORK_DILIGENT="/home/rjia/file_exchange_port/Work/diligent"
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
export PS1="\[\e[1;32m\]\u@\h\[\e[1;34m\]:\w \[\e[1;95m\]\$(parse_git_branch)\[\e[00m\]$ "


moxi_home(){
	cd $MOXI_DEV
}

function gsub_update_rico(){
	git submodule update --init --recursive
}
export MOXI_LOCAL_IP="172.42.42.94"
sshmoxi() {
    ssh -o StrictHostKeyChecking=no "moxi@${MOXI_LOCAL_IP}"
}

sshmoxin() {
    ssh-keygen -f ~/.ssh/known_hosts -R "${MOXI_LOCAL_IP}"
    sshmoxi
}

copysshmoxi() {
    ssh-copy-id "moxi@${MOXI_LOCAL_IP}"
}

fire_host() {
	export FIRESTORE_EMULATOR_HOST=$1:8080
}

fire_emulate() 
{
	export EMULATOR_SRC_SITE=$1
	export EMULATOR_SRC_PROJECT_ID=central-datastore-$2
}
alias stop_firebase='ps -aux | grep firebase | grep -v grep | tr -s '\'' '\'' | cut -f 2 -d '\'' '\'' | xargs kill'
export PATH=${PATH}:/home/rjia/.local/bin
export PATH=${PATH}:/home/rjia/repos/do-diligent/tools # Install crowbar

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export SEMANTIC_DATA_BACKUPS=~/repos/semantic_data_backups
export MOXI_RPI_PATH=~/repos/moxi_rpi
export PATH=${PATH}:/home/rjia/.local/bin
export PATH=${PATH}:/home/rjia/repos/do-diligent/tools # Install crowbar
export RJJE_ARM_PATH=/home/rjia/file_exchange_port/Fun_Projects/RJJE_Arm/rjje_arm_ws
export OVERRIDE_PATH=~/repos/moxi_dev/nonros/scheduler/diligent_sdk/scripts
# END DILIGENT ANSIBLE ROBOT_SPECIFIC MANAGED BLOCK
export SCH=~/repos/moxi_dev/nonros/scheduler
export DO_DILIGENT=~/repos/do-diligent
export DILIGENT_ENVIRONMENT=dev
alias sr='source devel/setup.bash'
export MOXI_CALIBRATION_ROOT_PATH=~/repos/.moxi_calibration
export MOXI_DATA_PATH=~/repos/moxi_dev/diligent_ws/src/moxi_data

###############################################
# Personal
###############################################
source ~/file_exchange_port/Fun_Projects/Junior_Project/junior_ws/devel/setup.bash

function cp_rcs(){
    cp /home/${USER}/.bashrc /home/${USER}/file_exchange_port/Books_Dotfiles/dot_files/bashrc
    cp /home/${USER}/.vimrc /home/${USER}/file_exchange_port/Books_Dotfiles/dot_files/vimrc
}

function restart_sound_rico(){
    pulseaudio -k && sudo alsa force-reload
}

function autop(){
    # # Python linter
    # @ means all positional args
    for FILE in $@
    do
    autopep8 --in-place --aggressive --max-line-length=119 --ignore E121,E123,E124,E125,E126,E127,E129,E131,W503 $FILE
    isort $FILE
    echo "auto pep file ${FILE}"
    done
        
}
function gupdate(){
    git submodule update --init --recursive
}

function gcp_rico(){
    # use return instead of exit for function returns
    if [[ ${#} -lt 1 ]]; then 
      echo "  This script will do git commit and git push (to the same current branch) at one shot.
Usage: ${0} <commit_msg>"
        return 1; fi

    echo ${1}
    git commit -m "${1}"

    CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
    git push origin $CURRENT_BRANCH

}

function gpull_rico(){
    CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
    git pull origin $CURRENT_BRANCH
}

function gcp_rico_noverify(){
    git commit --no-verify -m "$1"
    CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
    git push origin $CURRENT_BRANCH
}


function gd_rico(){
    echo "This script will delete the local branch specified by the user, and its remote branch
    Usage: ${0} <branch_name>
    "

    if [[ ${#} -lt 1 ]]; then usage; exit 1; fi

    git branch -D "${1}"

    git push origin --delete "${1}"
}

function gfetch_checkout_pull_rico(){   
    if [[ $# != 1 ]]
    then 
        echo "Usage: 
        gfetch_checkout_pull_rico BRANCH_KEYWORD 
        This function will then fetch the branch, check it out, and pull the most recent update"
        return 1
    fi

    git fetch
    branches=$(git branch -a)
    branches_contain_numbers=()
    for b in $branches
    do
        if [[ $b != "remote"*  && $b == *"$1"* ]]
        then 
            branches_contain_numbers+=($b)
        fi
    done
    if [[ ${#branches_contain_numbers[@]} == 1 ]]
    then 
        # use double quotes, and [@] to print an array
        branch=${branches_contain_numbers[0]}
        git checkout $branch
        git pull origin $branch
    else 
        echo "Make sure there's only one branch with keyword being passed in! There are ${#branches_contain_numbers[@]} hits:"
        echo "${branches_contain_numbers[@]}"
        return 1
    fi
}

function gremote_update(){
    REMOTE_URL=$(git remote get-url origin)
    NEW_URL=$(echo ${REMOTE_URL} | sed "s/.com/-personal/")
    git remote set-url origin "$NEW_URL"
    echo "Added origin $NEW_URL" 
    git remote add vscode-origin "$REMOTE_URL"
    echo "Added vscode-origin $REMOTE_URL" 
}

function npxlint(){
    npx eslint --fix ${1}
}

function swap_alt(){
    setxkbmap -option altwin:swap_alt_win
}

function rico_bash_prefrences_deploy_rico(){
    for i in 1 2 4 32
    do
        echo "deploying ${i}"
        sshpass -p S1Machines. scp ~/rico_scripts/rico_bash_preferences.sh moxi@moxi${i}:/home/moxi/rico_tmp/
    done
}

function rico_openvpn_off(){
    openvpn3 session-manage --session-path $(openvpn3 sessions-list | grep "Path" | sed 's/Path://g') --disconnect
}

function rico_openvpn_on(){
    openvpn3 session-start --config ~/file_exchange_port/vpn_related/profile-4.ovpn
}

# This function can go to the root of the git repo
# And filter for multiple file extensions.
# among new files / changed files
function rico_lint_repo_changed_files(){
    cd $(git rev-parse --show-toplevel)
    CPP_FILES_TO_LINT=$(git status --porcelain | awk '/^[^D]/ {print $2}' | grep -E "\.(cpp|h|hpp)") 
    echo ${CPP_FILES_TO_LINT} | xargs clang-format -i
    echo "Linted cpp files: ${CPP_FILES_TO_LINT}"

    CMAKELISTS_TO_LINT=$(git status --porcelain | awk '/^[^D]/ {print $2}' | grep -E "CMakeLists.txt")
    echo ${CMAKELISTS_TO_LINT} | xargs cmake-format -i
    echo "Linted CMakeLists.txt files: ${CMAKELISTS_TO_LINT}"

    PYTHON_FILES_TO_LINT=$(git status --porcelain | awk '/^[^D]/ {print $2}' | grep -E "*.py")
    if [[ ${#PYTHON_FILES_TO_LINT} != 0 ]]; then
        echo ${PYTHON_FILES_TO_LINT} | xargs black
        echo ${PYTHON_FILES_TO_LINT} | xargs isort
        echo "Linted .py files: ${PYTHON_FILES_TO_LINT}"
    else echo "Python linting: No files to lint"
    fi
}

###############################################
# Work Funcs
###############################################

function sshp(){
    sshpass -p "S1Machines." ssh -YC $1
}

function refresh_install(){
    ${MOXI_DEV}/nonros/scheduler/diligent_sdk/scripts/refresh_install.sh
}

function feature_flag_deploy_rico(){
    cd ${DO_DILIGENT}/ansible/ && ansible-playbook playbooks/feature_flags.yml --tags config_files --limit "moxi${1}" -kK --diff --check
}

function pip_diligent_sdk_rico(){
    cd $SCH/diligent_sdk/python
    pip install -e .

}

function global_protect_setup(){
    sudo cp /etc/resolv.conf /etc/resolv.conf.bak
    echo "
nameserver 8.8.8.8
nameserver 8.8.4.4
    " | sudo tee /etc/resolv.conf
}


function pritunl_setup(){
    sudo cp /etc/resolv.conf /etc/resolv.conf.bak
    echo "
nameserver 172.18.0.2
search localdomain
    " | sudo tee /etc/resolv.conf
}

function pritunl_cleanup(){
    sudo cp /etc/resolv.conf.bak /etc/resolv.conf
}

export AWS_CACHE_DIR=~/.aws/dr/cache
export AWS_CONFIG_FILE=~/.aws/dr/config
export AWS_SHARED_CREDENTIALS_FILE=~/.aws/credentials
export SSO_ROLE_NAME=Developer
export RCP_USER="$USER"
# BEGIN ANSIBLE MANAGED BLOCK DEV_SSH_CONFIG
export DR_BECOME_PASS_ENC=U2FsdGVkX1/Kwv4oTdLed++N2qAR2KT7qTNi87L9rA2/RUGJw27R3IjxTv1+csx006AVXXtRWmM=

ssh() {
  if echo "$@" | grep -q -P 'moxi\d+|rcp\d+|moxi@'; then
    /usr/bin/ssh "$@"
  elif echo "$@" | grep -q -P 'moxi_local|rcp_local'; then
    printf "\033[0;33mInjecting RCP credential\033[0m\n" >&2
    sshpass -f ~/.ssh/rcp.credential /usr/bin/ssh "$@"
  elif echo "$@" | grep -q -P 'pi\d+|rapa\d+|pi@|pi_local|rapa_local'; then
    printf "\033[0;33mInjecting RAPA credential\033[0m\n" >&2
    sshpass -f ~/.ssh/rapa.credential /usr/bin/ssh "$@"
  elif echo "$@" | grep -q -P 'pcdu\d+|rapb\d+|moxi_pcdu@|pcdu_local|rapb_local'; then
    printf "\033[0;33mInjecting RAPB credential\033[0m\n" >&2
    sshpass -f ~/.ssh/rapb.credential /usr/bin/ssh "$@"
  elif echo "$@" | grep -q -P 'gpu\d+|rpg\d+|moxi_gpu@|gpu_local|rgp_local'; then
    printf "\033[0;33mInjecting RGP credential\033[0m\n" >&2
    sshpass -f ~/.ssh/rgp.credential /usr/bin/ssh "$@"
  else
    /usr/bin/ssh "$@"
  fi
}

scp() {
  if echo "$@" | grep -q -P 'pi\d+|rapa\d+|pi@'; then
    printf "\033[0;33mInjecting RAPA credential\033[0m\n" >&2
    sshpass -f ~/.ssh/rapa.credential /usr/bin/scp "$@"
  elif echo "$@" | grep -q -P 'pcdu\d+|rapb\d+|moxi_pcdu@'; then
    printf "\033[0;33mInjecting RAPB credential\033[0m\n" >&2
    sshpass -f ~/.ssh/rapb.credential /usr/bin/scp "$@"
  elif echo "$@" | grep -q -P 'gpu\d+|rpg\d+|moxi_gpu@'; then
    printf "\033[0;33mInjecting RGP credential\033[0m\n" >&2
    sshpass -f ~/.ssh/rgp.credential /usr/bin/scp "$@"
  else
    /usr/bin/scp "$@"
  fi
}
# END ANSIBLE MANAGED BLOCK DEV_SSH_CONFIG
