# ECS Deployment

Deploy the repository to `/opt/idm-wiki` on the ECS host. Nginx serves the generated static files directly from `/opt/idm-wiki/docs/`.

Copy `deploy/nginx/idm.chimera3d.top.conf` to `/etc/nginx/conf.d/idm.chimera3d.top.conf`, then validate and reload Nginx.

```bash
cd /opt/idm-wiki
bash build.sh
nginx -t
systemctl reload nginx
```

The public Wiki URL is `https://idm.chimera3d.top/wiki/`.
