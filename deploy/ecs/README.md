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

## Continuous Deployment

The GitHub Actions workflow at `.github/workflows/deploy-ecs.yml` deploys every push to `master`.

Create these repository secrets before enabling the workflow:

- `ECS_SSH_PRIVATE_KEY`: the private key used for the ECS deployment account
- `ECS_KNOWN_HOSTS`: the verified SSH known-host entry for `idm.chimera3d.top`

The workflow runs `scripts/deploy-ecs.sh`. The script transfers the committed Git archive, rebuilds `docs/`, backs up the active Nginx site configuration, installs the Wiki route, validates Nginx, and reloads the service.
