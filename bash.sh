#!/bin/bash
#
# $#  : number of arguments

# here your code starts

# privileges has to be set by the process which starts this script

AUTOPROXY_PATH=$(dirname $0)
cd ${AUTOPROXY_PATH}
source proxy_setting.sh
export HTTP_HOST=${HTTP_HOST:-""}
export HTTP_PORT=${HTTP_PORT:-""}

export HTTPS_HOST=${HTTPS_HOST:-""}
export HTTPS_PORT=${HTTPS_PORT:-""}

fix_new_line() {
    if [[ $(tail -c 1 "$1" | wc --lines ) = 0 ]]; then
        echo >> "$1"
    fi
}

list_proxy() {
	echo
	echo -e "\e[1m Bash proxy settings \e[0m"
	lines="$(cat $HOME/.bashrc | grep proxy -i | wc -l)"
	if [ "$lines" -gt 0 ]; then
		cat $HOME/.bashrc | grep proxy -i | sed "s/\=/\ /g"
	else
		echo -e "\e[36m None \e[0m"
	fi
}

unset_proxy() {
	if [ ! -e "$HOME/.bashrc" ]; then
		return
	fi
	sed -i "/proxy\=/d" $HOME/.bashrc
	sed -i "/PROXY\=/d" $HOME/.bashrc
}

set_proxy() {
	if [ ! -e "$HOME/.bashrc" ]; then
		touch "$HOME/.bashrc"
	fi

	echo -n "" > bash_config.tmp

	echo "http_proxy=\"http://${HTTP_HOST}:${HTTP_PORT}\"" >> bash_config.tmp
	echo "https_proxy=\"https://${HTTPS_HOST}:${HTTPS_PORT}\"" >> bash_config.tmp
	echo "HTTP_PROXY=\"http://${HTTP_HOST}:${HTTP_PORT}\"" >> bash_config.tmp
	echo "HTTPS_PROXY=\"https://${HTTPS_HOST}:${HTTPS_PORT}\"" >> bash_config.tmp

	cat bash_config.tmp | tee -a $HOME/.bashrc > /dev/null
	rm bash_config.tmp
	return
}

if [ "$#" = 0 ]; then
	exit
fi

if [ "$1" = "unset" ]; then
	# that's what is needed
	unset_proxy
	source "$HOME/.bashrc"
	exit
elif [ "$1" = "list" ]; then
	list_proxy
	exit
elif [ "$1" = "set" ]; then
	unset_proxy
	set_proxy
	source "$HOME/.bashrc"
	exit
fi

