#!/bin/bash

cd $(dirname $0)
source proxy_setting.sh

if [[ "$1" = "on" ]]; then
  sudo bash $2.sh set
  exit
elif [[ "$1" = "off" ]]; then
  sudo bash $2.sh unset
  exit
elif [[ "$1" = "list" ]]; then
  sudo bash apt.sh list
  sudo bash bash.sh list
  sudo bash environment.sh list
  sudo bash git.sh list
  exit
fi

