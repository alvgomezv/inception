name = Inception

all:
	@printf "Launching containers: ${name}...\n"
	@bash srcs/requirements/wordpress/tools/make_dir.sh
	@cd srcs && docker-compose build
	@cd srcs && docker-compose up -d

build:
	@printf "Building images: ${name} ...\n"
	@cd srcs && docker-compose build

down:
	@printf "Stopping containers: ${name} ...\n"
	@cd srcs && docker-compose down
	@docker stop portainer || true

re:	down
	@printf "Rebuilding containers: ${name} ...\n"
	@cd srcs && docker-compose build
	@cd srcs && docker-compose up -d
	

clean: down
	@printf "Cleaning containers: ${name} ... \n"
	@docker system prune -a
	@sudo rm -rf ~/data

fclean: down 
	@printf "Total clean of all containers: ${name} ... \n"
	@docker system prune --all --force --volumes
	@docker network prune --force
	@docker volume rm srcs_db-data srcs_wp-data portainer_data || true
	@sudo rm -rf ~/data

portainer:
	@printf "Creating and running Portainer container...\n"
	@docker stop portainer || true
	@docker rm portainer || true
	@docker volume rm portainer_data || true
	@docker volume create portainer_data
	@docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:2.11.1

.PHONY	: all build down re clean fclean portainer