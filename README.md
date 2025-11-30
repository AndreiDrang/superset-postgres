# Superset PostgreSQL Docker Image

Custom Apache Superset Docker image with PostgreSQL support and Redis caching configuration.

## Overview

This Docker image extends Apache Superset with:
- PostgreSQL database support via `psycopg2-binary`
- Redis caching configuration
- Custom Superset configuration

## Building the Image

### Using Docker Directly

Build the image with a specific version tag:
```bash
docker build -t andreidrang/psycopg-superset:5.0.1 -f Dockerfile .
```

Build with the `latest` tag:
```bash
docker build -t andreidrang/psycopg-superset:latest -f Dockerfile .
```

### Using Makefile (Recommended)

The project includes a Makefile for easier build management:

Build the image:
```bash
make build
```

Build with latest tag:
```bash
make build-latest
```

Tag existing version as latest:
```bash
make tag-latest
```

## Configuration

### Environment Variables

The Superset configuration supports the following environment variables:

**Database Connection:**
- `SUPERSET_DATABASE_URI`
- `SUPERSET__SQLALCHEMY_DATABASE_URI`
- `DATABASE_URL`

**Redis Cache Configuration:**
- `CACHE_REDIS_HOST`
- `CACHE_REDIS_PORT`
- `CACHE_REDIS_DB`
- `CACHE_REDIS_USER`
- `CACHE_REDIS_PASSWORD`

If no database URI is set, it defaults to a local SQLite database.

### Redis Cache

The image is configured to use Redis for caching with environment variable-based configuration:

**Environment Variables:**
- `CACHE_REDIS_HOST`: Redis server hostname (optional)
- `CACHE_REDIS_PORT`: Redis server port (optional, defaults to 6379)
- `CACHE_REDIS_DB`: Redis database number (optional, defaults to 0)
- `CACHE_REDIS_USER`: Redis username (optional)
- `CACHE_REDIS_PASSWORD`: Redis password (optional)

**Cache Configuration:**
- **Metadata Cache**: Uses `CACHE_*` environment variables (prefix: `superset_metadata_cache`)
- **Data Cache**: Uses same Redis configuration (prefix: `superset_data_cache`)
- **Default Timeout**: 600 seconds

## Usage Example

### Running the Container

```bash
# Basic run with PostgreSQL
docker run -d \
  -p 8088:8088 \
  -e SUPERSET_DATABASE_URI="postgresql://user:password@host:5432/database" \
  --name superset \
  andreidrang/psycopg-superset:5.0.1

# With Redis cache
docker run -d \
  -p 8088:8088 \
  -e SUPERSET_DATABASE_URI="postgresql://user:password@host:5432/database" \
  -e CACHE_REDIS_HOST="redis-host" \
  -e CACHE_REDIS_PORT="6379" \
  -e CACHE_REDIS_DB="0" \
  -e CACHE_REDIS_USER="redisuser" \
  -e CACHE_REDIS_PASSWORD="redispassword" \
  --name superset \
  andreidrang/psycopg-superset:5.0.1
```

## Customization

### Modifying Image Configuration

Edit the variables at the top of the Makefile to customize:
- `IMAGE_NAME`: Docker image name and registry
- `VERSION`: Image version tag
- `DOCKERFILE`: Dockerfile path (if different)
- `BUILD_CONTEXT`: Build context directory

### Custom Configuration

Modify `superset_config.py` to add or change Superset configuration options.
