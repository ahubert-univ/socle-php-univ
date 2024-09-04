#!/bin/bash
set -e

while [ $# -gt 0 ]; do
    if [[ $1 == "--"* ]]; then
        v="${1/--/}"
        declare "$v"="$2"
        shift
    fi
    shift
done

if [ -z $url_website ]
then
    echo "You must launch with url_website argument"
    exit 1
fi

if [ -z $project ]
then
    echo "You must launch with project argument"
    exit 1
fi

if [ -z $phpversion ]
then
    echo "You must launch with phpversion argument"
    exit 1
fi

if [ -z $enable_quality ]
then
    echo "You must launch with enable_quality argument"
    exit 1
fi

if [ -z $env ]
then
    echo "You must launch with env argument"
    exit 1
fi

if [ -z $enable_local_server ]
then
    echo "You must launch with enable_local_server argument"
    exit 1
fi


function exit_script(){
  echo "Caught SIGTERM"
  exit 0
}

if [ "$project" != null ]
then


  mkdir -p "my-project/$project"

  if [ "$enable_quality" == "true" ] && [ "$env" == "dev" ]
  then
    [[ -d "my-project/$project/bin" ]] || mkdir "my-project/$project/bin"
    [[ -f "my-project/$project/bin/grumphp-command" ]] || cp tools/grumphp/grumphp-command "my-project/$project/bin/grumphp-command"
    [[ -f "my-project/$project/.editorconfig" ]] || cp tools/editorconfig/.editorconfig "my-project/$project/.editorconfig"
    [[ -f "my-project/$project/.php-cs-fixer.dist.php" ]] || cp tools/phpcsfixer/.php-cs-fixer.dist.php "my-project/$project/.php-cs-fixer.dist.php"
    [[ -f "my-project/$project/rector.php" ]] || cp tools/rector/rector.php "my-project/$project/rector.php"
    [[ -f "my-project/$project/phpstan.neon" ]] || cp tools/phpstan/phpstan.neon "my-project/$project/phpstan.neon"
  fi

  [[ -f "my-project/$project/docker-compose.yml" ]] || cp tools/docker-compose/docker-compose.yml "my-project/$project/docker-compose.yml"


  echo "<?php phpinfo();" > "my-project/$project/index.php"
  echo "FROM socle-php-$project-$phpversion-$env:1.0 as my_socle_$project_$env" > "my-project/$project/Dockerfile"
  rm -rf my-project/$project/socle.env
  echo "INSTALL_QUALITY_TOOLS=$enable_quality" >> "my-project/$project/socle.env"
  echo "URL_LOCAL_WEBSITE=$url_website" >> "my-project/$project/socle.env"
  echo "PROJECT=$project" >> "my-project/$project/socle.env"
  echo "DOCKER_ENV=$env" >> "my-project/$project/socle.env"
  echo "PHP_VERSION=$phpversion" >> "my-project/$project/socle.env"
  echo "SYMFONY_LOCAL_SERVER=$enable_local_server" >> "my-project/$project/socle.env"


  echo "my-project/$project is created"
else
  echo "project argument is null please launch make create_php_project project=<project name> , project can not be created"
fi

