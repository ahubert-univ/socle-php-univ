# Misc
DOCKER_COMP = docker compose
.DEFAULT_GOAL = help
.PHONY        = help

## —— 🎵 🐳 The Symfony-docker Makefile 🐳 🎵 ——————————————————————————————————
help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'



generate-mkcert:  ## Generate certificate
	./self-signed-ssl --no-interaction -c 'FR' -s 'Britany' -l 'Rennes' -o 'Niji' -u 'DSF' -n '*.docker.localhost' -a '*.docker.localhost'
