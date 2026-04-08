#!/usr/bin/env bash

# ============================================================
#  Pinchflat LXC Installer
#  Installs Docker and runs Pinchflat as a Docker container
#
#  Pinchflat is an Elixir/Phoenix web application distributed
#  exclusively as a Docker image. It cannot be installed
#  natively without Docker.
#
#  Image:   ghcr.io/kieraneglin/pinchflat:latest
#  Web UI:  http://<container-ip>:8945
#  Docs:    https://github.com/kieraneglin/pinchflat
# ============================================================

set -euo pipefail

# INSTALL DOCKER
echo "Installing Docker..."
apt-get update -qq
apt-get install -y -qq ca-certificates curl gnupg lsb-release

install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg \
  | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" \
  > /etc/apt/sources.list.d/docker.list

apt-get update -qq
apt-get install -y -qq docker-ce docker-ce-cli containerd.io docker-compose-plugin

systemctl enable --now docker
echo "Docker installed successfully"

# CREATE DIRECTORIES
# /config    - Pinchflat app config, database, and metadata
# /downloads - where downloaded media is stored
mkdir -p /opt/pinchflat/{config,downloads}
echo "Directories created: /opt/pinchflat/config and /opt/pinchflat/downloads"

# WRITE DOCKER COMPOSE
cat > /opt/pinchflat/docker-compose.yml <<'EOF'
services:
  pinchflat:
    image: ghcr.io/kieraneglin/pinchflat:latest
    container_name: pinchflat
    ports:
      - "8945:8945"
    volumes:
      - /opt/pinchflat/config:/config
      - /opt/pinchflat/downloads:/downloads
    environment:
      - TZ=UTC
    restart: unless-stopped
EOF

echo "docker-compose.yml written to /opt/pinchflat/"

# PULL IMAGE AND START
echo "Pulling Pinchflat image (this may take a moment)..."
docker compose -f /opt/pinchflat/docker-compose.yml pull

echo "Starting Pinchflat..."
docker compose -f /opt/pinchflat/docker-compose.yml up -d

echo ""
echo "Pinchflat is running!"
echo "Access the web UI at: http://$(hostname -I | awk '{print $1}'):8945"
echo ""
echo "Media is saved to: /opt/pinchflat/downloads"
echo "To customise the download path, edit /opt/pinchflat/docker-compose.yml"
