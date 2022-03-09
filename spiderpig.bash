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
BASHSTR="LEGAL DISCLAIMER: This computer system is the property of TEAM? LLC. By using this system, all users acknowledge notice of, and agree to comply with, the Acceptable User of Information Technology Resources Policy (AUP). By using this system, you consent to these terms and conditions. Use is also consent to monitoring, logging, and use of logging to prosecute abuse. If you do not wish to comply with these terms and conditions, you must LOG OFF IMMEDIATELY."

# Stop SSH Service (does not include killing attached processes)
service sshd stop

# Change Default Password
passwd root

# Firewall Configuration
iptables -F
ip6tables -F
iptables -A OUTPUT -p tcp -m multiport --dports 80,443 -j ACCEPT

iptables -A INPUT -m state --state RELATED,ESTABLISHED -p tcp -j ACCEPT
iptables -A INPUT -m state --state NEW,RELATED,ESTABLISHED -p tcp --dport 110 -j ACCEPT
iptables -A INPUT -m state --state NEW,RELATED,ESTABLISHED -p tcp --dport 25 -j ACCEPT
iptables -A INPUT -m state --state NEW,RELATED,ESTABLISHED -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -m state --state NEW,RELATED,ESTABLISHED -p tcp --dport 443 -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED -p tcp --sport 9997 -j ACCEPT
iptables -A INPUT -m state --state RELATED,ESTABLISHED -p udp --sport 53 -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED -p tcp --sport 389 -j ACCEPT
iptables -A INPUT -m state --state NEW,ESTABLISHED -p tcp --dport 143 -j ACCEPT
iptables -A INPUT -m state --state NEW,ESTABLISHED -p tcp -m multiport --dports 80,443 -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED -p tcp --sport 8080 -j ACCEPT
iptables -A INPUT -p icmp -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -p udp --dport 123 -j ACCEPT

iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -p tcp -j ACCEPT
iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -p tcp --dport 110 -j ACCEPT
iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -p tcp --sport 25 -j ACCEPT
iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -p tcp --dport 80 -j ACCEPT
iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -p tcp --dport 443 -j ACCEPT
iptables -A OUTPUT -m state --state NEW,ESTABLISHED -p tcp --dport 9997 -j ACCEPT
iptables -A OUTPUT -m state --state NEW,ESTABLISHED -p udp --dport 53 -j ACCEPT
iptables -A OUTPUT -m state --state NEW,ESTABLISHED -p tcp --dport 389 -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED -p tcp --sport 143 -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED -p tcp -m multiport --sports 80,443 -j ACCEPT
iptables -A OUTPUT -m state --state NEW,ESTABLISHED -p tcp --dport 8080 -j ACCEPT
iptables -A OUTPUT -p icmp -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
iptables -A OUTPUT -p udp --dport 123 -j ACCEPT

iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP
ip6tables -P INPUT DROP
ip6tables -P OUTPUT DROP
ip6tables -P FORWARD DROP

# Splunk Setup 
curl -L https://github.com/Cyber-Chads/CCDC-Chads2/raw/main/xaa > fed1.rpm
curl -L https://github.com/Cyber-Chads/CCDC-Chads2/raw/main/xab > fed2.rpm
cat fed1.rpm fed2.rpm > fed.rpm
rpm -i fed.rpm
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