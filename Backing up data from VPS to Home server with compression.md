---
title: Backing up data from VPS to Home server with compression
date: 2026-03-14
---

I needed to back up all files in `/root` on my VPS before shutting it down, saving them as a compressed archive on my home server. The catch: my home server is on a local network and not directly reachable from the internet, so the VPS can't SSH into it directly.

The solution is to stream the archive over SSH with maximum gzip compression, routing through a reverse tunnel opened from my laptop.

## The setup

- **Laptop** — where I run all commands from, with both `vps` and `home` configured in `~/.ssh/config`
- **VPS** — internet-facing server, data lives in `/root`
- **Home server** — local network only, backup destination at `/home/emad/vps`

Since the VPS can't reach the home server directly, the laptop opens a reverse SSH tunnel so that a port on the VPS forwards to the home server through the laptop.

## Step 1 — Open the reverse tunnel

In one terminal, run from your laptop:

```bash
ssh -R 2222:home:22 vps
```

This makes port `2222` on the VPS transparently forward to port `22` on the home server via your laptop. Keep this terminal open for the duration of the backup.

## Step 2 — Run the backup

In a second terminal, run from your laptop:

```bash
ssh -A vps \
  "tar -cf - -C / root | gzip -9 | ssh -o StrictHostKeyChecking=no -p 2222 emad@localhost \
  'mkdir -p /home/emad/vps && cat > /home/emad/vps/vps-backup-\$(date +%Y%m%d).tar.gz'"
```

A few things worth noting:

- `-A` forwards your SSH agent to the VPS so it can authenticate to the tunnel without a separate key
- `tar -cf - -C / root` streams the `/root` directory to stdout — no temp file needed on the VPS
- `gzip -9` applies maximum compression before the data goes over the wire
- The VPS connects to `localhost:2222`, which your laptop forwards to the home server
- `emad@localhost` is explicit because the VPS doesn't have your laptop's SSH config and doesn't know the username for the home server
- The archive is named `vps-backup-YYYYMMDD.tar.gz` using the current date

## Verify the backup

Once the command finishes, SSH into your home server and check:

```bash
ls -lh /home/emad/vps/
```

You should see the archive with a reasonable size. To test the integrity of the archive:

```bash
tar -tzf /home/emad/vps/vps-backup-*.tar.gz | head
```
