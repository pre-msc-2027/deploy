#!/bin/bash
## Automated labeling script for CI/CD
SITE=${SITE}
BUILD=${BUILD}
DOMAIN=${DOMAIN}

build_image() {
    echo "building docker image for $SITE"
    docker build \
        --build-arg $BUILD \
        --tag $SITE:latest \
        --rm
}

compose() {
    docker compose up -d --build --env SITE=$SITE DOMAIN=$DOMAIN
}


build_image
compose
