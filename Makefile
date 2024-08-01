PROJECT_NAME := SSR_Restaurant
PROJECT_NETWORK := SSR_Restaurant_Network
VOLUME_NAME := mysql_data
PROJECT_VOLUME_APP := app

# DB Environment
MYSQL_ROOT_USER := root
MYSQL_ROOT_PASSWORD := 123456

MYSQL_USER := player
MYSQL_PASSWORD := 123456
MYSQL_DATABASE := SSR_Restaurant
MYSQL_PORT := 3306

.PHONY: create_network create_volume run_mysql_init run_laravel

create_network:
	docker network create $(PROJECT_NETWORK) 

create_volume:
	docker volume create --name $(VOLUME_NAME)
	
create_volume_app:
	docker volume create --name $(PROJECT_VOLUME_APP)

run_mysql_init:
	docker run -d --name $(PROJECT_NAME)_mysql \
--env MYSQL_ALLOW_EMPTY_PASSWORD=yes \
		--env MYSQL_USER=$(MYSQL_USER) \
		--env MYSQL_PASSWORD=$(MYSQL_PASSWORD) \
		--env MYSQL_ROOT_PASSWORD=$(MYSQL_ROOT_PASSWORD) \
		--env MYSQL_DATABASE=$(MYSQL_DATABASE) \
		--network $(PROJECT_NETWORK) \
		--volume ${PWD}/$(VOLUME_NAME):/var/lib/mysql \
		mysql:lts-oracle

run_laravel:
	docker run -d --name $(PROJECT_NAME)_laravel \
		-p 8080:8000 \
		--env DB_HOST=$(PROJECT_NAME)_mysql \
		--env DB_PORT=$(MYSQL_PORT) \
		--env DB_USERNAME=$(MYSQL_ROOT_USER) \
		--env DB_PASSWORD=$(MYSQL_ROOT_PASSWORD) \
		--env DB_DATABASE=$(MYSQL_DATABASE) \
		--network $(PROJECT_NETWORK) \
		--volume ${PWD}/$(PROJECT_VOLUME_APP):/app \
		bitnami/laravel:10.3.3-debian-12-r15

stop_mysql:
	docker stop $(PROJECT_NAME)_mysql

stop_laravel:
	docker stop $(PROJECT_NAME)_laravel

remove_mysql_container:
	docker rm $(PROJECT_NAME)_mysql

remove_laravel_container:
	docker rm $(PROJECT_NAME)_laravel

remove_network:
	docker network rm $(PROJECT_NETWORK)

remove_volume:
	docker volume rm $(VOLUME_NAME)

remove_volume_app:
	docker volume rm $(PROJECT_VOLUME_APP)

remove_all: remove_network remove_volume remove_volume_app 

remove_all_container: remove_mysql_container remove_laravel_container

init: create_network create_volume create_volume_app run_mysql_init run_laravel

stop: stop_mysql stop_laravel

cleanup: stop_mysql stop_laravel remove_mysql_container remove_laravel_container remove_network remove_volume remove_volume_app

start_mysql:
	docker start $(PROJECT_NAME)_mysql

start_laravel:
	docker start $(PROJECT_NAME)_laravel

start: start_mysql start_laravel

in_laravel:
	docker exec -it ${PROJECT_NAME}_laravel bash

in_mysql:
	docker exec -it ${PROJECT_NAME}_mysql mysql -uroot -p123456

in_mysql_init_db:
	docker exec -i ${PROJECT_NAME}_mysql mysql -uroot -p123456 < ./preps/init.sql

in_mysql_remove_db:
	docker exec -i ${PROJECT_NAME}_mysql mysql -uroot -p123456 < ./preps/remove.sql

in_mysql_check_db:
	docker exec -it ${PROJECT_NAME}_mysql mysql -u${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE} 

in_mysql_select_users:
	docker exec -i ${PROJECT_NAME}_mysql mysql -u${MYSQL_USER} -p${MYSQL_PASSWORD} < ./preps/get_users.sql


chmod_all:
	sudo chmod -R 777 ./app
