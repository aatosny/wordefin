#!/bin/bash

# Terminal command to launch Wordefin

case $1 in
	-h|--help) 
		cat /usr/share/wordefin/help.txt
		;;
	-g) 
		perl /etc/wordefin/scripts/main.pl
		;;
	-t|"") 
		perl /etc/wordefin/scripts/wf.pl
		;;
	--uninstall)
		sudo cp /etc/wordefin/scripts/uninstall.sh /tmp/
		sudo chmod a+x /tmp/uninstall.sh
		sudo bash /tmp/uninstall.sh 
		;;
	*)
		echo "Error: Invalid flag $1"
		cat /usr/share/wordefin/help.txt
		;;
esac