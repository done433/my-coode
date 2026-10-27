#!/bin/bash
sudo systemctl stop --now ufw
sudo systemctl disable --now ufw
sudo ufw --force reset
sudo ufw logging low
sudo ufw default deny incoming
sudo ufw default deny outgoing


sudo ufw deny in from ::/0
sudo ufw deny out from ::/0

sudo ufw allow in on lo
sudo ufw allow out on lo

sudo ufw allow out to 127.0.0.1 proto tcp port 9040   # TransPort
sudo ufw allow out to 127.0.0.1 proto tcp port 9050   # SOCKS Proxy
sudo ufw allow out to 127.0.0.1 proto tcp port 9051   # ControlPort
sudo ufw allow out to 127.0.0.1 proto udp port 53     # DNS

sudo tee /etc/sysctl.d/99-hardening.conf >/dev/null <<'EOF'
net.ipv4.icmp_echo_ignore_all=1
net.ipv4.conf.all.accept_redirects=0
net.ipv4.conf.default.accept_redirects=0
net.ipv4.conf.all.send_redirects=0
net.ipv4.conf.default.send_redirects=0
net.ipv4.conf.all.rp_filter=1
net.ipv4.conf.default.rp_filter=1
net.ipv6.conf.all.disable_ipv6=1
net.ipv6.conf.default.disable_ipv6=1
##net.ipv6.conf.lo.disable_ipv6 = 1
EOF


sudo sysctl --system

sudo ufw enable
sudo systemctl enable --now ufw
sudo systemctl start --now ufw 

sudo ./test.sh
