#!/usr/bin/env bash
set -e  # Detener ejecución si ocurre algún error

# Variables (mismos parámetros que en ShieldX)
IMAGE_NAME=${1:-"cryptomesh:api"}
IMAGE_TAG=${2:-"latest"}
DOCKERFILE=${3:-"./Dockerfile"}
BUILD_CONTEXT=${4:-"."}
PUSH_FLAG=${2:-false}
# Banner de inicio para CryptoMesh
echo -e "\e[38;5;114m"  # Color cian
cat << "EOF"
 ██████╗██████╗ ██╗   ██╗██████╗ ████████╗ ██████╗ ███╗   ███╗███████╗███████╗██╗  ██╗
██╔════╝██╔══██╗╚██╗ ██╔╝██╔══██╗╚══██╔══╝██╔═══██╗████╗ ████║██╔════╝██╔════╝██║  ██║
██║     ██████╔╝ ╚████╔╝ ██████╔╝   ██║   ██║   ██║██╔████╔██║█████╗  ███████╗███████║
██║     ██╔══██╗  ╚██╔╝  ██╔═══╝    ██║   ██║   ██║██║╚██╔╝██║██╔══╝  ╚════██║██╔══██║
╚██████╗██║  ██║   ██║   ██║        ██║   ╚██████╔╝██║ ╚═╝ ██║███████╗███████║██║  ██║
 ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝        ╚═╝    ╚═════╝ ╚═╝     ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝
EOF
echo -e "\e[0m"  # Restaurar color por defecto
echo

echo "=============================================="
echo " 🛠️  Building CryptoMesh Docker image"
echo "----------------------------------------------"
echo " Image      : ${IMAGE_NAME}:${IMAGE_TAG}"
echo " Dockerfile : ${DOCKERFILE}"
echo " Context    : ${BUILD_CONTEXT}"
echo "=============================================="

# Construcción de la imagen local (sin normalizar tag, igual que ShieldX)
docker build -f "${DOCKERFILE}" -t "${IMAGE_NAME}:${IMAGE_TAG}" "${BUILD_CONTEXT}"

echo "✅ Image built successfully: ${IMAGE_NAME}:${IMAGE_TAG}"

if [ "$PUSH_FLAG" == true ]; then
    echo "📤 Pushing the image after build"
    docker push $IMAGE_NAME
    exit 0;
fi
