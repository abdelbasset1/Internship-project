#!/usr/bin/env bash
set -euo pipefail

sudo dnf update -y
sudo dnf install -y nginx

# Replace default site with our frontend
sudo rm -rf /usr/share/nginx/html/*

#sudo cp -r /tmp/frontend/frontend/* /usr/share/nginx/html/
# Find where the frontend files landed (Packer may nest the folder)
if [ -f "/tmp/frontend/index.html" ]; then
  FRONTEND_SRC="/tmp/frontend"
elif [ -f "/tmp/frontend/frontend/index.html" ]; then
  FRONTEND_SRC="/tmp/frontend/frontend"
else
  echo "ERROR: Frontend files not found in /tmp/frontend or /tmp/frontend/frontend"
  echo "DEBUG: ls -la /tmp"
  ls -la /tmp || true
  echo "DEBUG: ls -la /tmp/frontend"
  ls -la /tmp/frontend || true
  echo "DEBUG: ls -la /tmp/frontend/frontend"
  ls -la /tmp/frontend/frontend || true
  exit 1
fi

sudo cp -r "${FRONTEND_SRC}"/* /usr/share/nginx/html/


sudo chown -R root:root /usr/share/nginx/html
sudo chmod -R 755 /usr/share/nginx/html

# Enable and start nginx
sudo systemctl enable nginx
sudo systemctl start nginx

# Validate nginx config and confirm it serves content locally
sudo nginx -t
curl -I http://localhost
