#!/bin/bash

# Based on https://somesquares.org/blog/2017/10/Raspberry-Pi-router/

SSID="MY-NETWORK"
WPA_PASSPHRASE="MY-PASSPHRASE"

# Enable ssh

touch /ssh

# Configure hostapd
# hostapd the access point software, which creates and broadcasts a wireless network to which other computers can connect.

apt-get install -y hostapd

HOSTAPD_CONF_FILE="/etc/hostapd/hostapd.conf"
touch $HOSTAPD_CONF_FILE
cat > $HOSTAPD_CONF_FILE <<- EOM
interface=wlan0
ssid=$SSID
hw_mode=g
channel=7
ht_capab=[HT40][SHORT-GI-20][DSSS_CCK-40]
wmm_enabled=0
macaddr_acl=0
auth_algs=1
wpa=2
ignore_broadcast_ssid=0
wpa_passphrase=$WPA_PASSPHRASE
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
EOM
# driver=nl80211

HOSTAPD_DEFAULTS_FILE="/etc/defaults/hostapd"

echo "DAEMON_CONF=\"/etc/hostapd/hostapd.conf\"" >> $HOSTAPD_DEFAULTS_FILE

# Configure dnsmasq
# dnsmasq manages the addresses that will be handed out to computers connecting on the new network

apt-get install -y dnsmasq

DHCPCD_CONF_FILE="/etc/dhcpcd.conf"

cat >> $DHCPCD_CONF_FILE <<- EOM
interface wlan0
static ip_address=192.168.1.1
static routers=192.168.1.1
static domain_name_servers=8.8.8.8
EOM

DNSMASQ_CONF_FILE="/etc/dnsmasq.conf"

cat >> $DHCPCD_CONF_FILE <<- EOM
interface=wlan0
domain-needed
bogus-priv
dhcp-range=192.168.1.8,192.168.1.250,12h
EOM

# Configure IP routing

SYSCTL_CONF_FILE="/etc/sysctl.conf"

echo "net.ipv4.ip_forward=1" >> $SYSCTL_CONF_FILE

iptables -t nat -A  POSTROUTING -o eth0 -j MASQUERADE
iptables -A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT

# Installing iptables-persistent as the final step causes it to notice you’ve changed the defaults already, and prompts you to save your work. It’s very convenient! 
# makes sure that settings about how to route packets between the wired Ethernet device and the WiFi device are saved, so that the connection will be restored when the Pi is restarted.

apt-get install -y iptables-persistent