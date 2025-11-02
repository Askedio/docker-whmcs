# Docker WHMCS Development Environment

A complete Docker-based development environment for WHMCS with PHP 8.2, Apache, ionCube Loader, MariaDB, and MailHog. Perfect for developing addons, gateways, server modules, hooks, and templates.

[![Docker Hub](https://img.shields.io/badge/docker%20hub-askedio%2Fwhmcs-blue)](https://hub.docker.com/r/askedio/whmcs)

## Features

- **PHP 8.2 + Apache** with all required extensions
- **ionCube Loader** (automatically installed)
- **MariaDB 10.6** database
- **MailHog** for capturing outbound emails (no real emails sent)
- **Live reload** - edit code locally, refresh browser
- **Works on Apple Silicon** (M1/M2/M3) via emulation
- **No host dependencies** - everything runs in Docker

---

## Quick Start

### Option 1: Use Pre-built Docker Image (Recommended)

1. **Clone this repository:**
   ```bash
   git clone https://github.com/Askedio/docker-whmcs.git
   cd docker-whmcs
   ```

2. **Update docker-compose.yml to use Docker Hub image:**
   
   Edit `docker-compose.yml` and change the `whmcs` service:
   ```yaml
   whmcs:
     platform: linux/amd64
     # Use pre-built image from Docker Hub
     image: askedio/whmcs:latest
     # Comment out the build section
     # build:
     #   context: ./web
     #   dockerfile: Dockerfile
   ```

3. **Add your WHMCS files:**
   ```bash
   # Extract your WHMCS ZIP file into the whmcs/ directory
   # The whmcs/ directory should contain index.php, admin/, modules/, etc.
   mkdir -p whmcs
   # Then unzip your WHMCS download into ./whmcs
   ```

4. **Start the stack:**
   ```bash
   docker compose up -d
   ```

5. **Access WHMCS Installer:**
   
   Open http://localhost:8080/install in your browser to begin the WHMCS installation.

   **Database Connection Settings** (use these during installation):
   - Database Hostname: `db`
   - Database Name: `whmcs`
   - Database Username: `whmcs`
   - Database Password: `whmcs`
   
   You'll also need your WHMCS license key during the installation process.

   **MailHog UI:** http://localhost:8025 (view captured emails)

### Option 2: Build Locally

If you prefer to build the image yourself:

1. **Clone and prepare:**
   ```bash
   git clone https://github.com/Askedio/docker-whmcs.git
   cd docker-whmcs
   mkdir -p whmcs
   # Extract your WHMCS ZIP into ./whmcs
   ```

2. **Build and start:**
   ```bash
   docker compose build
   docker compose up -d
   ```

3. **Access WHMCS Installer:**
   
   Open http://localhost:8080/install in your browser.

   **Database Connection Settings:**
   - Database Hostname: `db`
   - Database Name: `whmcs`
   - Database Username: `whmcs`
   - Database Password: `whmcs`
   
   You'll also need your WHMCS license key during installation.

---

## Prerequisites

- Docker and Docker Compose
- A WHMCS license key (get a free dev license from your WHMCS account)
- WHMCS installation files (download from WHMCS client area)

---

## Important: WHMCS License Required

**You need a valid WHMCS license to use this environment.**

WHMCS will not run without a license key. If you have an active WHMCS license, you can usually generate a free "development" license from your WHMCS account that works with local/non-public URLs.

---

## Platform Support

### Works On All Platforms

This Docker setup works on:
- **Apple Silicon Macs** (M1/M2/M3) - via x86_64 emulation
- **Intel Macs** - native
- **Linux** (x86_64/AMD64) - native
- **Windows** (WSL2 or Docker Desktop) - native

The `docker-compose.yml` is configured with `platform: linux/amd64` on all services, which:
- Enables ionCube compatibility (ionCube only supports x86_64)
- Works seamlessly on Apple Silicon via Docker's built-in emulation
- Works natively on Intel/AMD systems

**No special configuration needed** - run `docker compose up` on any platform.

---

## Local WHMCS Files Setup

You place your WHMCS files locally in the `whmcs/` directory:

1. Download WHMCS from your WHMCS client area
2. Extract the ZIP file into the `whmcs/` folder:
   ```bash
   cd docker-whmcs
   mkdir -p whmcs
   # Extract your WHMCS ZIP so that whmcs/index.php exists
   ```
3. The files are bind-mounted into the container (see line 34 in `docker-compose.yml`: `./whmcs:/var/www/html`)
4. Edit files locally and see changes immediately - no rebuild needed.

The `whmcs/` directory is gitignored, so your WHMCS installation files stay private and aren't committed to the repository.

---

## Project Structure

```
docker-whmcs/
├── docker-compose.yml    # Main compose file
├── web/
│   ├── Dockerfile        # PHP/Apache image with ionCube
│   └── php.ini          # Development PHP settings
├── whmcs/               # YOUR WHMCS FILES GO HERE (not in repo)
│   ├── index.php
│   ├── admin/
│   ├── modules/
│   └── ...
└── README.md
```

### The `whmcs/` Directory

This directory is where you place your WHMCS application files:
- Extract your WHMCS ZIP file into this directory
- After installation, WHMCS will generate `configuration.php` here
- This folder is bind-mounted, so you can edit code locally and see changes immediately

**Note:** The `whmcs/` directory is gitignored. You must provide your own WHMCS files.

---

## Configuration

### Database Settings

Default database credentials (set in `docker-compose.yml`):
- Host: `db` (use this inside WHMCS, not `localhost`)
- Database: `whmcs`
- Username: `whmcs`
- Password: `whmcs`
- Root Password: `rootpass`

You can change these in `docker-compose.yml` before starting.

### MailHog Configuration

MailHog automatically captures all outbound emails. Configure WHMCS SMTP settings:
- Host: `mailhog`
- Port: `1025`
- No authentication
- No TLS

View captured emails at: http://localhost:8025

### Custom Domain (Optional)

If your dev license requires a specific domain:

1. Add to `/etc/hosts`:
   ```
   127.0.0.1 dev.whmcs.local
   ```

2. Access WHMCS at `http://dev.whmcs.local:8080`
3. Use `http://dev.whmcs.local:8080` as the System URL during installation

---

## Development Workflow

After WHMCS is installed:

1. **Edit code locally** in `./whmcs/modules/`, `./whmcs/templates/`, etc.
2. **Refresh browser** - changes appear immediately (no rebuild needed)
3. **Check MailHog** at http://localhost:8025 for test emails
4. **View logs:**
   ```bash
   docker compose logs -f whmcs
   ```

### Common Development Tasks

- **Add an addon:** Create `./whmcs/modules/addons/YourAddon/`
- **Add a gateway:** Create `./whmcs/modules/gateways/yourgateway/`
- **Add hooks:** Place files in `./whmcs/includes/hooks/`
- **Custom templates:** Edit files in `./whmcs/templates/`

All changes are live - refresh your browser to see updates.

---

## Docker Hub

### Pulling the Image

The pre-built image is available on Docker Hub:

```bash
docker pull askedio/whmcs:latest
```

### Publishing Updates to Docker Hub

If you're the maintainer and want to publish updates:

1. **Build for multiple platforms:**
   ```bash
   docker buildx create --use --name multiarch
   docker buildx build --platform linux/amd64,linux/arm64 \
     -t askedio/whmcs:latest \
     -t askedio/whmcs:8.2 \
     ./web \
     --push
   ```

2. **Or build and push manually:**
   ```bash
   docker build -t askedio/whmcs:latest ./web
   docker push askedio/whmcs:latest
   ```

---

## Troubleshooting

### ionCube Error

If you see ionCube loader errors:
- **Apple Silicon:** Make sure `platform: linux/amd64` is set in `docker-compose.yml`
- **Verify ionCube is loaded:**
  ```bash
  docker compose exec whmcs php -v
  ```
  You should see "with the ionCube PHP Loader (enabled)"

### Database Connection Issues

- Use `db` as the hostname, not `localhost` or `127.0.0.1`
- Ensure the `db` service is running: `docker compose ps`
- Check database logs: `docker compose logs db`

### Permission Issues

If you encounter file permission issues:
```bash
# Fix ownership (adjust user:group as needed)
sudo chown -R $(id -u):$(id -g) whmcs/
```

---

## What's Included

### PHP Extensions
- pdo_mysql
- gd (with JPEG support)
- mbstring
- intl
- xml
- curl
- zip

### PHP Configuration
Development-friendly settings:
- `display_errors = On`
- `error_reporting = E_ALL`
- `memory_limit = 256M`
- `upload_max_filesize = 20M`
- `max_execution_time = 120`

---

## Contributing

Contributions welcome. Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

---

## License

This Docker setup is licensed under the MIT License. See [LICENSE](LICENSE) for details.

**Note:** WHMCS itself is proprietary software and requires a valid license from WHMCS Ltd.

---

## Links

- **GitHub:** https://github.com/Askedio/docker-whmcs
- **Docker Hub:** https://hub.docker.com/r/askedio/whmcs
- **WHMCS:** https://www.whmcs.com

---

## Support

For issues with this Docker setup, please open an issue on GitHub.

For WHMCS licensing and support, contact WHMCS directly.
