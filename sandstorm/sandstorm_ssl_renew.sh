#!/bin/bash
# @cron: Set to run on root crontab at 1300 everyday
# 00 13 * * * /home/simonxix/docker/sandstorm/sandstorm_ssl_renew.sh >> /var/log/cron.log 2>&1

#COMPOSE="/usr/local/bin/docker-compose --no-ansi"
DOCKER="/usr/bin/docker"

cd /home/simonxix/docker/
$DOCKER exec sandstorm /home/sandstorm/ssl/extract_certs.sh
$DOCKER exec sandstorm cp sandstorm.key /home/sandstorm/ssl/
$DOCKER exec sandstorm cp sandstorm.pem /home/sandstorm/ssl/
#$DOCKER compose kill -s SIGHUP webserver
#$DOCKER system prune -af
