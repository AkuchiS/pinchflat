#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/build.func)
# Copyright (c) 2024 community-scripts ORG
# Author: AkuchiS
# License: MIT | https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE

# App metadata
APP="Pinchflat"
var_tags="media;youtube;docker"
var_cpu="2"
var_ram="2048"
var_disk="10"
var_os="debian"
var_version="12"
var_unprivileged="1"

# ── UPDATE FUNCTION ───────────────────────────────────────────
# Called when script is run on an already-installed container
update_script() {
  header_info
  check_container_storage
  check_container_resources

  if [[ ! -f /opt/pinchflat/docker-compose.yml ]]; then
    msg_error "No Pinchflat installation found in /opt/pinchflat"
    exit 1
  fi

  msg_info "Pulling latest Pinchflat image"
  docker compose -f /opt/pinchflat/docker-compose.yml pull
  msg_ok "Image updated"

  msg_info "Restarting Pinchflat"
  docker compose -f /opt/pinchflat/docker-compose.yml up -d
  msg_ok "Pinchflat restarted"

  exit
}

start
build_container

# Explicitly call install script from this repo — build.func resolves
# scripts from community-scripts/ProxmoxVE, not from AkuchiS/pinchflat
msg_info "Running Pinchflat install script"
bash -c "$(curl -fsSL https://raw.githubusercontent.com/AkuchiS/pinchflat/main/install/pinchflat-install.sh)"
msg_ok "Pinchflat installed"

description

msg_ok "Completed Successfully!"
echo -e "${CREATING}${GN}${APP} setup has been completed successfully!${CL}"
echo -e "${INFO}${YW} Access Pinchflat at:${CL}"
echo -e "${TAB}${GATEWAY}${BGN}http://${IP}:8945${CL}"
