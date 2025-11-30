import os
from typing import Dict, Any

db_uri = (
    os.environ.get("SUPERSET_DATABASE_URI")
    or os.environ.get("SUPERSET__SQLALCHEMY_DATABASE_URI")
    or os.environ.get("DATABASE_URL")
)

SQLALCHEMY_DATABASE_URI = db_uri or "sqlite:////app/superset_home/superset.db"

# More info - https://superset.apache.org/docs/configuration/cache/
CACHE_CONFIG: Dict[str, Any] = {
    "CACHE_TYPE": "RedisCache",
    "CACHE_DEFAULT_TIMEOUT": os.environ.get("CACHE_DEFAULT_TIMEOUT", 600),
    "CACHE_KEY_PREFIX": "superset_metadata_cache",
    "CACHE_REDIS_HOST": os.environ.get("CACHE_REDIS_HOST"),
    "CACHE_REDIS_PORT": os.environ.get("CACHE_REDIS_PORT"),
    "CACHE_REDIS_DB": os.environ.get("CACHE_REDIS_DB"),
    "CACHE_REDIS_USER": os.environ.get("CACHE_REDIS_USER"),
    "CACHE_REDIS_PASSWORD": os.environ.get("CACHE_REDIS_PASSWORD"),
}

DATA_CACHE_CONFIG: Dict[str, Any] = {
    "CACHE_KEY_PREFIX": "superset_data_cache",
    **CACHE_CONFIG,
}
