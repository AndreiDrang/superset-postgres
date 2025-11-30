# Agent Guidelines for Superset-Postgres

## Project Overview
This project builds a custom Apache Superset Docker image that extends the official `apache/superset:5.0.0` base image with:
- PostgreSQL database support via `psycopg2-binary`
- Redis caching configuration
- Custom Superset configuration via `superset_config.py`

**Image Registry:** `andreidrang/psycopg-superset`  
**Current Version:** See `VERSION` in Makefile (currently 5.0.2)

## Build/Lint/Test Commands

### Build Commands
- `make build` - Build Docker image with version tag from Makefile
- `make build-latest` - Build Docker image with `latest` tag
- `make tag-latest` - Tag the versioned image as `latest`
- `make push` - Push versioned image to Docker registry
- `make push-latest` - Push `latest` image to registry
- `make push-all` - Build, tag, and push both versioned and latest images
- `make clean` - Remove local Docker images (versioned and latest)
- `make dev-build` - Build development image with `dev` tag
- `make info` - Show current image configuration
- `make help` - Show all available commands

### Testing
Test locally:
```bash
docker run -d -p 8088:8088 --name superset-test andreidrang/psycopg-superset:5.0.2
```

Test with PostgreSQL:
```bash
docker run -d -p 8088:8088 \
  -e SUPERSET_DATABASE_URI="postgresql://user:password@host:5432/database" \
  --name superset-test \
  andreidrang/psycopg-superset:5.0.2
```

## Docker Image Guidelines

### Dockerfile Best Practices
- **Base Image**: Always use official `apache/superset` images with specific version tags
- **Layer Optimization**: Combine RUN commands to minimize image layers
- **Security**: Always switch back to `superset` user after root operations
- **Cleanup**: Remove package manager cache in the same RUN command (`apt-get clean && rm -rf /var/lib/apt/lists/*`)
- **Dependencies**: Install system dependencies before Python packages
- **Configuration**: Copy config files and set environment variables before switching to non-root user
- **Multi-stage**: Not currently used, but consider if build complexity increases

### Image Versioning
- Update `VERSION` in Makefile when releasing new versions
- Version should match or be compatible with base Superset version
- Use semantic versioning (e.g., 5.0.2)
- Tag both versioned and `latest` for production releases

### Build Context
- Keep Dockerfile in project root
- Only copy necessary files (currently just `superset_config.py`)
- Use `.dockerignore` if build context grows

## Python Configuration Guidelines

### Code Style
- Use type hints: `from typing import Dict, Any`
- Use `Dict[str, Any]` for configuration dicts, avoid bare `typing.Any`
- Constants in UPPER_CASE, variables in snake_case
- Prefer f-strings for string interpolation
- Import order: standard library, third-party, local modules

### Configuration Patterns
- **Environment Variables**: Always use environment variables with fallbacks
- **Multiple Aliases**: Support multiple environment variable names for compatibility:
  - Database: `SUPERSET_DATABASE_URI`, `SUPERSET__SQLALCHEMY_DATABASE_URI`, `DATABASE_URL`
- **Defaults**: Provide sensible defaults (e.g., SQLite for database, None for optional Redis config)
- **Configuration Inheritance**: Use dict unpacking (`**config`) for configuration inheritance (see `DATA_CACHE_CONFIG`)
- **Validation**: Environment variables are optional; configuration should handle None values gracefully

### Superset Configuration
- Follow Superset configuration patterns from official documentation
- Cache configuration: Use `CACHE_CONFIG` and `DATA_CACHE_CONFIG` dicts
- Redis cache: Support all Redis connection parameters (host, port, db, user, password)
- Cache prefixes: Use descriptive prefixes (`superset_metadata_cache`, `superset_data_cache`)
- Timeout defaults: Set reasonable defaults (600 seconds for metadata cache)

## Environment Variables

### Database Configuration
- `SUPERSET_DATABASE_URI` - Primary database connection string
- `SUPERSET__SQLALCHEMY_DATABASE_URI` - Alternative Superset-specific variable
- `DATABASE_URL` - Generic fallback variable
- Default: SQLite at `/app/superset_home/superset.db` if none provided

### Redis Cache Configuration
- `CACHE_REDIS_HOST` - Redis server hostname (optional)
- `CACHE_REDIS_PORT` - Redis server port (optional, defaults to 6379)
- `CACHE_REDIS_DB` - Redis database number (optional, defaults to 0)
- `CACHE_REDIS_USER` - Redis username (optional)
- `CACHE_REDIS_PASSWORD` - Redis password (optional)

**Note**: All Redis variables are optional. If not provided, cache configuration will use None values.

## Security Guidelines
- **Non-root User**: Always run container as `superset` user (not root)
- **User Switching**: Use `USER root` only when necessary, switch back immediately
- **Minimal Privileges**: Install only required system packages
- **No-install-recommends**: Use `--no-install-recommends` for apt packages
- **Cache Cleaning**: Remove package manager caches to reduce image size
- **Secrets**: Never hardcode passwords or secrets; use environment variables only

## Documentation Guidelines
- **README.md**: Document all environment variables with descriptions and defaults
- **Examples**: Include practical docker run examples for common use cases
- **Version Updates**: Update version numbers in README when releasing
- **Configuration**: Document any changes to `superset_config.py` in README

## Makefile Guidelines
- **Variables**: Define image name, version, dockerfile, and build context at the top
- **Default Target**: Set `.DEFAULT_GOAL := help` for better UX
- **Help Target**: Use `##` comments for help descriptions
- **Error Handling**: Use `|| true` for cleanup commands that may fail
- **Target Dependencies**: Chain related targets (e.g., `push-all` depends on multiple targets)

## Project Structure
```
superset-postgres/
├── Dockerfile              # Main Docker image definition
├── Makefile               # Build automation and commands
├── superset_config.py     # Custom Superset configuration
├── README.md              # User documentation
└── AGENTS.md              # This file - development guidelines
```

## Common Tasks

### Adding a New Dependency
1. Add system package to Dockerfile RUN command (if needed)
2. Add Python package via `uv pip install` in Dockerfile
3. Update README.md if it affects configuration or usage
4. Test build: `make build`
5. Test run: `docker run` with appropriate environment variables

### Updating Superset Configuration
1. Edit `superset_config.py`
2. Test configuration syntax: `python -m py_compile superset_config.py`
3. Rebuild image: `make build`
4. Test with docker run
5. Update README.md if new environment variables are added

### Releasing a New Version
1. Update `VERSION` in Makefile
2. Update version references in README.md examples
3. Build: `make build`
4. Test: Run container and verify functionality
5. Tag: `make tag-latest`
6. Push: `make push-all`