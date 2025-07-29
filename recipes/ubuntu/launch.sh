#!/bin/bash

# Optional: VS Code tunnel if credentials are provided
if [ -n "$TUNNEL_ID" ] && [ -n "$ACCESS_TOKEN" ]; then
  code tunnel --accept-server-license-terms --name "$SALAD_CONTAINER_GROUP_ID" --tunnel-id "$TUNNEL_ID" --host-token "$ACCESS_TOKEN" &
fi

# ✅ Launch ComfyUI in background on port 8188
cd /root/ComfyUI
python3 main.py --listen --port 8188 &

# ✅ Launch JupyterLab on port 8888 with no auth
jupyter lab --port=${JUPYTERLAB_PORT:-8888} --no-browser --allow-root \
  --NotebookApp.token='' --NotebookApp.password='' &

# ✅ Pass control to Docker CMD (if any)
exec "$@"
