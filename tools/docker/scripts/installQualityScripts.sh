#!/bin/bash
set -e

cd "/var/www/html/$1/application"

execute_composer=false


if [ ! -f composer.json ]
then
 echo "create composer.json"
 composer init --name "socleniji/php" --version "1.0" --description "socle php niji"
fi

package_exist_grumphp() {
    composer show --no-scripts | grep phpro/grumphp >/dev/null
}

package_exist_phpstan() {
    composer show --no-scripts | grep phpstan/phpstan >/dev/null
}

package_exist_rector() {
    composer show --no-scripts | grep rector/rector >/dev/null
}

package_exist_phpcsfixer() {
    composer show --no-scripts | grep friendsofphp/php-cs-fixer >/dev/null
}

if ! package_exist_phpstan; then
  execute_composer=true
  composer require --dev --no-update phpstan/phpstan
fi

if ! package_exist_rector; then
  execute_composer=true
  composer require --dev --no-update rector/rector
fi

if ! package_exist_phpcsfixer; then
  execute_composer=true
  composer require --dev --no-update friendsofphp/php-cs-fixer
fi

if ! package_exist_grumphp; then
  execute_composer=true
  composer config --no-plugins allow-plugins.phpro/grumphp true
  composer require --dev --no-update phpro/grumphp --no-progress --no-interaction --no-scripts
fi

if $execute_composer; then
    if [[ ! -f composer.lock ]]
    then
      composer install
    else
      composer update
    fi
fi