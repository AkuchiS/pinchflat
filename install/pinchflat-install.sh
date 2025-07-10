#!/usr/bin/env bash
set -e

apt update
apt install -y curl python3 python3-venv python3-pip

mkdir -p /opt/pinchflat && cd /opt/pinchflat
curl -L https://github.com/kieraneglin/pinchflat/archive/refs/heads/main.tar.gz | tar -xz --strip-components=1

python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip

# If a requirements file exists
[ -f requirements.txt ] && pip install -r requirements.txt || pip install yt-dlp

ln -s /opt/pinchflat/pinchflat.sh /usr/local/bin/pinchflat || true

