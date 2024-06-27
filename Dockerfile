ARG PHP_VERSION=8
ARG COMPOSER_VERSION=2

FROM composer:${COMPOSER_VERSION} as composer

FROM php:${PHP_VERSION}-alpine AS app_php_dev

ENV PHP_VERSION $PHP_VERSION
ENV COMPOSER_VERSION $COMPOSER_VERSION


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

RUN mkdir -p /var/run/php
WORKDIR /var/www/html

EXPOSE 80

COPY docker/php/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint

ENTRYPOINT ["docker-entrypoint"]

## ClEAN
RUN rm -rf /tmp/* /var/cache/apk/* /var/tmp/*
LABEL authors="ahubert"