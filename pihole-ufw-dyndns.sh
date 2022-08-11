#!/bin/bash
# Author: Timo Bergen <mail@timobergen.de>
# Date: 11.08.2022
# Purpose: Restrict Pi-hole/DNS (Port 53) Access to mentioned DynDNS/IPs. :)

### Variables and config
# source config
source config.txt
# check for logs folder
if [ ! -d logs ]; then
  mkdir -p logs
fi
# if logging enabled then log
if $logging; then
  exec 3>&1 4>&2
  trap 'exec 2>&4 1>&3' 0 1 2 3
  exec 1>logs/log-$(date +%Y-%m-%d).out 2>&1
  echo "### https://github.com/bym0/pihole-ufw-dyndns ###"
  echo "Domains: "$dyndns_domains
  echo "Logging: "$logging
fi

### Script
# get existing rulesets and wipe them
for ip in $(ufw status numbered | grep 53 | grep -oE '((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])'); do
  sudo ufw delete allow from $ip to any port 53
done

# resolve domains and allow/add them through/to ufw
for i in $dyndns_domains; do
  current_domain=$(getent hosts $i | awk '{ print $1 }')
  sudo ufw allow from $current_domain to any port 53
done

# reload 
sudo ufw reload
