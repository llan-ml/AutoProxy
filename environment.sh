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
	echo -e "\e[1m Environment proxy settings \e[0m"
	lines="$(cat /etc/environment | grep proxy -i | wc -l)"
	if [ "$lines" -gt 0 ]; then
		cat "/etc/environment" | grep proxy -i | sed "s/\=/\ /g"
	else
		echo -e "\e[36m None \e[0m"
	fi
}

unset_proxy() {
	if [ ! -e "/etc/environment" ]; then
		return
	fi
	sed -i "/proxy\=/d" /etc/environment
	sed -i "/PROXY\=/d" /etc/environment
}

set_proxy() {
	if [ ! -e "/etc/environment" ]; then
		touch "/etc/environment"
	fi

	echo -n "" > bash_config.tmp

	echo "http_proxy=\"http://${HTTP_HOST}:${HTTP_PORT}\"" >> bash_config.tmp
	echo "https_proxy=\"https://${HTTPS_HOST}:${HTTPS_PORT}\"" >> bash_config.tmp
	echo "HTTP_PROXY=\"http://${HTTP_HOST}:${HTTP_PORT}\"" >> bash_config.tmp
	echo "HTTPS_PROXY=\"https://${HTTPS_HOST}:${HTTPS_PORT}\"" >> bash_config.tmp
  
  fix_new_line "/etc/environment"
	cat bash_config.tmp | tee -a /etc/environment > /dev/null
	rm bash_config.tmp
	return
}


if [ "$#" = 0 ]; then
	exit
fi

if [ "$1" = "unset" ]; then
	# that's what is needed
	unset_proxy
	exit
elif [ "$1" = "list" ]; then
	list_proxy
	exit
elif [ "$1" = "set" ]; then
	unset_proxy
	set_proxy
	exit
fi

