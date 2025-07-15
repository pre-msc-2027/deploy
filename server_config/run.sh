echo "create docker network traefik...";
docker network create traefik;
echo "create portainer_data volume";
docker volume create portainer_data;
echo "docker compose up -d";
docker compose up -d
