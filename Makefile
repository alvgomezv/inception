name = alvgomez

all:
	@docker-compose -f ./srcs/docker-compose.yml up -d

build:
	@docker-compose -f ./srcs/docker-compose.yml up -d --build

down:
	@docker-compose -f ./srcs/docker-compose.yml down

re:	down
	@docker-compose -f ./srcs/docker-compose.yml up -d --build

clean: down
	@docker system prune -a

fclean: down
	@docker system prune --all --force --volumes
	@docker network prune --force
	@docker volume prune --force

.PHONY	: all build down re clean fclean