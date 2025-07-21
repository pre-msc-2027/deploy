#!/bin/bash

set -e

# === Initialisation ===
PROJECT_NAME=$(basename "$PWD" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9')
DOMAIN="$PROJECT_NAME.local"
DOCKERFILE="Dockerfile"
COMPOSE_FILE="docker-compose.yml"

echo "Détection du type de projet"
# === Détetection du type de projet ===
if [ -f "package.json" ]; then
    IS_NODE=true

    # Tentaive du type de projet ===
    npm run build 2>/dev/null || true
    if [ -d "dist" ]; then
        BUILD_FOLDER="dist"
    elif [ -d "build" ]; then
        BUILD_FOLDER="build"
    else
        BUILD_FOLDER="public"
    fi
else
    IS_NODE=false
fi

# === Génération du Dockerfile ===
echo "Génération du Dockerfile"
if [ "$IS_NODE" = true ]; then
    cat <<EOF > "$DOCKERFILE"
# Etape 1 : build
FROM node:18 AS builder
WORKDIR /app
COPY . .
RUN npm install
RUN npm run build

# Etape 2 : serveur
FROM nginx:alpine
COPY --from=builder /app/$BUILD_FOLDER /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EOF
else
    cat <<EOF > "$DOCKERFILE"
FROM nginx:alpine
COPY . /usr/share/nginx/html
EOF
fi

# === Génération du docker-compose.yml ===
echo "Génération du docker-compose.yml"
cat <<EOF > "$COMPOSE_FILE"

services:
  $PROJECT_NAME:
    build: .
    container_name: $PROJECT_NAME
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.$PROJECT_NAME.rule=Host(\`$DOMAIN\`)"
      - "traefik.http.routers.$PROJECT_NAME.entrypoints=web"
      - "traefik.http.services.$PROJECT_NAME.loadbalancer.server.port=80"
    networks:
      - traefik
networks:
  traefik:
    external: true
EOF


# le lien d'acces du projet serait alors : http://$DOMAIN
