#!/bin/sh
set -e

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- php "$@"
fi

if [ "$FOLDER" != "" ]; then
  cd /var/www/html/"$FOLDER"
  symfony server:start --port=80 --no-tls
fi

exec "$@"