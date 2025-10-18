#!/bin/bash

# Nombre base de la imagen
IMAGE_NAME=${1:-"cryptomesh:api"}
PUSH_FLAG=${2:-false}


# Construcción de la imagen
echo "🚀 Building docker image: $IMAGE_NAME"
docker build -f ./Dockerfile -t $IMAGE_NAME .

if [ "$PUSH_FLAG" == true ]; then
    echo "📤 Pushing the image after build"
    docker push $IMAGE_NAME
    exit 0;
fi