.PHONY: all up down create-data-mysql

all: up create-data-mysql

up:
	@echo "Start ETL Process"
	docker compose up -d --build 

down:
	@echo "Dashboard Down and ETL process"
	docker compose down

create-data-mysql:
	@echo "Add data from mysql"
	. ./mysql_container/project.sh
