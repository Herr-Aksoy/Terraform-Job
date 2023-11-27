#!/bin/bash
apt update -y
apt install unattended-upgrades -y # ?
cat <<EOF > /etc/apt/apt.conf.d/20auto-upgrades
Apt::Periodic::Update-Package-Lists "1";
Apt::Periodic::Unattended-Upgrade "1";
Apt::Periodic::Download-Upgradeable-Packages "1";
Apt::Periodic::AutocleanInterval "7";
EOF
# cat <<EOF > /etc/systemd/system/prometheus.service            ## Bu kisim prometheus icin
# [Unit]
# Description=Prometheus Service
# After=network.target

# [Service]
# Type=simple
# ExecStart=/usr/local/bin/prometheus/prometheus --config.file=/usr/local/bin/prometheus/prometheus.yml

# [Install]
# WantedBy=multi-user.target
# EOF

systemctl start unattended-upgrades
systemctl enable unattended-upgrades
apt install docker.io -y
systemctl start docker
systemctl enable docker
usermod -a -G docker ubuntu
newgrp docker
docker --version
apt install git-all
git version
apt install -y nginx
service nginx start

# https://prometheus.io/download/#:~:text=amd64-,prometheus,-The%20Prometheus%20monitoring
# üsteki yerden baglanti geliyor.

# wget https://github.com/prometheus/prometheus/releases/download/v2.45.1/prometheus-2.45.1.linux-amd64.tar.gz
# tar -xvf prometheus-2.45.1.linux-amd64.tar.gz
# rm -rf prometheus-2.45.1.linux-amd64.tar.gz
# sudo rm -rf /usr/local/bin/prometheus/*
# cd prometheus-2.45.1.linux-amd64
# sudo cp -r . /usr/local/bin/prometheus/
# sudo service prometheus start

