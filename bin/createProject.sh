#!/bin/bash

################################# Add Quality tools
function addQualityTools {

  while [ $# -gt 0 ]; do
      if [[ $1 == "--"* ]]; then
          v="${1/--/}"
          declare "$v"="$2"
          shift
      fi
      shift
  done

  if [ "$enable_quality" == "true" ] && [ "$env" == "dev" ]
  then
    [[ -d "my-project/$project/application/bin" ]] || mkdir "my-project/$project/application/bin"
    [[ -f "my-project/$project/application/bin/grumphp-command" ]] || cp tools/grumphp/grumphp-command "my-project/$project/application/bin/grumphp-command"
    [[ -f "my-project/$project/application/.editorconfig" ]] || cp tools/editorconfig/.editorconfig "my-project/$project/application/.editorconfig"
    [[ -f "my-project/$project/application/.php-cs-fixer.dist.php" ]] || cp tools/phpcsfixer/.php-cs-fixer.dist.php "my-project/$project/application/.php-cs-fixer.dist.php"
    [[ -f "my-project/$project/application/rector.php" ]] || cp tools/rector/rector.php "my-project/$project/application/rector.php"
    [[ -f "my-project/$project/application/phpstan.neon" ]] || cp tools/phpstan/phpstan.neon "my-project/$project/application/phpstan.neon"
  fi

}


################################# Write Dockerfile
function writeDockerfile {

  while [ $# -gt 0 ]; do
      if [[ $1 == "--"* ]]; then
          v="${1/--/}"
          declare "$v"="$2"
          shift
      fi
      shift
  done

  ### WRITE LOCAL DOKERFILE
  echo -e "FROM socle-php-$project-$phpversion-$env:1.0 AS my_socle_$project_$env
# installing required extensions
RUN apk update
RUN apk add php${phpversion//.}-opcache php${phpversion//.}-pdo_mysql
RUN docker-php-ext-install pdo pdo_mysql opcache
" > "my-project/$project/Dockerfile"

}

################################# Socle.env
function writeSocleEnvVar {

    while [ $# -gt 0 ]; do
        if [[ $1 == "--"* ]]; then
            v="${1/--/}"
            declare "$v"="$2"
            shift
        fi
        shift
    done

    rm -rf my-project/$project/socle.env
    echo "INSTALL_QUALITY_TOOLS=$enable_quality" >> "my-project/$project/socle.env"
    echo "URL_LOCAL_WEBSITE=$url_website" >> "my-project/$project/socle.env"
    echo "PROJECT=$project" >> "my-project/$project/socle.env"
    echo "DOCKER_ENV=$env" >> "my-project/$project/socle.env"
    echo "PHP_VERSION=$phpversion" >> "my-project/$project/socle.env"
    echo "SYMFONY_LOCAL_SERVER=$enable_local_server" >> "my-project/$project/socle.env"
    echo "FRAMEWORK=$framework" >> "my-project/$project/socle.env"
    echo "SYMFONY_VERSION=$symfony_version" >> "my-project/$project/socle.env"

}

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

if [ -z $symfony_version ]
then
    echo "You must launch with symfony_version argument"
    exit 1
fi



if [ -z $framework ]
then
    echo "You must launch with framework argument"
    exit 1
fi

framework_supported=(false "symfony")


if printf '%s\0' "${framework_supported[@]}" | grep -qwz $framework
then
  echo "$framework is supported framework"
else
  echo "Framework not supported"
  exit 1
fi

function exit_script(){
  echo "Caught SIGTERM"
  exit 0
}

if [ "$project" != null ]
then


  mkdir -p "my-project/$project/application"

  ## Docker local file
  [[ -f "my-project/$project/docker-compose.yml" ]] || cp tools/docker-compose/docker-compose.yml "my-project/$project/docker-compose.yml"

  ## socle.env
  writeSocleEnvVar --symfony_version $symfony_version --project $project --enable_quality $enable_quality --url_website $url_website --env $env --phpversion $phpversion --enable_local_server $enable_local_server --framework $framework

  ## Dockerfile
  writeDockerfile --project $project --phpversion $phpversion --env $env

  echo "my-project/$project is created"
else
  echo "project argument is null please launch make create_php_project project=<project name> , project can not be created"
fi

