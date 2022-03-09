#!/bin/bash

# ---------- NOTES ---------- #
# You may have to change the  #
# file permissions of this    #
# bash file for it to run.    #
#                             #
# chmod 777 script-name.bash  #
#                             #
# Remove this file after use  #
# to ensure no malicious      #
# misuse.                     #
#                             #
# rm script-name.bash         #
#                             #
# Not included here are the   #
# config commands for unalias #
# and ntp (run unalias -a     #
# first)!!!                   #
# --------------------------- #

# Declare variables
BASHSTR="LEGAL DISCLAIMER: This computer system is the property of TEAM9 LLC. By using this system, all users acknowledge notice of, and agree to comply with, the Acceptable User of Information Technology Resources Polity (AUP). By using this system, you consent to these terms and conditions. Use is also consent to monitoring, logging, and use of logging to prosecute abuse. If you do not wish to comply with these terms and conditions, you must LOG OFF IMMEDIATELY"

# Stop SSH Service (does not include killing attached processes)
service sshd stop

# Change Default Password
passwd root

# Firewall Configuration
iptables -F
iptables -X
ip6tables -F
ip6tables -X

iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -p icmp -m icmp --icmp-type 8 -m state --state NEW,RELATED,ESABLISHED -j ACCEPT
iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p icmp -m icmp --icmp-type 0 -m state --state NEW,RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

iptables -A INPUT -p tcp -m tcp --dport 53 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 9997 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 8000 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 8001 -j ACCEPT
iptables -A INPUT -p udp -m udp --dport 123 -j ACCEPT
iptables -A INPUT -p udp -m udp --sport 123 -j ACCEPT
iptables -A INPUT -p udp -m udp --dport 53 -j ACCEPT


iptables -A OUTPUT -p tcp -m tcp --dport 53 -j ACCEPT
iptables -A OUTPUT -p udp -m udp --dport 53 -j ACCEPT
iptables -A OUTPUT -p tcp -m tcp --dport 80 -j ACCEPT
iptables -A OUTPUT -p tcp -m tcp --dport 443 -j ACCEPT
iptables -A OUTPUT -p tcp -m tcp --dport 9997 -j ACCEPT
iptables -A OUTPUT -p tcp -m tcp --dport 8000 -j ACCEPT
iptables -A OUTPUT -p tcp -m tcp --dport 8001 -j ACCEPT
iptables -A OUTPUT -p udp -m udp --dport 123 -j ACCEPT
iptables -A OUTPUT -p udp -m udp --sport 123 -j ACCEPT
iptables -A OUTPUT -p udp -m udp --dport 53 -j ACCEPT



iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP
ip6tables -P INPUT DROP
ip6tables -P OUTPUT DROP
ip6tables -P FORWARD DROP

# Splunk Setup 
wget https://github.com/Cyber-Chads/CCDC-Chads/raw/main/debSpl.deb
dpkg -i debSpl.deb

/opt/splunkforwarder/bin/splunk start --accept-license
/opt/splunkforwarder/bin/splunk enable boot-start
/opt/splunkforwarder/bin/splunk add forward-server 172.20.241.20:9997
/opt/splunkforwarder/bin/splunk add monitor /var/log
/opt/splunkforwarder/bin/splunk restart

service splunk status

# Configure Banners
echo "" > /etc/motd
echo $BASHSTR > /etc/motd
echo "" > /etc/issue
echo $BASHSTR > /etc/issue
echo "" > /etc/banner
echo $BASHSTR > /etc/banner

# Display System and Network Information
hostnamectl
ifconfig