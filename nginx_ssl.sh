#!/bin/bash

# Fail immediately if any command fails
set -e

# Variables
CERT_PATH="/etc/ssl/cloudflare"
NGINX_CONF="/etc/nginx/sites-available/privatebin"
NGINX_CONF_SSL="/etc/nginx/sites-available/privatebin_ssl"

# Install dependencies
sudo apt update
sudo apt install -y nginx docker-compose

# Create the necessary directories for SSL certificates
sudo mkdir -p $CERT_PATH

# Deploy Cloudflare Origin Certs (from GitHub secrets)
echo "$CLOUDFLARE_CERT" | sudo tee $CERT_PATH/cert.pem > /dev/null
echo "$CLOUDFLARE_KEY" | sudo tee $CERT_PATH/key.pem > /dev/null

# Set up Nginx Reverse Proxy (non-SSL)
sudo tee $NGINX_CONF <<EOL
server {
    listen 80;
    server_name app.thgbin.co.uk;

    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}
EOL

# Set up Nginx Reverse Proxy (SSL)
sudo tee $NGINX_CONF_SSL <<EOL
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
    }
}

server {
    listen 80;
    server_name app.thgbin.co.uk;
    return 301 https://\$host\$request_uri;
}
EOL

# Enable the Nginx site configuration
sudo ln -s $NGINX_CONF /etc/nginx/sites-enabled/
sudo ln -s $NGINX_CONF_SSL /etc/nginx/sites-enabled/

# Restart Nginx to apply the changes
sudo systemctl restart nginx
