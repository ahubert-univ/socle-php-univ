#!/bin/sh
set -e

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- php "$@"
fi

dirname="/var/www/html/$FOLDER"

if [ -d "$dirname" ]; then
    cd "$dirname"
    symfony server:start --port=80 --no-tls
else
    echo "$dirname does not exist, or is not a directory. Server Web Not start"
fi

exec "$@"