#!/bin/bash

BASHSTR="LEGAL DISCLAIMER: This computer system is the property of TEAM9 LLC. By using this system, all users acknowledge notice of, and agree to comply with, the Acceptable User of Information Technology Resources Polity (AUP). By using this system, you consent to these terms and conditions. Use is also consent to monitoring, logging, and use of logging to prosecute abuse. If you do not wish to comply with these terms and conditions, you must LOG OFF IMMEDIATELY"

service sshd stop
iptables -F
ip6tables -F

iptables -A OUTPUT -p tcp -m multiport --dports 80,443 -j ACCEPT
iptables -A INPUT -p udp --dport 123 -j ACCEPT
iptables -A OUTPUT -p udp --dport 123 -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

iptables -A INPUT -p icmp -m icmp --icmp-type 8 -m state --state NEW,RELATED,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p icmp -m icmp --icmp-type 0 -m state --state NEW,RELATED,ESTABLISHED -j ACCEPT


iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -m state --state NEW,RELATED,ESTABLISHED -j ACCEPT

iptables -A INPUT -p tcp --dport 8000 -j ACCEPT
iptables -A INPUT -p tcp --dport 8090 -j ACCEPT
iptables -A INPUT -p tcp --dport 9997 -j ACCEPT

iptables -A OUTPUT -p tcp --dport 8000 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 8090 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 9997 -j ACCEPT



iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP
ip6tables -P INPUT DROP
ip6tables -P OUTPUT DROP
ip6tables -P FORWARD DROP


# Configure Banners
echo "" > /etc/motd
echo $BASHSTR > /etc/motd
echo "" > /etc/issue
echo $BASHSTR > /etc/issue
echo "" > /etc/banner
echo $BASHSTR > /etc/banner

service splunk status
hostnamectl
ifconfig
