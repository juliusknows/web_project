# Создаст образ из Docker Hub
FROM php:8.4-fpm-alpine AS builder

# Определяет рабочую директорию в контейнере
WORKDIR /var/app

# копирую настройки зависимостей
COPY composer.json composer.lock ./

# скачивает Composer, передает процесс php интерпретатору, устанавливает, задает имя composer, проверка установки
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    composer --version

# обновить список, установить, собрать, очистить кэш, удалить файлы метаданных, установить композер
RUN set -eux && \
    apk update && \
    apk add --no-cache git && \
    composer install --optimize-autoloader --no-interaction --no-scripts



FROM php:8.4-fpm-alpine AS final

# Определяет рабочую директорию в контейнере
WORKDIR /var/app

# копируем из предыдущего образа нужные записимости
COPY --from=builder /var/app /var/app

# копируем сам проект (настроив заранее .dockerignore)
COPY . .

# подменяем рабочий каталог в конфиге php fpm
RUN set -eux && \
    sed -i 's|^;?chdir.*|chdir = /var/app|' /usr/local/etc/php-fpm.d/www.conf && \
    chown -R www-data:www-data /var/app

# Открываем порт для Nginx
EXPOSE 9000

# Запускаем PHP-FPM
CMD ["php-fpm"]


