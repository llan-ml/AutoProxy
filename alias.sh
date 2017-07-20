#!/bin/bash

AUTOPROXY_PATH=$(cd `dirname $0`; pwd)

echo "alias proxy_on=\"${AUTOPROXY_PATH}/script.sh on\"" >> ${HOME}/.bashrc
echo "alias proxy_off=\"${AUTOPROXY_PATH}/script.sh off\"" >> ${HOME}/.bashrc
echo "alias proxy_list=\"${AUTOPROXY_PATH}/script.sh list\"" >> ${HOME}/.bashrc
