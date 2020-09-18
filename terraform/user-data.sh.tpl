#!/bin/bash
yum install git -y
amazon-linux-extras install docker -y
systemctl enable docker
systemctl start docker
curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

echo "This is Github Token:" >> /tmp/datfile
echo ${github_token} >> /tmp/datfile
git clone  https://vkurguzov1pt:${github_token}@github.com/vkurguzov1pt/gh-actions-demo.git
cd /gh-actions-demo/docker
/usr/local/bin/docker-compose up -d
