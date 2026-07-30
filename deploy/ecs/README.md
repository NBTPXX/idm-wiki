# ECS Deployment

Deploy the repository to `/opt/idm-wiki` on the ECS host. Docker Compose builds the static Wiki image and binds it to `127.0.0.1:8088`.

Copy `deploy/nginx/idm.chimera3d.top.conf` to `/etc/nginx/conf.d/idm.chimera3d.top.conf`, then validate and reload Nginx.

```bash
cd /opt/idm-wiki
docker compose up -d --build
nginx -t
systemctl reload nginx
```

The public Wiki URL is `https://idm.chimera3d.top/wiki/`.
