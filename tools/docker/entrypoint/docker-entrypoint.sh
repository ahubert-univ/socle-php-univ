#!/bin/bash
set -e

reloadXdebug=false

if [ "$XDEBUG_MODE" = "debug" ]
then
  reloadXdebug=true
  export XDEBUG_MODE="off"
fi

dirname="/var/www/html/$PROJECT/application"
cd "$dirname"
firstLaunch=false

if [[ "$FRAMEWORK" == "symfony" && ! -f symfony.lock ]]
then
   firstLaunch=true
   composer create-project symfony/skeleton:"$SYMFONY_VERSION.*" .
   composer require webapp
elif [[ "$FRAMEWORK" == "laravel" && ! -f composer.json ]]
then
    firstLaunch=true
    composer create-project laravel/laravel .
elif [ -f composer.json ]
then
      composer install --prefer-dist --no-progress --no-interaction --no-scripts
fi

if [[ "$FRAMEWORK" == false && ! -f index.php ]]
then
  firstLaunch=true
  echo "<?php phpinfo();" > "/var/www/html/$PROJECT/application/index.php"
fi

if [[ "$INSTALL_QUALITY_TOOLS" == true && $firstLaunch == true ]]
then

  echo "install Quality tools"

  [[ -d "/var/www/html/$PROJECT/application/bin" ]] || mkdir "/var/www/html/$PROJECT/application/bin"
  [[ -f "/var/www/html/$PROJECT/application/bin/grumphp-command" ]] || cp /opt/tools/grumphp/grumphp-command "/var/www/html/$PROJECT/application/bin/grumphp-command"
  [[ -f "/var/www/html/$PROJECT/application/.editorconfig" ]] || cp /opt/tools/editorconfig/.editorconfig "/var/www/html/$PROJECT/application/.editorconfig"
  [[ -f "/var/www/html/$PROJECT/application/.php-cs-fixer.dist.php" ]] || cp /opt/tools/phpcsfixer/.php-cs-fixer.dist.php "/var/www/html/$PROJECT/application/.php-cs-fixer.dist.php"
  [[ -f "/var/www/html/$PROJECT/application/rector.php" ]] || cp /opt/tools/rector/rector.php "/var/www/html/$PROJECT/application/rector.php"
  [[ -f "/var/www/html/$PROJECT/application/phpstan.neon" ]] || cp /opt/tools/phpstan/phpstan.neon "/var/www/html/$PROJECT/application/phpstan.neon"

  /opt/scripts/installQualityScripts.sh "$PROJECT"
fi

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- php "$@"
fi


if [[ "$DOCKER_ENV" == "dev" && "$INSTALL_QUALITY_TOOLS" == true ]]; then
  /var/www/html/"$PROJECT"/application/vendor/bin/grumphp git:init
fi;

if [ $reloadXdebug == true ]
then
  export XDEBUG_MODE="debug"
fi

if [[ "$SYMFONY_LOCAL_SERVER" == true && -d "$dirname" &&  "$DOCKER_ENV" == "dev" ]]; then
      symfony server:start --port=80 --no-tls
fi;


exec "$@"