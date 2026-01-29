# Rundeck with Nginx Reverse Proxy

Production-ready Rundeck Docker image with built-in Nginx reverse proxy and Supervisor process management.

## Features

- **Rundeck** - Job scheduler and runbook automation
- **Nginx** - Reverse proxy with proper redirect handling
- **Supervisor** - Process management for both services
- **Flexible port mapping** - Works with any external port
- **Auto-updated** - Weekly builds with latest Rundeck releases

## Quick Start

```bash
# With PostgreSQL (recommended)
docker run -d \
  -p 8080:80 \
  -e RUNDECK_GRAILS_URL=http://localhost:8080 \
  -e RUNDECK_DATABASE_DRIVER=org.postgresql.Driver \
  -e RUNDECK_DATABASE_URL=jdbc:postgresql://postgres:5432/rundeck \
  -e RUNDECK_DATABASE_USERNAME=rundeck \
  -e RUNDECK_DATABASE_PASSWORD=secret \
  ffactory/rundeck

# Standalone (H2 database)
docker run -d -p 8080:80 -e RUNDECK_GRAILS_URL=http://localhost:8080 ffactory/rundeck
```

Access at http://localhost:8080 with `admin` / `admin`

## Port Configuration

Set `RUNDECK_GRAILS_URL` to match your external URL:

```bash
# Port 80
docker run -p 80:80 -e RUNDECK_GRAILS_URL=http://localhost ffactory/rundeck

# Port 8080
docker run -p 8080:80 -e RUNDECK_GRAILS_URL=http://localhost:8080 ffactory/rundeck

# Custom port
docker run -p 9000:80 -e RUNDECK_GRAILS_URL=http://localhost:9000 ffactory/rundeck
```

## Environment Variables

| Variable | Description |
|----------|-------------|
| `RUNDECK_GRAILS_URL` | External URL (must match port mapping) |
| `RUNDECK_DATABASE_URL` | JDBC connection string |
| `RUNDECK_DATABASE_USERNAME` | Database user |
| `RUNDECK_DATABASE_PASSWORD` | Database password |
| `RUNDECK_DATABASE_DRIVER` | JDBC driver class |

## Volumes

| Path | Description |
|------|-------------|
| `/home/rundeck/server/data` | Rundeck data |
| `/home/rundeck/var/logs` | Logs |
| `/home/rundeck/etc/realm.properties` | User authentication |
| `/etc/nginx/sites-available/rundeck.conf` | Nginx config |

## Docker Compose Example

```yaml
services:
  postgres:
    image: postgres:15
    environment:
      POSTGRES_DB: rundeck
      POSTGRES_USER: rundeck
      POSTGRES_PASSWORD: secret
    volumes:
      - postgres_data:/var/lib/postgresql/data

  rundeck:
    image: ffactory/rundeck
    ports:
      - "8080:80"
    environment:
      RUNDECK_GRAILS_URL: http://localhost:8080
      RUNDECK_DATABASE_DRIVER: org.postgresql.Driver
      RUNDECK_DATABASE_URL: jdbc:postgresql://postgres:5432/rundeck
      RUNDECK_DATABASE_USERNAME: rundeck
      RUNDECK_DATABASE_PASSWORD: secret
    volumes:
      - rundeck_data:/home/rundeck/server/data
    depends_on:
      - postgres

volumes:
  postgres_data:
  rundeck_data:
```

## Tags

- `latest` - Most recent build
- `<version>` - Specific Rundeck version (e.g., `5.15.0`)

## Source

GitHub: https://github.com/Walsen/rundeck-image

## Author

Sergio Rodriguez - https://blog.walsen.website
