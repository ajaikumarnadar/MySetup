#!/bin/bash

opkg install bash

function refresh(){
opkg update
opkg install dnsmasq https-dns-proxy
uci show dhcp; uci show https-dns-proxy

}

function fresh(){
opkg update
opkg install dnsmasq https-dns-proxy
uci show dhcp; uci show https-dns-proxy

# Configure DoH provider Google

while uci -q delete https-dns-proxy.@https-dns-proxy[0]; do :; done
uci set https-dns-proxy.dns="https-dns-proxy"
uci set https-dns-proxy.dns.bootstrap_dns="8.8.8.8,8.8.4.4"
uci set https-dns-proxy.dns.resolver_url="https://dns.google/dns-query"
uci set https-dns-proxy.dns.listen_addr="127.0.0.1"
uci set https-dns-proxy.dns.listen_port="5053"
uci commit https-dns-proxy


# Configure DoH provider Cloudflare

while uci -q delete https-dns-proxy.@https-dns-proxy[1]; do :; done
uci set https-dns-proxy.dns="https-dns-proxy"
uci set https-dns-proxy.dns.bootstrap_dns="1.1.1.1,1.0.0.1"
uci set https-dns-proxy.dns.resolver_url="https://cloudflare-dns.com/dns-query"
uci set https-dns-proxy.dns.listen_addr="127.0.0.1"
uci set https-dns-proxy.dns.listen_port="5054"
uci commit https-dns-proxy

/etc/init.d/https-dns-proxy restart

}

$1