# 09: Container Management (RHEL 9)

This section covers the deployment and management of containerized applications using Podman. The focus is on rootless containers and systemd integration.

## 🎯 Exam Objectives (RHEL 9)
* **Image Management:** Pull, list, and delete images from a registry.
* **Running Containers:** Start, stop, and inspect containers.
* **Rootless Containers:** Run containers as a non-root user for better security.
* **Container Persistence:** Attach persistent storage using host volumes.
* **Systemd Integration:** Configure containers to start automatically as a systemd service.
* **Environmental Variables:** Pass variables to containers during runtime.

---

## 🛠️ Key Command Reference

### 1. Basic Podman Operations
| Task | Command |
| :--- | :--- |
| Search Image | `podman search <image_name>` |
| Pull Image | `podman pull <registry>/<image>` |
| List Images | `podman images` |
| Run Interactive | `podman run -it --name test_container ubi9 /bin/bash` |

### 2. Running with Persistence & Ports
```bash
podman run -d \
  --name web_server \
  -p 8080:80 \
  -v /home/ashish/html:/var/www/html:Z \
  -e MYSQL_ROOT_PASSWORD=redhat \
  nginx

(Note: The :Z flag automatically fixes SELinux contexts for the volume!)

## Systemd Integration (Rootless)
Generate the service file:
podman generate systemd --name web_server --files --new

Move to user systemd directory:
mkdir -p ~/.config/systemd/user/
mv container-web_server.service ~/.config/systemd/user/

Enable and start:
systemctl --user daemon-reload
systemctl --user enable --now container-web_server.service

Crucial: Enable lingering so it starts without logging in:
loginctl enable-linger <username>

### **Strategy for your Restructure:**
When moving files, look for:
* Old `Dockerfile` or `Containerfile` examples.
* Scripts that use `docker` commands (most can just be swapped to `podman`).
* Any notes on `skopeo` or `buildah`.
