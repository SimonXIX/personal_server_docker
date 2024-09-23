# Docker Compose configurations for simonxix.com

This repository is the directory of Docker Compose stack configurations for the Virtual Private Server running https://simonxix.com and other *.simonxix.com websites and services. It's potentially useful for anyone looking to deploy Docker Compose with a variety of services including Flask, Ghost, GoAccess, Joplin Server, Podfetch, Sandstorm, and WordPress all running through a Nginx reverse proxy.

## technical details

IPv4 address: 193.108.55.54

IPv6 address: 2001:1600:13:101::1120

Operating system: Ubuntu 24.04.1 LTS

Processors: 4 CPU

RAM: 4 GB

Hard disk space: 80 GB

Bandwidth: 500 Mb/s

Location: Satigny, Switzerland

## structure

All running services on simonxix.com are running as Docker containers. These run from separate directories with each containing a separate Docker Compose configuration to keep deployments containerised. 

Each stack can be brought up or down by going to their respective subdirectory and running: 

`docker-compose down`

`docker-compose up -d --build`

### subdirectories

./flask runs Flask (https://flask.palletsprojects.com/) applications bundled together in the same Docker Compose stack. These applications are initialised in this directory as submodules from their respective Git repositories. 

./ghost runs Ghost (https://ghost.org/), the newsletter publishing platform. The stack includes the Ghost application and a MySQL database for Ghost's data.

./goaccess runs GoAccess (https://goaccess.io/) real-time visual web log analyser pointed at the Nginx access log. This configuration is based on icamys' configuration for GoAccess in Docker and Nginx at https://github.com/icamys/docker-goaccess-nginx. 

./joplin runs Joplin Server (https://joplinapp.org/) for storing notes. This stack includes the Joplin Server application and a PostgreSQL database with encrypted notes data kept in ./joplin/joplin-data.

./lego runs Lego (https://go-acme.github.io/lego/), a Let's Encrypt client and ACME library for retrieving and renewing SSL certificates. This handles the renewal of the server's SSL certificate for its main domain and wildcard for subdomains. See below for further details. 

./nginx runs Nginx (https://nginx.org/) webserver and reverse proxy. It handles all requests on the server and is configured to point to the relevant services and Docker containers.

./php runs a simple Docker Compose file for PHP8-FPM for some old PHP websites. 

./podfetch runs Podfetch (https://github.com/SamTV12345/PodFetch), a podcast listening platform that runs in the browser. This stack includes Podfetch itself and a PostgreSQL database for Podfetch. 

./sandstorm runs Sandstorm (https://sandstorm.org/) inside a buildpack-deps container. This runs Sandstorm from /opt/sandstorm on the host server. There are also scripts in here to handle renewing the SSL certificates for the *.sandcats.io domain and extracting the certificates to be picked up by Nginx. This largely follows Juanjo Alvarez's instructions for this here: https://juanjoalvarez.net/posts/2017/how-set-sandstorm-behind-reverse-proxy-keeping-you/. Note also this extremely annoying and non-obvious requirement for running in Ubuntu 24.04: https://groups.google.com/g/sandstorm-dev/c/4JFhr7B7QZU

./tor runs an onionizing application and a separate version of Nginx for the onion service version of the main site. This is based on the Onionize process outlined here: https://github.com/torservers/onionize-docker

./wordpress runs a WordPress (https://wordpress.org/) site. This stack contains the WordPress application (PHP8-FPM) and a MariaDB database. 

## Docker management

Managing the various Docker Compose stacks in bulk is done using docker_management.sh, a simple Bash script for bringing stacks up and down. The various stacks are specified in the DOCKER_CONTAINERS array and the script loops through them to turn them on or off based on the flag sent to the script. 

> Syntax: docker_management.sh [-l|h|s|t|r]
> 
> options:
>
> l     Print the MIT License notification.
>
> h     Print this Help.
>
> s     Stop all Docker Compose stacks.
>
> t     Start all Docker Compose stacks.
>
> r     Restart all Docker Compose stacks.

This could and should probably be done with something like Portainer (https://www.portainer.io/) but that's for another day.

## Nginx

Every service and website on the server runs through the Dockerised Nginx webserver and reverse proxy. The configurations for these services and websites are kept in ./nginx/nginx-conf which is served as /etc/nginx/conf.d in the container. Sandstorm has a separate domain name but is also reverse proxied following instructions at https://docs.sandstorm.io/en/latest/administering/reverse-proxy

### SSL

The server has one SSL certificate for the main domain with a wildcard for subdomains. As of 2024-08-29, all SSL certificates are managed using [Lego](https://go-acme.github.io/lego/). This runs Let's Encrypt requests and automates the process of adding DNS records for domain challenges.

This runs using: 

`docker compose -f /home/simonxix/docker/lego/docker-compose.yml up lego-renew`

It's set up on the crontab to run every day at 1200 and to renew the SSL certificates if there is fewer than 60 days to renewal.

All SSL certificates are now kept in the directory /etc/letsencrypt/lego_cert_store which is mirrored as a volume in the Nginx Docker container.

The Sandstorm server is also SSL secured for its *.sandcats.io domain name. Sandstorm renews its own certificates and a script (extract_certs.sh) runs in the Sandstorm container to copy those certificates to Nginx SSL folder. In turn, another script (sandstorm_ssl_renew.sh) runs the extract_certs.sh script once a day. 

#### deprecated SSL process

Run this command to get an SSL certificate from Let's Encrypt:

`sudo certbot -d *.simonxix.com,simonxix.com --manual --preferred-challenges dns certonly`

As of 2021-09-22, Sandstorm runs behind a reverse proxy to preserve the old rlc.sandcats.io domain name following instructions at https://juanjoalvarez.net/posts/2017/how-set-sandstorm-behind-reverse-proxy-keeping-you/. This uses Sandcats' own SSL certificates which might be a problem when they expire. I'll deal with that when it comes to it.

2021-09-23: I dealt with it. Certbot now runs in Docker to renew the simonxix.com domain (cron-ed for once a day) while Sandstorm renews its own certificates and a script (extract_certs.sh) runs in the Sandstorm container to copy those certificates to Nginx SSL folder. In turn, another script (sandstorm_ssl_renew.sh) runs the extract_certs.sh script once a day. 

The wildcard certificates are still useful for any other subdomain I want to set up such testing.simonxix.com. 
