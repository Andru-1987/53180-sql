COMPOSE_PROJECT_NAME=mysql

SERVICE_NAME=mysql
HOST=127.0.0.1
PORT=3306
PASSWORD=anderson123!

DATABASE_CREATION=./database_ddl.sql
DATABASE_POPULATION=./population.sql

FILES := $(wildcard ./objetos_sql/*.sql)


.PHONY: all up objects clean

all: up objects

up:

	@echo "Create the instance of docker"
	docker compose up -d --build

	. ./waiter.sh

	@echo "Waiting for MySQL to be ready..."

	@echo "Create the import and run de script"
	docker exec -it mysql mysql -u root -p$(PASSWORD) -e "source $(DATABASE_CREATION);"
	docker exec -it mysql mysql -u root -p$(PASSWORD) --local-infile=1 -e "source $(DATABASE_POPULATION)"

objects:
	@echo "Create objects in database"
	@for file in $(FILES); do \
	    echo "Processing $$file"; \
		docker exec -it mysql  mysql -u root -p$(PASSWORD) -e "source $$file"; \
	done

clean:
	@echo "Remove the Database"
	docker exec -it mysql mysql -u root -p$(PASSWORD) --host $(HOST) --port $(PORT) -e "DROP DATABASE IF EXISTS mozo_atr;"
	@echo "Bye"
	docker compose down

