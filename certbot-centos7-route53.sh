#!/bin/bash

# setup for aws iam user and role: https://certbot-dns-route53.readthedocs.io/en/latest/
# initial setting
wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm -ivh epel-release-latest-7.noarch.rpm
yum install -y certbot python-pip awscli

pip install --upgrade pip awscli
pip install boto3 certbot-dns-route53

# aws configure
mkdir /root/.aws
/bin/cat <<EOM >/root/.aws/config
[default]
region = YOUR-REGION
EOM

/bin/cat <<EOM >/root/.aws/credentials
[default]
aws_access_key_id = AWS-ACCESS-KEY
aws_secret_access_key = AWS-ACCESS-SECRET-KEY
EOM

certbot certonly -n --agree-tos --email YOUR@EMAIL.ADDR --dns-route53 -d YOUR.DOMAIN -d "*.YOUR.DOMAIN" --server https://acme-v02.api.letsencrypt.org/directory
# certbot certonly --expand -n --agree-tos --email YOUR@EMAIL.ADDR --dns-route53 -d YOUR.DOMAIN -d "*.YOUR.DOMAIN" --server https://acme-v02.api.letsencrypt.org/directory

# copy certificate file to destination
# cp -r /etc/letsencrypt/live/YOUR.DOMAIN/ DESTINATION
# scp -r /etc/letsencrypt/live/YOUR.DOMAIN/ DESTINATION

# auto-renewal configure
sed -i -e '15a\\0 0,12 * * * python -c "import random; import time; time.sleep(random.random() * 3600)" && certbot renew' /etc/crontab
