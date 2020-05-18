#!/bin/bash

#if no arguments are supplied print lsblk devices
if [ $# -eq 0 ]; then
	tput setaf 4
	echo "output of lsblk"
	lsblk
	tput setaf sgr0
	exit 1
fi

#print help
if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
	echo "Mount utilty by me..."
	tput setaf 2
	echo "USAGE: mt [partition (/dev/sdb1 -> b1)] [location (optional)]"
	tput sgr0
	exit 1
fi

#print mountpoint
if [ "$1" == "l" ]; then
	if [ -d "/tmp/mt" ]; then
		tput setaf 4
		echo -n "Mountpoint: "
		cat /tmp/mt/last
		tput sgr0
		exit 0
	fi
	echo "You have to mount a device first!"
	exit 1
fi

#handle unmounting
if [ "$1" == "u" ]; then
	if [ -d "/tmp/mt" ]; then
		loc=$(cat /tmp/mt/last)
		if [ -d "$loc" ]; then
			sudo umount $loc
			rm -rf /tmp/mt
			echo "Unmounted from $loc successfully!"
			exit 0
		fi
		echo "This directory doesn't exist anymore!"
		exit 1
	fi
	echo "You have to mount a device first!"
	exit 1
fi

#default mount point is /mnt but if the user specifies a valid one it changes
dir="/media/mt0"
if [ $# -eq 2 ] && [ "$2" != "" ]; then
	dir="$2"
	if [ ! -d "$dir" ]; then
		echo "Mount point $(tput setaf 1)$dir$(tput sgr0) does not exist!"	
		exit 1
	fi
fi

#handle if device could exist
if [[ ! $1 =~ ^[a-z1-9]{1,3}$ ]]; then
	tput setaf 1
	echo "Device does not exist! E.g. a is for /dev/sda..."
	tput setaf sgr0
	exit 1
fi


#if temp storage file doesn't exist create one
if [ ! -d "/tmp/mt" ]; then
	mkdir "/tmp/mt"
	touch /tmp/mt/last
fi

sudo mount "/dev/sd$1" "$dir"
echo "$dir" > /tmp/mt/last
echo "Mounted /dev/sd$1 to $dir successfully!"

ranger $dir

echo "Exited ranger!"

exit 0
