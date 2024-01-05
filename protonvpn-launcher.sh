#!/bin/bash

#This script comes with no warranty whatsoever.  Tested on Mint 21.2 (Ubuntu 22.04).

ks="protonvpn-cli ks --permanent"
pvpn="protonvpn-cli"
curlip="curl -s ifconfig.co/json"
finished=0

clear
echo

while [ $finished -ne 1 ]
do
     	echo "What do you want to do?"
        echo
     	echo " 1 - Connect to the fastest server."
     	echo " 2 - Connect to the fastest P2P server."
        echo " 3 - Connect to the fastest Secure Core server."
        echo " 4 - Connect to a random server."
        echo " 5 - Connect to a specific location."
        echo " 6 - Change default protocol to TCP (Try if you have problems connecting)."
        echo " 7 - Change default protocol to UDP (Faster)."
        echo " 8 - Disconnect the VPN."
	echo " 9 - List current IP and location."
        echo "10 - Login/Reinitialize."
        echo
        echo "Exit and use protonvpn-cli --help for more options."
        echo

read -r servertype
     	echo
     	sleep 0.5
     	case $servertype in
     	1) clear ; $ks ; echo; echo "Normal server selected. Connect to Wifi or Ethernet Now! (If not already)"

echo
for n in {5..0}
do
        echo -ne "Connecting in $n seconds.\033[0K\r"
        sleep 1
done
        echo
        echo

$pvpn c -f && sleep 4 ; echo ; echo "Listed below is your IP and location:"

        $curlip | grep '"ip"\|city\|region_name\|"country"\|asn_org' && $pvpn s ; finished=1 ;;

     	2) clear ; $ks ; echo; echo "Fastest P2P Server selected. Connect to Wifi or Ethernet Now! (If not already)"

echo
for n in {5..0}
do
        echo -ne "Connecting in $n seconds.\033[0K\r"
        sleep 1
done
        echo
        echo

$pvpn c --p2p && sleep 4 ; echo ; echo "Listed below is your IP and location:"
        $curlip | grep '"ip"\|city\|region_name\|"country"\|asn_org' && $pvpn s ; finished=1 ;;

    3) clear ; $ks ; echo; echo "Fastest Secure Core server selected. Connect to Wifi or Ethernet Now! (If not already)"

echo
for n in {5..0}
do
        echo -ne "Connecting in $n seconds.\033[0K\r"
        sleep 1
done
        echo
        echo

$pvpn c --sc && sleep 4 ; echo ; echo "Listed below is your IP and location:"
        $curlip | grep '"ip"\|city\|region_name\|"country"\|asn_org' && $pvpn s ; finished=1 ;;

    4) clear ; $ks ; echo; echo "Random server selected. Connect to Wifi or Ethernet Now! (If not already)"

echo
for n in {5..0}
do
        echo -ne "Connecting in $n seconds.\033[0K\r"
        sleep 1
done
        echo
        echo

$pvpn c -r && sleep 4 ; echo ; echo "Listed below is your IP and location:"
        $curlip | grep '"ip"\|city\|region_name\|"country"\|asn_org' && $pvpn s ; finished=1 ;;

	5) clear ; $ks ; echo ; echo "Specific server selected.  Connect to Wifi or Ethernet Now! (If not already)"

echo
for n in {5..0}
do
        echo -ne "Opening menu in $n seconds.\033[0K\r"
        sleep 1
done
        echo

$pvpn c && sleep 4 ; echo ; echo "Listed below is your IP and location:"
        $curlip | grep '"ip"\|city\|region_name\|"country"\|asn_org' && $pvpn s ; finished=1 ;;

    6) clear ; echo ; echo "Changing default protocol to TCP." ; sleep 4 ; $pvpn config -p tcp ;;

    7) clear ; echo ; echo "Changing default protocol to UDP." ; sleep 4 ; $pvpn config -p udp ;;

	8) clear ; echo ;  echo "Are you sure you want to disconnect? If not, close this window now!!!" ; echo ; sleep 5

echo
for n in {5..0}
do
        echo -ne "Disconnecting in $n seconds.\033[0K\r"
        sleep 1
done
        echo
        echo

	 $pvpn ks --off ; $pvpn d; echo ; echo "YOU DISABLED THE VPN AND KILLSWITCH!!! THIS WILL LEAK YOUR IP!!! BE CAREFUL!!!" ; sleep 4 ; echo ; echo "Listed below is your IP and location:"
        $curlip | grep '"ip"\|city\|region_name\|"country"\|asn_org' && $pvpn s ; finished=1 ;;

	9) clear ; echo ; echo "You did not change your connection!!!" ; sleep 3 ; echo ; echo "Listed below is your IP and location:"
        $curlip | grep '"ip"\|city\|region_name\|"country"\|asn_org' && $pvpn s ; sleep 5 ;;

    10) clear ; echo ; echo "This will log you out," ; sleep 2
        echo "Reset to the default configuration," ; sleep 2
        echo "Then connect without killswitch for initial setup." ; sleep 5
        echo ; echo "THIS WILL DISABLE THE KILLSWITCH AND TEMPORARILY LEAK YOUR IP!!! BE CAREFUL!!!" ; sleep 5
        echo ; echo "It will reconnect WITH the killswitch 1 minute afterwards, and enable NetShield to block ads and malware domains." ; sleep 5
        echo ; echo "Are you sure? If not, close this window now!!!" ; echo ; sleep 5

for n in {5..0}
do
        echo -ne "Disconnecting in $n seconds.\033[0K\r"
        sleep 1
done
        echo

        $pvpn ks --off ; echo
        $pvpn d ; echo
        $pvpn logout ; echo
        $pvpn config -d
        echo
        echo "Type in your account name and hit enter, Proton will ask for your password." ; echo
        read -r username
     	echo
     	sleep 0.5
        $pvpn login $username
        echo ; sleep 1
        $pvpn c -f
        echo

for n in {5..0}
do
        echo -ne "Reconnecting in $n seconds.\033[0K\r"
        sleep 1
done
        echo
        clear
        $pvpn ns --ads-malware
        $ks
        $pvpn c -f && sleep 4 ; echo ; echo "Listed below is your IP and location:"

        $curlip | grep '"ip"\|city\|region_name\|"country"\|asn_org' && $pvpn s ; finished=1 ;;


    *) echo ; echo "You didn't enter an appropriate choice.  Try again."
	esac
     	echo
done

echo "Check these websites for more IP, DNS, or torrent leak testing:"
echo "https://browserleaks.com"
echo "https://ipleak.net"

sleep 30
