# Rundeck Docker Image

Custom Rundeck Docker image with Nginx reverse proxy, Supervisor process management, and pre-installed plugins.

## Features

- **Nginx Reverse Proxy** — Flexible port mapping with automatic configuration
- **Supervisor Process Management** — Reliable multi-process container
- **PostgreSQL Support** — Production-ready database backend
- **Pre-installed Plugins:**
  - [rundeck-node-to-node](https://github.com/Walsen/rundeck-node-to-node) — Node-to-node file copy plugin (automatically updated to latest version)

## Quick Start

```bash
# Using Docker Compose (recommended)
docker compose up -d

# Or standalone
docker run -d -p 8080:80 \
  -e RUNDECK_GRAILS_URL=http://localhost:8080 \
  ffactory/rundeck
```

Access Rundeck at `http://localhost:8080` with default credentials: `admin / admin`

## Tags

- `latest` — Latest Rundeck version with latest image revision
- `<rundeck-version>-<image-version>` — Specific versions (e.g., `5.18.0-1.0.0`)
- `<rundeck-version>` — Latest image revision for a specific Rundeck version

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `RUNDECK_GRAILS_URL` | `http://localhost:8080` | External URL (must match your port mapping) |
| `RUNDECK_DATABASE_URL` | - | PostgreSQL JDBC URL |
| `RUNDECK_DATABASE_USERNAME` | - | Database username |
| `RUNDECK_DATABASE_PASSWORD` | - | Database password |

## Custom Port Mapping

```bash
# Port 80
docker run -p 80:80 -e RUNDECK_GRAILS_URL=http://localhost ffactory/rundeck

# Port 9000
docker run -p 9000:80 -e RUNDECK_GRAILS_URL=http://localhost:9000 ffactory/rundeck
```

## Docker Compose Example

```yaml
services:
  postgres:
    image: postgres:15
    environment:
      POSTGRES_DB: rundeck
      POSTGRES_USER: rundeck
      POSTGRES_PASSWORD: rundeck123
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U rundeck"]
      interval: 10s
      timeout: 5s
      retries: 5

  rundeck:
    image: ffactory/rundeck:latest
    ports:
      - "8080:80"
    environment:
      RUNDECK_GRAILS_URL: http://localhost:8080
      RUNDECK_DATABASE_DRIVER: org.postgresql.Driver
      RUNDECK_DATABASE_USERNAME: rundeck
      RUNDECK_DATABASE_PASSWORD: rundeck123
      RUNDECK_DATABASE_URL: jdbc:postgresql://postgres:5432/rundeck
    volumes:
      - rundeck_data:/home/rundeck/server/data
      - rundeck_logs:/home/rundeck/var/logs
    depends_on:
      postgres:
        condition: service_healthy

volumes:
  postgres_data:
  rundeck_data:
  rundeck_logs:
```

## Source & Documentation

- **GitHub:** https://github.com/Walsen/rundeck-image
- **Author:** Sergio Rodriguez
- **Blog:** https://blog.walsen.website
