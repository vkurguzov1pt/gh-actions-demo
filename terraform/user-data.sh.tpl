#!/bin/bash
yum install git -y
echo "This is Github Token:" >> /tmp/datfile
echo ${github_token} >> /tmp/datfile
git clone  https://vkurguzov1pt:${github_token}@github.com/vkurguzov1pt/gh-actions-demo.git
