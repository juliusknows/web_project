docker build -t <project-name> -f ./docker/Dockerfile . (сборка)

docker run --rm <project-name> ls -a /var/app (проверить корневую директорию)



docker images (показать образы)

docker-compose up (поднять контейнер)

docker ps (показать запущенные контейнеры)

docker-compose up (поднять контейнеры / добавить -d для фонового режима

docker image prune -a (удаление неиспользованных образов)

docker builder prune -f (очистка всего кэша сборки + промежуточные слои)

docker system prune -a -f (удаляет все неиспользованные данные более агрессивно)
