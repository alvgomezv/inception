name = Inception

all:
	@printf "Launching containers: ${name}...\n"
	@bash srcs/requirements/wordpress/tools/make_dir.sh
	@docker-compose -f ./srcs/docker-compose.yml up -d

build:
	@printf "Building images: ${name} ...\n"
	@docker-compose -f ./srcs/docker-compose.yml up -d --build

down:
	@printf "Stopping containers: ${name} ...\n"
	@docker-compose -f ./srcs/docker-compose.yml down
	@docker stop portainer

re:	down
	@printf "Rebuilding containers: ${name} ...\n"
	@docker-compose -f ./srcs/docker-compose.yml up -d --build
	

clean: down
	@printf "Cleaning containers: ${name} ... \n"
	@docker system prune -a
	@sudo rm -rf ~/data

fclean:
	@printf "Total clean of all containers: ${name} ... \n"
	@docker stop $$(docker ps -qa)
	@docker system prune --all --force --volumes
	@docker network prune --force
	@docker volume prune --force
	@sudo rm -rf ~/data

portainer:
	@printf "Creating and running Portainer container...\n"
	@docker volume create portainer_data
	@docker stop portainer || true
	@docker rm portainer || true
	@docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:2.11.1

.PHONY	: all build down re clean fclean portainer