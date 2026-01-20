FROM php:8.4-fpm-alpine AS base

WORKDIR /var/www

RUN apk add --no-cache \
    php-mbstring \
    php-xml \
    php-curl \
    php-zip \
    php-opcache \
    php-json

RUN docker-php-ext-install -j$(nproc) \
    pdo \
    pdo_mysql

RUN mkdir -p /var/www/var/cache /var/www/var/log && \
    chown -R www-data:www-data /var/www/var && \
    chmod -R 775 /var/www/var

COPY --from=juliusknows/web-project:1.0 /usr/local/bin/composer /usr/local/bin/composer
COPY composer.json composer.lock ./

RUN /usr/local/bin/composer install --optimize-autoloader --no-interaction --no-scripts --prefer-dist

COPY bin/ bin/
COPY config/ config/
COPY docker/ docker/
COPY public/ public/
COPY src/ src/
COPY .env .env

RUN apk cache clean && \
    rm -rf \
        /var/lib/apk/cache/* \
        /var/cache/apk/* \
        /root/.composer/cache/* \
        /tmp/pear/ /tmp/pecl/ /var/tmp/pecl-build/

RUN chown -R www-data:www-data /var/www

FROM base AS dev

WORKDIR /var/www

# Инструменты для разработки
RUN apk add --no-cache \
    git \
    bash


ARG MODE=dev

ENV STAND=$MODE

#EXPOSE 9003
EXPOSE 9000
USER www-data
CMD ["php-fpm"]


FROM base AS prod

WORKDIR /var/www

# Удаление composer и тестовых файлов
RUN rm -rf \
    /usr/local/bin/composer \
    /var/www/composer.json \
    /var/www/composer.lock \
    /var/www/tests \
    /var/www/docker

# Строгие права
RUN chown -R www-data:www-data /var/www \
    && find /var/www -type d -exec chmod 750 {} \; \
    && find /var/www -type f -exec chmod 640 {} \;

USER www-data
EXPOSE 9000
CMD ["php-fpm"]



