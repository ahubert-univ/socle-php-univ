#!/bin/bash
set -e

reloadxdebug=false

if [ "$XDEBUG_MODE" = "debug" ]
then
  reloadxdebug=true
  export XDEBUG_MODE="off"
fi

if [ "$INSTALL_QUALITY_TOOLS" = true ]
then
  [[ -d "/var/www/html/$PROJECT/bin" ]] || mkdir "/var/www/html/$PROJECT/bin"
  [[ -f "/var/www/html/$PROJECT/bin/grumphp-command" ]] || cp /opt/tools/grumphp/grumphp-command "/var/www/html/$PROJECT/bin/grumphp-command"
  [[ -f "/var/www/html/$PROJECT/.editorconfig" ]] || cp /opt/tools/editorconfig/.editorconfig "/var/www/html/$PROJECT/.editorconfig"
  [[ -f "/var/www/html/$PROJECT/.php-cs-fixer.dist.php" ]] || cp /opt/tools/phpcsfixer/.php-cs-fixer.dist.php "/var/www/html/$PROJECT/.php-cs-fixer.dist.php"
  [[ -f "/var/www/html/$PROJECT/rector.php" ]] || cp /opt/tools/rector/rector.php "/var/www/html/$PROJECT/rector.php"
  [[ -f "/var/www/html/$PROJECT/phpstan.neon" ]] || cp /opt/tools/phpstan/phpstan.neon "/var/www/html/$PROJECT/phpstan.neon"

  /opt/scripts/installQualityScripts.sh "$PROJECT"
fi


dirname="/var/www/html/$PROJECT"
cd "$dirname"


# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- php "$@"
fi


if [[ "$DOCKER_ENV" = "dev" && "$INSTALL_QUALITY_TOOLS" = true ]]; then
  ./vendor/bin/grumphp git:init
fi;

if [ $reloadxdebug = true ]
then
  export XDEBUG_MODE="debug"
fi

if [[ "$SYMFONY_LOCAL_SERVER" = true && -d "$dirname" &&  "$DOCKER_ENV" = "dev" ]]; then
      symfony server:start --port=80 --no-tls
fi;


exec "$@"