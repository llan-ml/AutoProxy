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

fix_new_line() {
    if [[ $(tail -c 1 "$1" | wc --lines ) = 0 ]]; then
        echo >> "$1"
    fi
}

list_proxy() {
	# inefficient way as the file is read twice.. think of some better way
	echo
	echo -e "\e[1m APT proxy settings \e[0m"
	lines="$(cat /etc/apt/apt.conf | grep proxy -i | wc -l)"
	if [ "$lines" -gt 0 ]; then
		cat /etc/apt/apt.conf | grep proxy -i | sed -e "s/Acquire//g" -e "s/\:\:/\ /g" -e "s/\;//g"
	else
		echo -e "\e[36m None \e[0m"
	fi
}

unset_proxy() {
	if [ ! -e "/etc/apt/apt.conf" ]; then
		return
	fi
	if [ "$(cat /etc/apt/apt.conf | grep proxy -i | wc -l)" -gt 0 ]; then
		sed "/Proxy/d" -i /etc/apt/apt.conf
	fi
}

set_proxy() {
	if [ ! -e "/etc/apt/apt.conf" ]; then
		touch "/etc/apt/apt.conf"
	fi
	echo -n "" > apt_config.tmp
	
  echo "Acquire::Http::Proxy \"http://${HTTP_HOST}:${HTTP_PORT}\";" >> apt_config.tmp
	echo "Acquire::Https::Proxy \"https://${HTTPS_HOST}:${HTTPS_PORT}\";" >> apt_config.tmp

  fix_new_line "/etc/apt/apt.conf"
	cat apt_config.tmp | tee -a /etc/apt/apt.conf > /dev/null
	rm apt_config.tmp
	return
}


apt_available="$(which apt)"
if [ "$apt_available" = "" ]; then
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

