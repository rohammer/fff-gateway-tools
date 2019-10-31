#!/bin/bash

# read config 
. /etc/dyn_announce_gw_bw.conf

for bat in /sys/class/net/bat*; do
        iface=${bat##*/}
        leases=$(dhcp-lease-list 2>/dev/null | eval grep -c \${$iface[1]})
#       leases=$(/usr/local/bin/udhcpd-leases.py /var/lib/misc/udhcpd-${iface}.leases | wc -l)
        maxleases=$(eval echo \${$iface[0]})
        if [ $maxleases -gt $leases ]; then
                
                eval batctl -m $iface gw_mode server "\${$iface[2]}mbit/\${$iface[3]}mbit"
        else
                batctl -m $iface gw_mode off
        fi
done

