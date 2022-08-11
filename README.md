# pihole-ufw-dyndns

## intro

This is a little script i built myself, so that i can host a "public-faced" Pi-hole for myself. This script resolves defined domains and puts them into ufw (uncomplicated firewall, Ubuntu 22.04).

## idea & way to profit
So my Idea was, im constantly switching between two homes and thought why host a pi-hole at each home. I could just host a Pi-hole in the Cloud (like Hetzner or Digital Ocean) and just restrict access to it.
Next thing was how to realize this, i tried it through dnsmasq, unbound (pi-hole doesnt use unbound :( ) and then iptables. I myself didn't want to work with iptables and ufw was already pre-installed on Ubuntu 22.04.

Actually the script is pretty simple, first step: get existing rulesets and wipe them.
I for-loop over every IP i can get with `ufw status numbered` -> grep 53 -> grep IP-Addresses. Then just loop over this list with my `ufw delete` command.

Second step: resolve domains and allow them through ufw.
New loop that iterates over my config.txt. I resolve the domain with `getent` and just run it through `ufw allow from $ip to any port 53`. 

Done!

## safety

Please use at your own caution. I know this is probably not the safest approach, but it works.
If you have something to contribute or think this is no good idea, please tell me :)
