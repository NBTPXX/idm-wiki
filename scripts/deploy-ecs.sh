#!/usr/bin/env bash
set -euo pipefail

: "${ECS_HOST:?ECS_HOST is required}"
: "${ECS_SSH_KEY_PATH:?ECS_SSH_KEY_PATH is required}"

ECS_USER="${ECS_USER:-root}"
ECS_DEPLOY_DIR="${ECS_DEPLOY_DIR:-/opt/idm-wiki}"
ECS_NGINX_CONFIG="${ECS_NGINX_CONFIG:-/etc/nginx/conf.d/idm.chimera3d.top.conf}"
SSH_TARGET="${ECS_USER}@${ECS_HOST}"
SSH_OPTIONS=(
  -i "$ECS_SSH_KEY_PATH"
  -o BatchMode=yes
  -o ConnectTimeout=15
)

ssh "${SSH_OPTIONS[@]}" "$SSH_TARGET" "mkdir -p '$ECS_DEPLOY_DIR'"
git archive --format=tar HEAD | ssh "${SSH_OPTIONS[@]}" "$SSH_TARGET" "tar -x -C '$ECS_DEPLOY_DIR'"
ssh "${SSH_OPTIONS[@]}" "$SSH_TARGET" "cd '$ECS_DEPLOY_DIR' && bash build.sh"
ssh "${SSH_OPTIONS[@]}" "$SSH_TARGET" "cp '$ECS_NGINX_CONFIG' '${ECS_NGINX_CONFIG}.before-wiki.$(date +%Y%m%d%H%M%S)'"
scp "${SSH_OPTIONS[@]}" deploy/nginx/idm.chimera3d.top.conf "$SSH_TARGET:$ECS_NGINX_CONFIG"
ssh "${SSH_OPTIONS[@]}" "$SSH_TARGET" "nginx -t && systemctl reload nginx"
ssh "${SSH_OPTIONS[@]}" "$SSH_TARGET" "curl -fsS -H 'Host: idm.chimera3d.top' http://127.0.0.1/wiki/ >/dev/null"
