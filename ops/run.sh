#!/usr/bin/env bash
mkdir -p /srv/desafiocircular/directus/extensions
install -m 700 "$GITHUB_WORKSPACE/infra/root-2-directus-servicio-y-reinicio.sh" /srv/desafiocircular/root-2.sh && ls -l /srv/desafiocircular/root-2.sh
ls -l /srv/desafiocircular/directus/node_modules/directus/cli.js /home/dcdeploy/.fnm/aliases/default/bin/node
