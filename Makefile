# Misc
.DEFAULT_GOAL = help
.PHONY        = help
IP_TEMP = IP_WSL_ETH=$$(dig +short $$(powershell.exe -noprofile -command '[Console]::Write($$env:COMPUTERNAME)')| head -n1)
CURRENT_USER = CURRENT_UID=$$(id -u):$$(id -g)
DOCKER_COMP = docker compose --project-name stack-php
DOCKER_EXEC = $(DOCKER_COMP) exec
DOCKER_COMP_IP = $(IP_TEMP) $(CURRENT_USER)  $(DOCKER_COMP)
phpversion :=8.3
enable_quality :=false
url_website :=php.docker.localhost
env :=dev
enable_local_webserser :=true
framework :=false
symfony_version :=7.1

-include my-project/$(project)/socle.env

## —— 🎵 🐳 Php stack Makefile 🐳 🎵 ——————————————————————————————————
start: down exist-image network check_parameter ## Start the stack-php make start project=<folder>
	@set -e; \
 	if [ ! -d "my-project/$(project)" ]; then \
		echo "Directory not exist please create project or add correct argument make start <project>"; \
	else \
		SYMFONY_VERSION=$(SYMFONY_VERSION) FRAMEWORK=$(FRAMEWORK) URL_LOCAL_WEBSITE=$(URL_LOCAL_WEBSITE) ENABLE_LOCAL_SERVER=$(ENABLE_LOCAL_SERVER) PROJECT=$(PROJECT) DOCKER_ENV=$(DOCKER_ENV) PHP_VERSION=$(PHP_VERSION) $(DOCKER_COMP_IP) -f "my-project/$(project)/docker-compose.yml" --profile runner up --detach; \
	fi

create_project: check_parameter install_folder_project build-image ## Create project make create_php_project project=<folder>

install_folder_project:
	@./bin/createProject.sh --symfony_version $(symfony_version) --framework $(framework) --url_website $(url_website) --project $(project) --phpversion $(phpversion) --env $(env) --enable_quality $(enable_quality)  --enable_local_server $(enable_local_webserser)

check_parameter:
	@[ "${project}" ] && echo "all good" || ( echo "project is not set"; exit 1 )

exist-image:
	@[ $(shell docker images -q socle-php-$(project)-$(phpversion)-$(env):1.0 2> /dev/null) ] && echo "all good" || ( echo "image not build please launch create_php project"; exit 1 )

build-image:
	@set -e; \
	ENABLE_LOCAL_SERVER=$(enable_local_webserser) DOCKER_ENV=$(env) URL_LOCAL_WEBSITE=$(url_website) INSTALL_QUALITY_TOOLS=$(enable_quality) PROJECT=$(project) PHP_VERSION=$(phpversion) $(DOCKER_COMP) -f docker-compose.admin.yml build build-php; \
	ENABLE_LOCAL_SERVER=$(enable_local_webserser) DOCKER_ENV=$(env) URL_LOCAL_WEBSITE=$(url_website) PROJECT=$(project) PHP_VERSION=$(phpversion) $(DOCKER_COMP) -f my-project/$(project)/docker-compose.yml build app_php

down: ## Stop the stack-php stack
	@$(DOCKER_COMP) down --remove-orphans

bash_php: ## bash php
	@XDEBUG_MODE=off $(DOCKER_EXEC) -e XDEBUG_MODE  app_php /bin/bash

network:
	docker network ls | grep public-univ-dev || docker network create public-univ-dev

help:
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'