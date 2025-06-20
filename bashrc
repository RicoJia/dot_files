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

function gsub_update_rico(){
	git submodule update --init --recursive
}

###############################################
# Orin
###############################################


wifi_orin_connect(){
    # if you see wpa issues, do wpa_passphrase <SSID> <PASSWORD> | sudo tee /etc/wpa_supplicant.conf
    set -ex

    sudo rfkill unblock wifi
    # temproarily assigns a static ip. Will be gone after reboo
    sudo ip addr add 192.168.1.188/24 dev wlan0

    sudo ip link set wlan0 up
    sudo wpa_supplicant -B -i wlan0 -c /etc/wpa_supplicant.conf
    echo "this might take a while"
    echo "prepend domain-name-servers 8.8.8.8 1.1.1.1;" | sudo tee -a /etc/dhcp/dhclient.conf
    sudo dhclient wlan0
}


#
###############################################
# Personal
###############################################
# source ~/file_exchange_port/Fun_Projects/Junior_Project/junior_ws/devel/setup.bash

function cp_rcs(){
    cp /home/${USER}/.bashrc /home/${USER}/dot_files/bashrc
    cp /home/${USER}/.vimrc /home/${USER}/dot_files/vimrc
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
    files=$(git status --porcelain | awk '/^[^D]/ {print $2}')

    CPP_FILES_TO_LINT=$(echo ${files} | grep -E "\.(cpp|hpp|h)$")
    if [[ -n $CPP_FILES_TO_LINT ]]; then
        echo ${CPP_FILES_TO_LINT} | xargs clang-format -i
        echo "Linted cpp files: ${CPP_FILES_TO_LINT}"
    else
        echo "C++ linting: No files to lint"
    fi

    CMAKELISTS_TO_LINT=$(echo ${files} | grep -E "CMakeLists\.txt$")
    if [[ -n $CMAKELISTS_TO_LINT ]]; then
        echo "$CMAKELISTS_TO_LINT" | xargs cmake-format -i
        echo "Linted CMakeLists.txt: $CMAKELISTS_TO_LINT"
    else
        echo "CMakeLists linting: no files to process"
    fi


    PYTHON_FILES_TO_LINT=$(echo "$files" | grep -E '\.py$')
    if [[ -n $PYTHON_FILES_TO_LINT ]]; then
        echo ${PYTHON_FILES_TO_LINT} | xargs black
        echo ${PYTHON_FILES_TO_LINT} | xargs isort
        echo "Linted .py files: ${PYTHON_FILES_TO_LINT}"
    else
        echo "Python linting: No files to lint"
    fi

    MARKDOWN_FILES_TO_LINT=$(echo "$files" | grep -E '\.(md|markdown)$')
    if [[ -n $MARKDOWN_FILES_TO_LINT ]] ; then
        echo ${MARKDOWN_FILES_TO_LINT} | xargs markdownlint -q -f
        echo "Linted Markdown files: ${MARKDOWN_FILES_TO_LINT}"
    else
        echo "Markdown linting: No files to lint"
    fi
}


export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
export PATH=$PATH:/home/rico/.local/bin

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export ROS_MASTER_URI=http://localhost:11311
export ROS_HOSTNAME=$(hostname)

source /opt/ros/iron/setup.bash

bind -x '"\C-f": navi'
