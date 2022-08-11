#!/bin/bash
# Author: Timo Bergen <mail@timobergen.de>
# Date: 11.08.2022
# Purpose: Restrict Pi-hole/DNS (Port 53) Access to mentioned DynDNS/IPs. :)

source config.txt

### Script
# get existing rulesets and wipe them
for ip in $(ufw status numbered | grep 53 | grep -oE '((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])'); do
  sudo ufw delete allow from $ip to any port 53
done

# resolve domains and them to ufw
for i in $dyndns_domains; do
  current_domain=$(getent hosts $i | awk '{ print $1 }')
  sudo ufw allow from $current_domain to any port 53
done

# reload 
sudo ufw reload
