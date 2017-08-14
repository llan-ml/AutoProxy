#!/bin/bash

set -e

AUTOPROXY_PATH=$(cd `dirname $0`; pwd)

echo "alias proxy_on=\"${AUTOPROXY_PATH}/script.sh on\"" >> ${HOME}/.bashrc
echo "alias proxy_off=\"${AUTOPROXY_PATH}/script.sh off\"" >> ${HOME}/.bashrc
echo "alias proxy_list=\"${AUTOPROXY_PATH}/script.sh list\"" >> ${HOME}/.bashrc

ssh -t root@localhost  ' /bin/bash -i -c "
  set -e
  '"echo 'alias proxy_on=\\\"${AUTOPROXY_PATH}/script.sh on\\\"'"' > ~/.bash_aliases
  '"echo 'alias proxy_off=\\\"${AUTOPROXY_PATH}/script.sh off\\\"'"' >> ~/.bash_aliases
  '"echo 'alias proxy_list=\\\"${AUTOPROXY_PATH}/script.sh list\\\"'"' >> ~/.bash_aliases
"'

sudo cp cert/CA.crt /usr/local/share/ca-certificates
sudo update-ca-certificates
