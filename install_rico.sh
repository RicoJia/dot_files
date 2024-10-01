#!/bin/bash

# 1. First and foremost
    # 1. VPN
    # 2. ssh 
    # 3. Port custom data over
# 2. General Procedure 
    # 0. add SSH key to github: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
    # - Download file exchange ports
    # 1. bashrc, inputrc
    # 2. chrome, firefox,
    #   - vimium
    # slack, google desktop
    # 4. github accounts
    # 5. vscode
    #   - C-S-E: the Language Support application and in the Language tab select XIM for keyboard input method system.
    # vim
    # 	1. upgrade to vim 8 https://itsfoss.com/vim-8-release-install/
    # 5. clang-format-10

# A sample work computer compatible repo:
# origin	git@github-personal:RicoJia/notes.git (fetch)
# origin	git@github-personal:RicoJia/notes.git (push)
# vscode-origin	git@github.com:RicoJia/notes.git (fetch)
# vscode-origin	git@github.com:RicoJia/notes.git (push)

################################################
# Setting up Screenshot keyboard
# https://askubuntu.com/questions/1407422/screenshot-selection-in-22-04
#Settings → keyboard → keyboard shortcuts → custom shortcuts

# quit when errors occur
set -e

# Ensure Sudo Privileges
if [[ ${UID} -ne 0 ]]
then
	echo "Please run sudo ${0}"
	exit 1
fi

install_barebone(){
	mv vimrc ~/.vimrc
	mv bashrc ~/.bashrc
	sudo apt-get update
	sudo apt-get upgrade
}

install_terminator(){
	sudo apt-get install -y terminator
}

install_vim(){

	apt install node
	apt install npm
	# vim-instant-markdown
	npm -g install instant-markdown-d
	pip3 install --user smdv
	curl -LO https://github.com/BurntSushi/ripgrep/releases/download/12.1.1/ripgrep_12.1.1_amd64.deb
	dpkg -i ripgrep_12.1.1_amd64.deb
	rm -rf ripgrep*

	# Upgrade vim to vim8.2 (if you see stuff with coc vim, and vim fugitive, uninstall them, then reinstall, PlugClean and PluginClean)

	sudo add-apt-repository ppa:jonathonf/vim -y
	sudo apt update
	sudo apt upgrade
	sudo apt install vim
}
install_office(){
	apt install libreoffice
}

install_clang(){
	sudo apt install clang
	sudo apt-get install -y vim-gtk
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash

	sudo apt install cmake
	sudo apt install clang-format
}

install_vscode(){
	# TODO
	pip3 install pytest-vscodedebug
}

# Commands
install_barebone
#install_terminator
#install_vim




