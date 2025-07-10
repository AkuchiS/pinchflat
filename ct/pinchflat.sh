#!/usr/bin/env bash

source /dev/stdin <<<"$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVED/main/misc/build.func)"

APP="Pinchflat"
var_tags="utility;cli;disk"
var_cpu="1"
var_ram="2048"
var_disk="10"
var_os="debian"
var_version="12"
var_unprivileged="1"

header_info "$APP"
variables
color
catch_errors

# Default fallback values if start() fails to set them
CTID="${CTID:-115}"
HN="${HN:-pinchflat}"
DISK_SIZE="${DISK_SIZE:-10}"
RAM_SIZE="${RAM_SIZE:-2048}"
CPU_CORES="${CPU_CORES:-1}"
BRG="${BRG:-vmbr0}"

start
description

msg_info "Running Install Script"
lxc-attach -n "$CTID" -- bash -c "$(curl -fsSL https://raw.githubusercontent.com/AkuchiS/pinchflat/main/install/pinchflat-install.sh)"
msg_ok "Installed ${APP}"

echo -e "${CREATING}${GN}${APP} setup has been successfully initialized!${CL}"
echo -e "${INFO}${YW} Access it using:${CL}"
echo -e "${TAB}${GN}pct console $CTID${CL}"
echo -e "${TAB}${GN}pinchflat${CL}"

