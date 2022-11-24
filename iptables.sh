#!/bin/bash

iptables -I INPUT -p tcp -m tcp --dport 80 -j ACCEPT
iptables -I INPUT -p tcp -m tcp --dport 443 -j ACCEPT
iptables -I INPUT -p tcp -m tcp --dport 8080 -j ACCEPT
iptables -I INPUT -p tcp -m tcp --dport 21 -j ACCEPT
iptables -I INPUT -p tcp -m tcp --dport 53 -j ACCEPT
iptables -I INPUT -p tcp -m tcp --dport 444 -j ACCEPT
iptables -I INPUT -p tcp -m tcp --dport 1080 -j ACCEPT
iptables -I INPUT -p tcp -m tcp --dport 3128 -j ACCEPT
iptables -I INPUT -p tcp -m tcp --dport 5000 -j ACCEPT
iptables -I INPUT -p tcp -m tcp --dport 5099 -j ACCEPT
iptables -I INPUT -p tcp -m tcp --dport 8000 -j ACCEPT
iptables -I INPUT -p tcp -m tcp --dport 8443 -j ACCEPT
iptables -I INPUT -p tcp -m tcp --dport 9392 -j ACCEPT
iptables -I INPUT -p tcp -m tcp --dport 5601 -j ACCEPT
iptables -I INPUT -p udp -m udp --dport 1194 -j ACCEPT

echo "Ports opened"
