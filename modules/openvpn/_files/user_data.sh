#!/bin/bash
sudo -s

apt-get update
curl -s https://swupdate.openvpn.net/repos/repo-public.gpg |apt-key add
echo "deb http://build.openvpn.net/debian/openvpn/stable xenial main" \
> /etc/apt/sources.list.d/openvpn-aptrepo.list

apt-get update
apt-get install -y python easy-rsa libpam-google-authenticator iptables-persistent
