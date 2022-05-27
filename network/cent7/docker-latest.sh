#!/bin/bash
sudo yum upgrade -y
sudo systemctl stop firewalld &>/dev/null
sudo systemctl disable firewalld &>/dev/null
sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine
sudo yum install -y yum-utils
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
sudo systemctl start docker
sudo docker run hello-world
sudo yum install docker-compose-plugin -y
yum madison docker-compose-plugin
docker compose version
cat <<EOF>> ~/.bashrc
#My custom aliases
alias drun='sudo docker run -itd --privileged=true --restart=unless-stopped'
alias dbuild='sudo docker build -t'
alias docker='sudo docker'
alias dps='sudo docker ps'
alias dpsa='sudo docker ps -a'
alias dm='sudo docker images'
alias dstart='sudo docker start'
alias dstop='sudo docker stop'
EOF
source ~/.bashrc
