.PHONY: dbt

build:
	docker-compose --project-name dbt-local up --build -d

up:
	docker-compose --project-name dbt-local up -d

down:
	docker-compose --project-name dbt-local down

dbt:
	docker exec -it dbt bash