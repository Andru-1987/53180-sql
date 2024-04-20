COMPOSE_PROJECT_NAME=mysql

SERVICE_NAME=mysql
HOST=127.0.0.1
PORT=3306
PASSWORD=anderson123!

DATABASE_CREATION=database_ddl.sql
DATABASE_POPULATION=population.sql

FILES := $(wildcard ./objetos_sql/*.sql)


.PHONY: all up objects clean

all: up objects

up:
	@echo "Create the import and run de script"
	mysql -u root -p$(PASSWORD) --host $(HOST) --port $(PORT) -e "source $(DATABASE_CREATION) ;"
	mysql -u root -p$(PASSWORD) --host $(HOST) --port $(PORT) --local-infile=1 -e "source $(DATABASE_POPULATION)"

objects:
	@echo "Create objects in database"
	@for file in $(FILES); do \
	    echo "Processing $$file"; \
		mysql -u root -p$(PASSWORD) --host $(HOST) --port $(PORT) -e "source $$file"; \
	done

clean:
	@echo "Remove the Database"
	@mysql -u root -p$(PASSWORD) --host $(HOST) --port $(PORT) -e "DROP DATABASE IF EXISTS mozo_atr;"
	@echo "Bye"



