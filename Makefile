include .env
$(shell touch .env.local)
include .env.local

export $(shell sed 's/=.*//' .env)
export $(shell sed 's/=.*//' .env.local)

DOCKER_COMPOSE?=docker compose

DOCKER_COMPOSE_CONFIG := -f docker-compose.$(APP_ENV).yml

stop: ## Остановить контейнеры
	$(DOCKER_COMPOSE) $(DOCKER_COMPOSE_CONFIG) stop

up: ## Поднять контейнеры
	$(DOCKER_COMPOSE) $(DOCKER_COMPOSE_CONFIG) up -d --remove-orphans

up+: ## Поднять контейнеры с консолью
	$(DOCKER_COMPOSE) $(DOCKER_COMPOSE_CONFIG) up --remove-orphans

armageddon: ## Удалит все неиспользованное
	docker system prune -a -f

clean: ## Удалить кэш
	docker builder prune -f

in-app: ## Войти в контейнер с приложением
	$(DOCKER_COMPOSE) $(DOCKER_COMPOSE_CONFIG) exec app bash

phpstan: ## Статический анализ кода - phpstan
	$(DOCKER_COMPOSE) $(DOCKER_COMPOSE_CONFIG) exec -T app composer phpstan

psalm: ## Статический анализ кода - psalm
	$(DOCKER_COMPOSE) $(DOCKER_COMPOSE_CONFIG) exec -T app composer psalm

phpcsfix: ## Внести автоматические правки по стилю кода
	$(DOCKER_COMPOSE) $(DOCKER_COMPOSE_CONFIG) exec -T app composer phpcsfix

check: ## Проверить коммит перед отправкой
	$(DOCKER_COMPOSE) $(DOCKER_COMPOSE_CONFIG) exec -T app composer check

help:
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n"} /^[$$()% a-zA-Z_-]+:.*?##/ { printf "  \033[32m%-30s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

#build: ## Собрать контейнеры
#  docker login --username oauth2 --password $(GITLAB_TOKEN) gitlab.hqsw.ru:5050
#  if ! [ -e phpunit.xml ]; then cp phpunit.xml.dist phpunit.xml; fi
#  $(DOCKER_COMPOSE) $(DOCKER_COMPOSE_CONFIG) build --force-rm
#  @if [ "$(APP_ENV)" = "prod" ]; then mkdir -p var && sudo chmod 777 var; fi
#
#
#
#sv-start: ## Запускает все процессы супервизора
#  $(DOCKER_COMPOSE) $(DOCKER_COMPOSE_CONFIG) exec -T app supervisorctl start all
#
#sv-stop: ## Останавливает все процессы супервизора
#  $(DOCKER_COMPOSE) $(DOCKER_COMPOSE_CONFIG) exec -T app supervisorctl stop all
#
#sv-refresh: ## Перезагружает все конфиги и перезапускает программы
#  $(DOCKER_COMPOSE) $(DOCKER_COMPOSE_CONFIG) exec -T app supervisorctl update all
#
#sv-status: ## Отображает статус по текущим процессам
#  $(DOCKER_COMPOSE) $(DOCKER_COMPOSE_CONFIG) exec -T app supervisorctl status
#
#help:
#  @awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n"} /^[$$()% a-zA-Z_-]+:.*?##/ { printf "  \033[32m%-30s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
#
#build: ## Собрать контейнеры
#  docker login --username oauth2 --password $(GITLAB_TOKEN) gitlab.hqsw.ru:5050
#  if ! [ -e phpunit.xml ]; then cp phpunit.xml.dist phpunit.xml; fi
#  $(DOCKER_COMPOSE) $(DOCKER_COMPOSE_CONFIG) build --force-rm
#  @if [ "$(APP_ENV)" = "prod" ]; then mkdir -p var && sudo chmod 777 var; fi
#
#pull: ## Обновить образа
#  $(DOCKER_COMPOSE) $(DOCKER_COMPOSE_CONFIG) pull
#
#up: ## Поднять контейнеры
#  $(DOCKER_COMPOSE) $(DOCKER_COMPOSE_CONFIG) up -d --remove-orphans
#
#stop: ## Остановить контейнеры
#  $(DOCKER_COMPOSE) $(DOCKER_COMPOSE_CONFIG) stop
#
#in-app: ## Войти в контейнер с приложением
#  $(DOCKER_COMPOSE) $(DOCKER_COMPOSE_CONFIG) exec app bash
#
#in-mysql: ## Войти в mysql контейнер
#  $(DOCKER_COMPOSE) $(DOCKER_COMPOSE_CONFIG) exec mysql bash
#
#phpunit: ## Прогнать тесты
#  $(DOCKER_COMPOSE) $(DOCKER_COMPOSE_CONFIG) exec -T app composer phpunit
#
#phpstan: ## Статический анализ кода - phpstan
#  $(DOCKER_COMPOSE) $(DOCKER_COMPOSE_CONFIG) exec -T app composer phpstan
#
#psalm: ## Статический анализ кода - psalm
#  $(DOCKER_COMPOSE) $(DOCKER_COMPOSE_CONFIG) exec -T app composer psalm
#
#phpcscheck: ## Проверка стиля кода
#  $(DOCKER_COMPOSE) $(DOCKER_COMPOSE_CONFIG) exec -T app composer phpcscheck
#
#check: ## Проверить коммит перед отправкой
#  $(DOCKER_COMPOSE) $(DOCKER_COMPOSE_CONFIG) exec -T app composer check
#
#phpcsfix: ## Внести автоматические правки по стилю кода
#  $(DOCKER_COMPOSE) $(DOCKER_COMPOSE_CONFIG) exec -T app composer phpcsfix
#
#lint: ## Запускает проверку контейнера
#  $(DOCKER_COMPOSE) $(DOCKER_COMPOSE_CONFIG) exec -T app composer lint
#
#doctrine: ## Запускает проверку Doctrine
#  $(DOCKER_COMPOSE) $(DOCKER_COMPOSE_CONFIG) exec -T app composer doctrine
#
#setup-local-host: ## Прокидывает домен ${PROJECT_SHORT_NAME}.local в hosts
#  if [[ "${PROJECT_SHORT_NAME}" && ! "$(shell grep "${PROJECT_SHORT_NAME}.local" /etc/hosts)" ]]; then \
#    sudo sh -c "echo '#DDH-${PROJECT_SHORT_NAME}-service\n127.0.0.1 ${PROJECT_SHORT_NAME}.local' >> /etc/hosts"; \
#  else \
#    echo 'Host ${PROJECT_SHORT_NAME}.local already installed'; \
#  fi;
