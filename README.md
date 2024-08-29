# Docker Compose and Nginx configuration for simonxix.com

This repository is the Docker Compose and Nginx configuration for the SSD virtual server running https://simonxix.com and other *.simonxix.com websites. It's potentially useful for anyone looking to deploy WordPress, Sandstorm, GoAccess, Joplin Server, or PHP against Nginx in Docker Compose. 

## Technical details

IP address: 82.163.79.194

Operating system: Ubuntu 22.04.1 LTS

Processors: 4 cores

RAM: 1GB

Hard disk space: 50 GB

Bandwidth: 3TB

## Docker Compose

All running services on simonxix.com are running as Docker containers. These run from /home/simonxix/docker and currently includes MySQL, WordPress (PHP), Apache Solr, GoAccess, Nginx, and Sandstorm. 

`sudo docker-compose down`

`sudo docker-compose up -d --build`

## SSL

The Sandstorm server is SSL secured. This was done by setting up a wildcard certificate for the simonxix.com domain name (https://medium.com/@utkarsh_verma/how-to-obtain-a-wildcard-ssl-certificate-from-lets-encrypt-and-setup-nginx-to-use-wildcard-cfb050c8b33f) and then setting up Sandstorm with Nginx for reverse proxy (https://docs.sandstorm.io/en/latest/administering/reverse-proxy/).

### Lego

As of 2024-08-29, all SSL certificates are managed using [Lego](https://go-acme.github.io/lego/). This runs Let's Encrypt requests and automates the process of adding DNS records for domain challenges.

This runs using: 

`docker compose -f /home/simonxix/docker/lego/docker-compose.yml up lego-renew`

It's set up on the root crontab to run every day at 1200 and to renew the SSL certificates if there is fewer than 60 days to renewal.

All SSL certificates are now kept in the directory /etc/letsencrypt/lego_cert_store which is mirrored as a volume in the Nginx webserver Docker container.

### deprecated SSL process

Run this command to get an SSL certificate from Let's Encrypt:

`sudo certbot -d *.simonxix.com,simonxix.com --manual --preferred-challenges dns certonly`

As of 2021-09-22, Sandstorm runs behind a reverse proxy to preserve the old rlc.sandcats.io domain name following instructions at https://juanjoalvarez.net/posts/2017/how-set-sandstorm-behind-reverse-proxy-keeping-you/. This uses Sandcats' own SSL certificates which might be a problem when they expire. I'll deal with that when it comes to it.

2021-09-23: I dealt with it. Certbot now runs in Docker to renew the simonxix.com domain (cron-ed for once a day) while Sandstorm renews its own certificates and a script (extract_certs.sh) runs in the Sandstorm container to copy those certificates to Nginx SSL folder. In turn, another script (sandstorm_ssl_renew.sh) runs the extract_certs.sh script once a day. 

The wildcard certificates are still useful for any other subdomain I want to set up such testing.simonxix.com. 

