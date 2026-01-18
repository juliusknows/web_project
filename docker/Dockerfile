FROM php:8.4-fpm-alpine AS base

WORKDIR /var/www

COPY --from=juliusknows/web-project:1.0 /usr/local/bin/composer /usr/local/bin/composer

COPY composer.json composer.lock ./

RUN set -eux && \
    apk update && \
    apk add --no-cache \
        git && \
    /usr/local/bin/composer install --optimize-autoloader --no-interaction --no-scripts --prefer-dist && \
    apk del git && \
    rm  /usr/local/bin/composer && \
    rm -rf /var/cache/apk/* /var/lib/apt/lists/*

COPY bin/ config/ docker/ public/ src/ .env ./

RUN set -eux && \
    sed -i 's|^;?chdir.*|chdir = /var/www|' /usr/local/etc/php-fpm.d/www.conf && \
    chown -R www-data:www-data /var/www

RUN chown -R www-data:www-data /var/www


FROM base AS final


EXPOSE 9000
CMD ["php-fpm"]


