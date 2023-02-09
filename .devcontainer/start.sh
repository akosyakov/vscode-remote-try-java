#!/bin/sh
set -e

trap "trap - TERM && kill -- -$$" INT TERM EXIT

# TODO: Save off effective config for use in the container
# devcontainer read-configuration --include-merged-configuration --log-format json --workspace-folder "$(pwd)" 2>/dev/null > .devcontainer/server/configuration.json

devcontainer up --remove-existing-container --mount "type=bind,source=/ide,target=/ide" --mount "type=bind,source=/usr/bin/gp,target=/usr/bin/gp" --workspace-folder "$(pwd)"

sed -i 's/vscode-cdn.net/gitpod.io/g' /ide/out/vs/workbench/workbench.web.main.js
sed -i 's/*.vscode-cdn.net/gitpod.io/g' /ide/out/vs/server/node/server.main.js

socat TCP-LISTEN:24999,fork "TCP:$SUPERVISOR_ADDR" &

devcontainer exec --workspace-folder "$(pwd)" /.supervisor/supervisor debug-proxy &
socat TCP-LISTEN:25003,fork TCP:localhost:23003 &

devcontainer exec --workspace-folder "$(pwd)" /ide/codehelper --port 25000 --host 0.0.0.0 --without-connection-token --start-server --do-not-sync
