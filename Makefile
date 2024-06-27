# Misc
DOCKER_COMP = docker compose
.DEFAULT_GOAL = help
.PHONY        = help

## —— 🎵 🐳 The Traefik portainer Makefile 🐳 🎵 ——————————————————————————————————

##
## Commands
## ---------
network:
	docker network ls | grep public-univ-dev || docker network create public-univ-dev

start: network ## Start the socle-php-univ stack
	@$(DOCKER_COMP) --profile common --project-name socle-php-univ up --detach

test: network ## Start the socle-php-univ "hello-world" container
	@$(DOCKER_COMP) --profile common --project-name socle-php-univ --profile test up --detach

down: ## Stop the socle-php-univ stack
	@$(DOCKER_COMP) --profile common --project-name socle-php-univ --profile deprecated --profile test down --remove-orphans

bash_php: ## bash php
	@$(DOCKER_COMP) --project-name socle-php-univ exec php-univ /bin/bash

build_php:
	@$(DOCKER_COMP) --project-name socle-php-univ build php-univ

help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'