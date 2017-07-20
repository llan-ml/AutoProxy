#!/bin/bash
#
# $#  : number of arguments

# here your code starts

# privileges has to be set by the process which starts this script

AUTOPROXY_PATH=$(dirname $0)
cd ${AUTOPROXY_PATH}

export HTTP_HOST=${HTTP_HOST:-""}
export HTTP_PORT=${HTTP_PORT:-""}

export HTTPS_HOST=${HTTPS_HOST:-""}
export HTTPS_PORT=${HTTPS_PORT:-""}

list_proxy() {
	echo
	echo -e "\e[1m git proxy settings \e[0m"
	echo -e "\e[36m HTTP  Proxy \e[0m" $(git config --global http.proxy)
}

unset_proxy() {
	git config --global --unset http.proxy
	git config --global --unset https.proxy
}

set_proxy() {
	git config --global http.proxy "http://${HTTP_HOST}:${HTTP_PORT}"
	git config --global https.proxy "https://${HTTPS_HOST}:${HTTPS_PORT}"
}


git_available="$(which git)"
if [ "$git_available" = "" ]; then
	exit
fi

if [ "$#" = 0 ]; then
	exit
fi

if [ "$1" = "unset" ]; then
	# that's what is needed
	unset_proxy
	exit
	# toggle proxy had issues with commenting and uncommenting
	# dropping the feature currently
elif [ "$1" = "list" ]; then
	list_proxy
	exit
elif [ "$1" = "set" ]; then
	unset_proxy
	set_proxy
	exit
fi

