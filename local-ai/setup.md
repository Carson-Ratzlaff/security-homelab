# Local AI setup (Ollama + Open WebUI)

Runs on a separate Debian workstation with an NVIDIA GTX 1060 6 GB. The
tuned model is a Qwen3 4B variant sized to fit that card.

## 1. Install Docker (Debian)

```bash
sudo apt update
sudo apt install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: trixie
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

## 2. NVIDIA container toolkit

Requires the NVIDIA driver to already be installed on the host.

```bash
sudo apt-get update && sudo apt-get install -y --no-install-recommends ca-certificates curl gnupg2

curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

sudo apt-get update
export NVIDIA_CONTAINER_TOOLKIT_VERSION=1.20.1-1   # pinned when I installed; check for newer
sudo apt-get install -y \
    nvidia-container-toolkit=${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
    nvidia-container-toolkit-base=${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
    libnvidia-container-tools=${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
    libnvidia-container1=${NVIDIA_CONTAINER_TOOLKIT_VERSION}

# Register the runtime with Docker (if not already configured)
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
```

## 3. Start the stack

```bash
cp .env.example .env
# edit .env and set WEBUI_SECRET_KEY (generate with: openssl rand -hex 32)
sudo docker compose up -d
```

Open WebUI is on port 3000. Add the Ollama connection in its settings
(`http://host.docker.internal:11434`).

## 4. Pull and tune the model

```bash
sudo docker exec ollama ollama pull qwen3:4b
sudo docker cp Modelfile ollama:/tmp/Modelfile
sudo docker exec ollama ollama create qwen3-tuned -f /tmp/Modelfile
sudo docker exec ollama ollama show qwen3-tuned --parameters
```

## Security notes

- Ollama's API (port 11434) has no authentication. Keep this host on a trusted segment, or bind the port to localhost.
- Open WebUI should sit behind a TLS reverse proxy before any remote access.
- `WEBUI_SECRET_KEY` lives in `.env`, which is gitignored.
