FROM php:8.4-fpm-alpine AS base

WORKDIR /var/www

# php расширения
RUN apk add --no-cache \
    php-mbstring \
    php-xml \
    php-curl \
    php-zip \
    php-opcache \
    php-json

# Базы данных
RUN docker-php-ext-install -j$(nproc) \
    pdo \
    pdo_mysql

# Composer и завистмости
COPY --from=juliusknows/web-project:1.0 /usr/local/bin/composer /usr/local/bin/composer

COPY composer.json composer.lock ./

RUN /usr/local/bin/composer install --optimize-autoloader --no-interaction --no-scripts --prefer-dist

# Копирование кода проекта
COPY bin/ bin/
COPY config/ config/
COPY docker/ docker/
COPY public/ public/
COPY src/ src/
COPY .env .env

# Последние настрокий и очистка
RUN mkdir -p /var/www/var && \
    mkdir -p /var/www/var/cache /var/www/var/log && \
    chown -R www-data:www-data /var/www && \
    find /var/www -type d -exec chmod 755 {} \; && \
    find /var/www -type f -exec chmod 644 {} \; && \
    apk cache clean && \
    rm -rf \
        /usr/local/bin/composer \
        /var/cache/apk/* \
        /root/.composer/cache/* \
        /var/www/composer

USER www-data

FROM base AS dev

USER www-data

# Инструменты для разработки
RUN apk add --no-cache \
    php-xdebug \
    git \
    bash

# Конфиг Xdebug
RUN docker-php-ext-enable xdebug \
    && echo 'xdebug.mode=develop,debug' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo 'xdebug.client_host=host.docker.internal' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Оставить composer для локальных изменений
COPY --from=juliusknows/web-project:1.0 /usr/local/bin/composer /usr/local/bin/composer
RUN rm -rf /root/.composer/cache/*

# Права для горячей перезагрузки
RUN chmod -R 777 /var/www/var/cache /var/www/var/log

EXPOSE 9000
CMD ["php-fpm", "--nodaemonize", "--fpm-config", "/usr/local/etc/php-fpm.conf"]

FROM base AS test

USER www-data

# Тестовые зависимости
RUN /usr/local/bin/composer install --dev --optimize-autoloader --no-interaction

# Копирование тестовых данных
COPY tests/ tests/
COPY phpunit.xml.dist ./

# Убрать лишние файлы
RUN rm -rf /var/www/docker /var/www/bin

# Запуск тестов при старте (опционально)
CMD ["sh", "-c", "vendor/bin/phpunit || exit 1"]


FROM base AS prod

USER www-data

# Удалить Composer и кэш
RUN rm -rf /usr/local/bin/composer /var/www/composer.json /var/www/composer.lock

# Отключить интерактивные компоненты
RUN docker-php-ext-disable opcache \
    && echo 'opcache.enable=1' >> /usr/local/etc/php/conf.d/opcache-prod.ini \
    && echo 'opcache.memory_consumption=128' >> /usr/local/etc/php/conf.d/opcache-prod.ini

# Строгие права
RUN chown -R www-data:www-data /var/www \
    && find /var/www -type d -exec chmod 750 {} \; \
    && find /var/www -type f -exec chmod 640 {} \;

# Только необходимые директории
RUN rm -rf /var/www/tests /var/www/docker

EXPOSE 9000
CMD ["php-fpm"]


