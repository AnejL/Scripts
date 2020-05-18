#!/bin/bash

function prompt() {
	read -p "$1: " -r
}

prompt "Identity"
id=$REPLY
prompt "Password"
pass=$REPLY

echo -e "Copy the commands one by one\n------------------"

echo "nmcli con add type wifi ifname wlp3s0 con-name eduroam ssid eduroam"
echo "nmcli con edit id eduroam"
echo "set ipv4.method auto"
echo "set 802-1x.eap peap"
echo "set 802-1x.phase2-auth mschapv2"
echo "set 802-1x.identity $id"
echo "set 802-1x.password $pass"
echo "set wifi-sec.key-mgmt wpa-eap"
echo "save"
echo "activate"

echo "------------------"
