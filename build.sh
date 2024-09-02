#!/bin/bash

if [ "$EUID" -eq 0 ]
  then echo "Please do not run as root"
  exit
fi


new=0
inlst=("")

intck() {
	if [[ $(find "$1" 2>/dev/null | wc -l) -ne 0 ]]; then
		inlst+=("$1")
	else
		new=$((new+1))
	fi
}
check_fs() {
	echo $1
	if [[ -d $1 ]]; then
		echo "[ YES ]"
	else
		echo "[ NOT FOUND ]"
		eval "$(basename "$1")"=$1
	fi
}
cpif() {
	if printf "%s\n" "${inlst[@]}" | grep -q "$2"; then
		echo "$2: Nothing to be done"
	else
		sudo cp -v $1 $2
	fi
}


# Check previous install

set -x

intck /usr/bin/wordefin
intck /usr/share/wordefin/help.txt
intck $HOME/Wordefin/example.txt
intck /etc/wordefin/scripts/lst.sh
intck /etc/wordefin/scripts/uninstall.sh
intck /etc/wordefin/scripts/main.pl
intck /etc/wordefin/scripts/wf.pl
intck /usr/share/wordefin/logo.svg
intck $HOME/.local/share/applications/wordefin.desktop 2>/dev/null

set +x

case $new in
	0)
		echo "Wordefin is already installed"
		exit 0
		;;
	[1-8])
		echo "Resolving $new files.."
		;;
	*)
		;;
esac

echo "${inlst[@]}"

# Repo check
echo "Checking repository..."

set -x
find \( -name "build.sh" -o -name "wordefin.sh" -o -name "help.txt" -o -name "example.txt" -o -name "wordefin.desktop" -o -name "lst.sh" -o -name "main.pl" -o -name "wf.pl" -o -name "uninstall.sh" -o -name "logo.svg" \)
isfind=$(find \( -name "build.sh" -o -name "wordefin.sh" -o -name "help.txt" -o -name "example.txt" -o -name "wordefin.desktop" -o -name "lst.sh" -o -name "main.pl" -o -name "wf.pl" -o -name "uninstall.sh" -o -name "logo.svg" \) | wc -l)
set +x

if [[ "$isfind" -ne 10 ]]; then
	echo "Error: Missing files in source"
	exit 1
fi

echo "OK"

echo ""
echo "Checking filesystem structure..."

# Filesystem structure check

set -x
check_fs /etc
check_fs /usr
check_fs /usr/bin
check_fs $HOME/.local/share/applications
set +x

if [[ -n $etc ]]; then
	echo "Error: Missing system directory: /etc"
	exit 1
fi
if [[ -n $usr ]]; then
	echo "Error: Missing system directory: /usr"
fi
if [[ -n $bin ]]; then
	echo "Error: Missing system directory: /usr/bin"
	exit 1
fi

# Create essential directories

set -x
sudo mkdir -p /etc/wordefin/scripts
sudo mkdir -p /usr/share/wordefin
mkdir -p $HOME/Wordefin

# Copy files

cpif ./bin/wordefin.sh /usr/bin/wordefin
cpif ./doc/help.txt /usr/share/wordefin/
cpif ./doc/example.txt $HOME/Wordefin/
cpif ./scripts/lst.sh /etc/wordefin/scripts/
cpif ./scripts/uninstall.sh /etc/wordefin/scripts
cpif ./scripts/main.pl /etc/wordefin/scripts/
cpif ./scripts/wf.pl /etc/wordefin/scripts/
cpif ./share/logo.svg /usr/share/wordefin/

set +x

if [[ -n $applications ]]; then
	check_fs /usr/local/share/applications
	if [[ -n $applications ]]; then
		echo "Warning: Unable to setup a desktop entry. You can manually copy share/wordefin.desktop from source to the desired directory."
	else	
		sudo cp ./share/wordefin.desktop /usr/local/share/applications/
	fi
else
	sudo cp ./share/wordefin.desktop $HOME/.local/share/applications/
fi

set -x
# Change permissions

sudo chmod a+rx /usr/bin/wordefin
sudo chmod a+rx /etc/wordefin/scripts/lst.sh
sudo chmod a+rx /etc/wordefin/scripts/uninstall.sh
sudo chmod a+rx /etc/wordefin/scripts/main.pl
sudo chmod a+rx /etc/wordefin/scripts/wf.pl
sudo chmod a+rwx /usr/local/share/applications/wordefin.desktop 2>/dev/null
sudo chmod a+rwx $HOME/.local/share/applications/wordefin.desktop 2>/dev/null
set +x

echo "Wordefin installed succesfully. To uninstall, run wordefin --uninstall."
