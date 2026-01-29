# Rundeck Docker Image
# Author: Sergio Rodriguez <sergio.rodriguez@cbba.cloud.org.bo>
# GitHub: https://github.com/Walsen
# Blog: https://blog.walsen.website
# Date: 2026-01-28

ARG RUNDECK_VERSION=5.15.0
FROM rundeck/rundeck:${RUNDECK_VERSION}

USER root

# Install only essential packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    nginx \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# Setup nginx directories
RUN mkdir -p /etc/nginx/sites-enabled /etc/nginx/ssl

# Copy configurations
COPY config/nginx.conf /etc/nginx/nginx.conf
COPY config/rundeck-site.conf /etc/nginx/sites-available/rundeck.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY start-services.sh /usr/local/bin/start-services.sh

# Copy realm properties
COPY config/realm.properties /home/rundeck/etc/realm.properties

# Set permissions
RUN chmod +x /usr/local/bin/start-services.sh && \
    chown -R rundeck:root /home/rundeck/etc/ && \
    chmod 600 /home/rundeck/etc/realm.properties

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/start-services.sh"]
