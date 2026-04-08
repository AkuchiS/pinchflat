# pinchflat — Proxmox LXC Installer

Installs [Pinchflat](https://github.com/kieraneglin/pinchflat) as a Docker container inside a Proxmox LXC.

Pinchflat is a self-hosted YouTube media manager built with Elixir/Phoenix. It automatically downloads videos from channels and playlists using yt-dlp and integrates with media servers like Plex and Jellyfin.

## Why Docker?

Pinchflat is an Elixir application distributed **exclusively as a Docker image** — no native Linux binaries are published. This script installs Docker inside an LXC container and runs Pinchflat via Docker Compose, which is the only supported installation method.

## Requirements

- Proxmox VE 7+
- Run the CT script on the Proxmox host as root
- Internet access from the container

## Usage

Run on your Proxmox host:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/AkuchiS/pinchflat/main/ct/pinchflat.sh)"
```

This will:
1. Create a Debian 12 LXC container (2 CPU, 2GB RAM, 10GB disk)
2. Install Docker inside the container
3. Write a Docker Compose file to `/opt/pinchflat/`
4. Pull the latest Pinchflat image and start the container

## Access

Once installed, open the Pinchflat web UI at:

```
http://<container-ip>:8945
```

## Storage

| Path | Purpose |
|------|---------|
| `/opt/pinchflat/config` | App config, database, metadata |
| `/opt/pinchflat/downloads` | Downloaded media |

To change the download location, edit `/opt/pinchflat/docker-compose.yml` and update the volume mount for `/downloads` before first run.

## Updating

Re-run the CT script on an already-installed container to pull the latest image and restart:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/AkuchiS/pinchflat/main/ct/pinchflat.sh)"
```

## Notes

- Pinchflat is developed by [@kieraneglin](https://github.com/kieraneglin)
- This installer is not affiliated with the Pinchflat project
- This script cannot be submitted to [community-scripts/ProxmoxVE](https://github.com/community-scripts/ProxmoxVE) as they require bare-metal (non-Docker) installs

## License

MIT
