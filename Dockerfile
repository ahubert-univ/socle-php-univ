ARG PHP_VERSION=8.3
ARG COMPOSER_VERSION=2

FROM composer:${COMPOSER_VERSION} as composer
FROM mlocati/php-extension-installer:latest AS php_extension_installer

FROM php:${PHP_VERSION}-fpm-alpine AS app_php_prod

ENV PHP_VERSION $PHP_VERSION
ENV COMPOSER_VERSION $COMPOSER_VERSION
ENV DOCKER_ENV "prod"
ENV SYMFONY_LOCAL_SERVER false

WORKDIR /var/www/html

#Add user
RUN set -x ; \
  addgroup -g 1000 -S admin ; \
  adduser -u 1000 -D -S -G admin admin



## COMPOSER
ENV COMPOSER_HOME /composer
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV PATH /composer/vendor/bin:$PATH
COPY --from=composer /usr/bin/composer /usr/bin/composer
## END COMPOSER

## SYMFONY CLI
RUN apk add --no-cache bash
RUN curl -1sLf 'https://dl.cloudsmith.io/public/symfony/stable/setup.alpine.sh' | bash
RUN apk add symfony-cli
## END SYMFONY CLI

## PHP-FPM ##
COPY tools/php-fpm/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf
## END PHP-FPM ##

## PHP
RUN mkdir -p /var/run/php
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
## END PHP

EXPOSE 80

COPY tools/docker/entrypoint/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint

ENTRYPOINT ["docker-entrypoint"]

## ClEAN
RUN rm -rf /tmp/* /var/cache/apk/* /var/tmp/*
LABEL authors="niji-dsf"

FROM app_php_prod AS app_php_dev

ENV DOCKER_ENV "dev"
ENV SYMFONY_LOCAL_SERVER true
ENV XDEBUG_TRIGGER IDE_TRIGGER_VALUE
ENV XDEBUG_MODE off
ENV INSTALL_QUALITY_TOOLS true

# php extensions installer: https://github.com/mlocati/docker-php-extension-installer
COPY --from=php_extension_installer /usr/bin/install-php-extensions /usr/local/bin/

COPY tools/docker/scripts /opt/scripts
RUN chmod +x /opt/scripts/*.sh

RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

## XDEBUG
RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS
RUN apk add --update linux-headers
RUN install-php-extensions  xdebug
RUN apk del -f .build-deps
## END XDEBUG

## LABEL TRAEFIK ##
LABEL traefik.enable=true
LABEL traefik.http.services.php-niji.loadbalancer.server.port=80
LABEL traefik.http.routers.php-niji.tls=true
## END TRAEFIK ##