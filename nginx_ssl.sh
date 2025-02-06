#!/bin/bash

# Fail immediately if any command fails
set -e

# Variables
CERT_PATH="/etc/ssl/cloudflare"
NGINX_CONF="/etc/nginx/sites-available/privatebin"

# Install dependencies
sudo apt update
sudo apt install -y nginx docker-compose


# Set up Nginx Reverse Proxy (single file for both HTTP & HTTPS)
sudo tee $NGINX_CONF <<EOL
server {
    listen 443 ssl;
    server_name app.thgbin.co.uk;

    ssl_certificate $CERT_PATH/cert.pem;
    ssl_certificate_key $CERT_PATH/key.pem;

    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}

server {
    listen 80;
    server_name app.thgbin.co.uk;
    return 301 https://\$host\$request_uri;
}
EOL

# Remove old symlink if it exists
sudo rm -f /etc/nginx/sites-enabled/privatebin

# Enable the Nginx site configuration
sudo ln -s $NGINX_CONF /etc/nginx/sites-enabled/

# Restart Nginx to apply the changes
sudo systemctl restart nginx
