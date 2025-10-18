#!/usr/bin/env bash
# File: scripts/deploy.sh
set -euo pipefail

# ======================================================
#  CryptoMesh - Deploy Stack (router primero + rebuild)
# ======================================================
# Uso:
#   ./deploy.sh [COMPOSE_FILE] [PROJECT_NAME] [COMPOSE_PROFILES] [flags]
#
# Args:
#   COMPOSE_FILE      : docker-compose.yml por defecto
#   PROJECT_NAME      : "cryptomesh" por defecto
#   COMPOSE_PROFILES  : perfiles opcionales, ej: "api,dev"
#
# Flags:
#   --no-rebuild      : omite ./rebuild.sh
#
# Ejemplos:
#   ./deploy.sh
#   ./deploy.sh docker-compose.yml cryptomesh "api"
#   ./deploy.sh docker-compose.prod.yml cryptomesh "" --no-rebuild

COMPOSE_FILE=${1:-"docker-compose.yml"}
PROJECT_NAME=${2:-"cryptomesh"}
COMPOSE_PROFILES=${3:-""}

# Flags
NO_REBUILD=false
for arg in "${@:4}"; do
  case "${arg}" in
    --no-rebuild) NO_REBUILD=true ;;
    *) echo "⚠️  Flag desconocida: ${arg}"; exit 1 ;;
  esac
done

# --- Colores (#89CA78 ≈ 38;5;114) ---
C_MINT="\e[38;5;114m"
C_RESET="\e[0m"
info()  { echo -e "${C_MINT}ℹ️  $*${C_RESET}"; }
ok()    { echo -e "${C_MINT}✅ $*${C_RESET}"; }
warn()  { echo -e "⚠️  $*"; }
err()   { echo -e "❌ $*" >&2; }

# Banner
echo -e "${C_MINT}"
cat << "EOF"
 ██████╗██████╗ ██╗   ██╗██████╗ ████████╗ ██████╗ ███╗   ███╗███████╗███████╗██╗  ██╗
██╔════╝██╔══██╗╚██╗ ██╔╝██╔══██╗╚══██╔══╝██╔═══██╗████╗ ████║██╔════╝██╔════╝██║  ██║
██║     ██████╔╝ ╚████╔╝ ██████╔╝   ██║   ██║   ██║██╔████╔██║█████╗  ███████╗███████║
██║     ██╔══██╗  ╚██╔╝  ██╔═══╝    ██║   ██║   ██║██║╚██╔╝██║██╔══╝  ╚════██║██╔══██║
╚██████╗██║  ██║   ██║   ██║        ██║   ╚██████╔╝██║ ╚═╝ ██║███████╗███████║██║  ██║
 ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝        ╚═╝    ╚═════╝ ╚═╝     ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝
EOF
echo -e "${C_RESET}"

echo "=============================================="
echo " 🚀 Deploying CryptoMesh stack (router → stack)"
echo "----------------------------------------------"
echo " Compose file : ${COMPOSE_FILE}"
echo " Project name : ${PROJECT_NAME}"
[[ -n "${COMPOSE_PROFILES}" ]] && echo " Profiles     : ${COMPOSE_PROFILES}"
$NO_REBUILD  && echo " Rebuild      : omitido" || echo " Rebuild      : se ejecutará ./rebuild.sh"
echo "=============================================="

# ----------------------------------------------------
# 1) Crear red
# ----------------------------------------------------
info "Creando red 'cryptomesh-net' (si no existe)…"
docker network create -d bridge cryptomesh-net >/dev/null 2>&1 || true
ok "CryptoMesh network is ready"

# ----------------------------------------------------
# 2) Desplegar router primero
# ----------------------------------------------------
if [[ -x "./deploy_router.sh" ]]; then
  info "Deploying MictlanX router…"
  ./deploy_router.sh || echo "⚠️  Router no respondió completamente, continuando..."
else
  err "./deploy_router.sh no encontrado o no ejecutable. Es obligatorio desplegar router primero."
  exit 1
fi

# ----------------------------------------------------
# 3) Reiniciar stack de CryptoMesh
# ----------------------------------------------------
info "Apagando stack previo (si existe)…"
docker compose -p "${PROJECT_NAME}" -f "${COMPOSE_FILE}" down || true

# Rebuild opcional
if ! $NO_REBUILD; then
  if [[ -x "./rebuild.sh" ]]; then
    info "Ejecutando ./rebuild.sh …"
    ./rebuild.sh
  else
    warn "./rebuild.sh no encontrado o no ejecutable. Continuando sin rebuild."
  fi
fi

# ----------------------------------------------------
# 4) Levantar servicios
# ----------------------------------------------------
info "Levantando servicios con Docker Compose…"
if [[ -n "${COMPOSE_PROFILES}" ]]; then
  COMPOSE_PROFILES="${COMPOSE_PROFILES}" docker compose -p "${PROJECT_NAME}" -f "${COMPOSE_FILE}" up -d --build
else
  docker compose -p "${PROJECT_NAME}" -f "${COMPOSE_FILE}" up -d --build
fi

ok "✅ CryptoMesh service was deployed successfully!"

# ----------------------------------------------------
# 5) Tips
# ----------------------------------------------------
echo
info "Tips:"
echo "  - Ver servicios     : docker compose -p ${PROJECT_NAME} -f ${COMPOSE_FILE} ps"
echo "  - Logs en vivo      : docker compose -p ${PROJECT_NAME} -f ${COMPOSE_FILE} logs -f --tail=100"
echo "  - Reiniciar servicio: docker compose -p ${PROJECT_NAME} -f ${COMPOSE_FILE} restart <service>"
echo "  - Bajar stack       : docker compose -p ${PROJECT_NAME} -f ${COMPOSE_FILE} down"
