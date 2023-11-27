
#!/bin/bash
yum update -y
cat <<EOT > /etc/yum.repos.d/grafana.repo
[grafana]
name=grafana
baseurl=https://packages.grafana.com/oss/rpm
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://packages.grafana.com/gpg.key
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
EOT
cat <<EOF > /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus Service
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/prometheus/prometheus --config.file=/usr/local/bin/prometheus/prometheus.yml

[Install]
WantedBy=multi-user.target
EOF

cat <<EOF > /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target
[Service]
ExecStart=/etc/node_exporter/node_exporter
Restart=always
[Install]
WantedBy=multi-user.target
EOF

wget https://github.com/prometheus/prometheus/releases/download/v2.45.1/prometheus-2.45.1.linux-amd64.tar.gz
tar -xvf prometheus-2.45.1.linux-amd64.tar.gz
rm -rf prometheus-2.45.1.linux-amd64.tar.gz
sudo rm -rf /usr/local/bin/prometheus/*
cd prometheus-2.45.1.linux-amd64
sudo cp -r . /usr/local/bin/prometheus/
sudo service prometheus start

# cat <<EOT > ./prometheus.yml            ## Docker da calisan prometheus icin
# global:
#     scrape_interval: 15s
# scrape_configs:
#     - job_name: prometheus
#     static_configs:
#     -targets: ["localhost:9090]
# EOT




yum install grafana -y


yum install git -y
# yum install -y docker                       #Bu kisim docker da calisan prometheus icin
# yum amazon-linux-extras install  -y
# systemctl start docker
# systemctl enable docker
# usermod -aG docker ec2-user
# docker pull prom/prometheus
# docker network create network
# docker volume create prometheus-data
# docker container run --name prometheus -v prometheus.yml -v prometheus-data:/prometheus -p 9090:9090 prom/prometheus


systemctl start grafana-server
systemctl enable grafana-server


wget https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz
tar xzf node_exporter-1.7.0.linux-amd64.tar.gz
rm -rf node_exporter-1.7.0.linux-amd64.tar.gz
sudo mv node_exporter-1.7.0.linux-amd64 /etc/node_exporter/
systemctl daemon-reload
systemctl restart node_exporter
systemctl enable node_exporter

#sudo rm -rf /etc/prometheus/prometheus.yml

# cat <<EOF > /usr/local/bin/prometheus/prometheus.yml    # /etc/prometheus/prometheus.yml 
# global:
#   scrape_interval: 15s                                   # Bu yapilmali ama bir türlü yapamadim

# scrape_configs:
# - job_name: node
#   static_configs:
#   - targets: ['${local.second_ec2_ip}:9100']
# EOF

systemctl restart prometheus






