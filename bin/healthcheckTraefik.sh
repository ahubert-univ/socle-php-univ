#!/usr/bin/env bash
IS_RUNNING=$(docker compose --project-name docker-traefik-portainer ps -q --status=running traefik2)
if [[ "$IS_RUNNING" != "" ]]; then
    echo "The service is running!!!"
else
   echo "Traefik not launch please start it!"
   exit 1;
fi
