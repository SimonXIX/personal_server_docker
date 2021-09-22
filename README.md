# Docker Compose and Nginx configuration for simonxix.com

This repository is the private Docker Compose and Nginx configuration for the SSD VPS virtual server ssdvps-18212.vps.net running https://simonxix.com and https://rlc.sandcats.io.

## Technical details

Hostname: ssdvps-18212.vps.net
IP address: 82.163.79.194
Physical location: London
Operating system: Ubuntu 20.04.3 LTS
Processors: 4 cores
RAM: 1GB
Hard disk space: 26 GB
Bandwidth: 3TB

## Docker Compose

All running services on simonxix.com are running as Docker containers rather than services per se. These run from /home/simonxix/docker and currently includes MySQL, WordPress (PHP), Nginx, and Sandstorm. 

`sudo docker-compose down`
`sudo docker-compose up -d --build`

## Nginx

The Sandstorm server is SSL secured. This was done by setting up a wildcard certificate for the simonxix.com domain name (https://medium.com/@utkarsh_verma/how-to-obtain-a-wildcard-ssl-certificate-from-lets-encrypt-and-setup-nginx-to-use-wildcard-cfb050c8b33f) and then setting up Sandstorm with Nginx for reverse proxy (https://docs.sandstorm.io/en/latest/administering/reverse-proxy/).

As of 2021-09-22, Sandstorm runs behind a reverse proxy to preserve the old rlc.sandcats.io domain name following instructions at https://juanjoalvarez.net/posts/2017/how-set-sandstorm-behind-reverse-proxy-keeping-you/. This uses Sandcats' own SSL certificates which might be a problem when they expire. I'll deal with that when it comes to it.  
