#!/bin/bash
sudo yum update -y && \
sudo yum install git -y && \
git clone https://github.com/frnitzsche/docker-compose-confluence.git && \
cd docker-compose-confluence && \
chmod a+x customization-script.sh && \
/bin/bash customization-script.sh > /var/log/custamization-script.log 2>&1
