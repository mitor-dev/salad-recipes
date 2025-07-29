FROM ubuntu:24.04

SHELL ["/bin/bash", "-c"]

# --- Base dependencies ---
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    git \
    curl \
    wget \
    python3-pip \
    python3-venv \
    zip \
    unzip \
    htop \
    nvtop \
    jq \
    ffmpeg \
    libgl1 \
    software-properties-common && \
    rm -rf /var/lib/apt/lists/*

# --- Python virtual environment ---
RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --upgrade pip && \
    /opt/venv/bin/pip install jupyterlab

ENV PATH="/opt/venv/bin:$PATH"
RUN echo "source /opt/venv/bin/activate" >> "/root/.bashrc"

# --- VS Code CLI setup ---
RUN curl -Lk 'https://code.visualstudio.com/sha/download?build=stable&os=cli-alpine-x64' -o vscode_cli.tar.gz && \
    tar -xf vscode_cli.tar.gz && \
    mv code /usr/local/bin/code && \
    rm vscode_cli.tar.gz

# --- JupyterLab config ---
ENV JUPYTERLAB_DIR="/workspace/jupyterlab"
ENV JUPYTERLAB_PORT=8888
RUN mkdir -p /workspace/jupyterlab
RUN jupyter lab --generate-config && \
    echo "c.ServerApp.ip = '::'" >> /root/.jupyter/jupyter_server_config.py
RUN jupyter lab build

# --- Clone and install ComfyUI ---
RUN git clone https://github.com/comfyanonymous/ComfyUI.git /root/ComfyUI
RUN pip install -r /root/ComfyUI/requirements.txt

# --- Launch script ---
COPY launch.sh /workspace/launch.sh
RUN chmod +x /workspace/launch.sh

# --- Set working directory ---
WORKDIR /workspace

# --- Expose ComfyUI port ---
EXPOSE 8188

# --- Launch ComfyUI automatically ---
CMD ["/workspace/launch.sh"]
