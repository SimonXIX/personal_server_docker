#!/bin/bash

COMPOSE="/usr/local/bin/docker-compose --no-ansi"
DOCKER="/usr/bin/docker"

cd /home/simonxix/docker/
$DOCKER exec sandstorm /home/sandstorm/bin/extract_certs.sh
$DOCKER exec sandstorm cp sandstorm.key /etc/nginx/ssl/
$DOCKER exec sandstorm cp sandstorm.pem /etc/nginx/ssl/
$COMPOSE kill -s SIGHUP webserver
$DOCKER system prune -af
