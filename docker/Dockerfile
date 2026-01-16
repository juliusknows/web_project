# Создаст образ из Docker Hub
FROM php:8.4-fpm-alpine AS builder

# Определяет рабочую директорию в контейнере
WORKDIR /var/app

# копирую настройки зависимостей
COPY composer.json composer.lock ./

# скачивает Composer, передает процесс php интерпретатору, устанавливает, задает имя composer, проверка установки
RUN set -eux && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    apk update && \
    apk add --no-cache git && \
    /usr/local/bin/composer install --optimize-autoloader --no-interaction --no-scripts --no-dev --prefer-dist && \
    apk del git && \
    rm  /usr/local/bin/composer && \
    rm -rf /var/cache/apk/* /var/lib/apt/lists/*

FROM php:8.4-fpm-alpine AS final

# Определяет рабочую директорию в контейнере
WORKDIR /var/app

# копируем из предыдущего образа нужные записимости
COPY --from=builder /var/app/vendor /var/app/vendor

# подменяем рабочий каталог в конфиге php fpm
RUN set -eux && \
    sed -i 's|^;?chdir.*|chdir = /var/app|' /usr/local/etc/php-fpm.d/www.conf && \
    chown -R www-data:www-data /var/app

# Открываем порт для Nginx
EXPOSE 9000

# копируем сам проект (настроив заранее .dockerignore)
COPY . .

# Запускаем PHP-FPM
CMD ["php-fpm"]


