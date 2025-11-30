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

The Superset configuration supports the following environment variables for database connection:

- `SUPERSET_DATABASE_URI`
- `SUPERSET__SQLALCHEMY_DATABASE_URI`
- `DATABASE_URL`

If none are set, it defaults to a local SQLite database.

### Redis Cache

The image is configured to use Redis for caching with the following settings:
- **Metadata Cache**: `redis://localhost:6379/0` (prefix: `superset_metadata_cache`)
- **Data Cache**: `redis://localhost:6379/0` (prefix: `superset_data_cache`)
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
  -e CACHE_REDIS_URL="redis://redis-host:6379/0" \
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
