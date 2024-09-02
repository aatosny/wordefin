#!/bin/bash

if [ "$EUID" -eq 0 ]
  then echo "Please do not run as root"
  exit
fi

rm -rfv /etc/wordefin/
rm -rfv /usr/share/wordefin/
rm -v /usr/bin/wordefin
rm -v $HOME/.local/share/applications/wordefin.desktop 2>/dev/null
rm -v /usr/local/share/applications/wordefin.desktop 2>/dev/null