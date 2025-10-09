import os
# Base Configuration for CryptoMesh

# MongoDB Settings
MONGODB_URI = os.environ.get("MONGODB_URI", "mongodb://localhost:27017/cryptomesh")
MONGO_DATABASE_NAME = os.environ.get("MONGO_DATABASE_NAME", "cryptomesh")

# API Settings
CRYPTO_MESH_HOST              = os.environ.get("CRYPTO_MESH_HOST", "0.0.0.0")
CRYPTO_MESH_PORT              = int(os.environ.get("CRYPTO_MESH_PORT", "19000"))
CRYPTO_MESH_TITLE             = os.environ.get("CRYPTO_MESH_TITLE", "CryptoMesh API")
CRYPTO_MESH_API_PREFIX        = os.environ.get("CRYPTO_MESH_API_PREFIX", "/api/v1")
CRYPTO_MESH_VERSION           = os.environ.get("CRYPTO_MESH_VERSION", "1.0.0")
CRYPTOMESH_ENDPOINT_REQ_RES_BASE_PORT = int(os.environ.get("CRYPTOMESH_ENDPOINT_REQ_RES_BASE_PORT", "40000"))
CRYPTOMESH_ENDPOINT_PUBSUB_BASE_PORT   = int(os.environ.get("CRYPTOMESH_ENDPOINT_PUBSUB_BASE_PORT", "50000"))
# Debugging
CRYPTO_MESH_DEBUG = bool(int(os.environ.get("CRYPTO_MESH_DEBUG", "1")))

SHIELDX_API_PREFIX = os.environ.get("SHIELDX_API_PREFIX", "/api/v1")
SHIELDX_HOST = os.environ.get("SHIELDX_HOST", "0.0.0.0")
SHIELDX_PORT = int(os.environ.get("SHIELDX_PORT", "20000"))

# ========================
# Configuración de ShieldX Client
# ========================
SHIELDX_CLIENT_BASE_URL = os.environ.get(
    "SHIELDX_CLIENT_BASE_URL",
    f"http://{SHIELDX_HOST}:{SHIELDX_PORT}{SHIELDX_API_PREFIX}"
)



# Logging Configuration
CRYPTO_MESH_LOG_PATH = os.environ.get("CRYPTO_MESH_LOG_PATH", "./logs")
CRYPTO_MESH_LOG_LEVEL = os.environ.get("CRYPTO_MESH_LOG_LEVEL", "DEBUG")
CRYPTO_MESH_LOG_ROTATION_WHEN = os.environ.get("CRYPTO_MESH_LOG_ROTATION_WHEN", "m")
CRYPTO_MESH_LOG_ROTATION_INTERVAL = int(os.environ.get("CRYPTO_MESH_LOG_ROTATION_INTERVAL", "10"))
CRYPTO_MESH_LOG_TO_FILE = bool(int(os.environ.get("CRYPTO_MESH_LOG_TO_FILE", "1")))
CRYPTO_MESH_LOG_ERROR_FILE = bool(int(os.environ.get("CRYPTO_MESH_LOG_ERROR_FILE", "0")))
