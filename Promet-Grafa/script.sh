
#!/bin/bash
yum update -y
# yum install git -y
# yum install -y docker
# yum amazon-linux-extras install  -y
# systemctl start docker
# systemctl enable docker
# usermod -aG docker ec2-user
# docker pull prom/prometheus
# docker network create network
# docker volume create prometheus-data
# cat <<EOT > ./prometheus.yml
#     global:
#         scrape_interval: 15s
#     scrape_configs:
#         - job_name: prometheus
#         static_configs:
#         -targets: ["localhost:9090]
# EOT
# docker container run --name prometheus -v prometheus.yml -v prometheus-data:/prometheus -p 9090:9090 prom/prometheus

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

yum install grafana -y
#systemctl daemon-reload
systemctl start grafana-server
systemctl enable grafana-server