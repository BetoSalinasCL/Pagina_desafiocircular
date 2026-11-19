#!/usr/bin/env bash
# Bootstrap ÚNICO como root para desafiocircular.org. Idempotente. No toca betosalinas.cl.
set -euo pipefail
[ "$(id -u)" = 0 ] || { echo "Ejecutar como root"; exit 1; }

echo "[1/4] Swap 2G (VPS sin swap, 3.8G RAM)"
if ! swapon --show | grep -q /swapfile; then
  [ -f /swapfile ] || fallocate -l 2G /swapfile
  chmod 600 /swapfile; mkswap /swapfile >/dev/null; swapon /swapfile
  grep -q '^/swapfile' /etc/fstab || echo '/swapfile none swap sw 0 0' >> /etc/fstab
  sysctl -qw vm.swappiness=10; echo 'vm.swappiness=10' > /etc/sysctl.d/99-swappiness.conf
fi

echo "[2/4] Nginx: sitio propio editable por dcdeploy"
mkdir -p /srv/desafiocircular/infra/nginx
touch /srv/desafiocircular/infra/nginx/desafiocircular.conf
chown -R dcdeploy:dcdeploy /srv/desafiocircular
ln -sfn /srv/desafiocircular/infra/nginx/desafiocircular.conf /etc/nginx/sites-enabled/desafiocircular.conf

echo "[3/4] sudo mínimo para dcdeploy (validar y recargar nginx)"
cat > /etc/sudoers.d/dcdeploy <<'S'
dcdeploy ALL=(root) NOPASSWD: /usr/sbin/nginx -t, /usr/bin/systemctl reload nginx
S
chmod 440 /etc/sudoers.d/dcdeploy
visudo -cf /etc/sudoers.d/dcdeploy >/dev/null

echo "[4/4] PostgreSQL: base y rol propios (solo localhost)"
ENV=/srv/desafiocircular/.env
if ! sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='dc_directus'" | grep -q 1; then
  PW=$(openssl rand -hex 24)
  sudo -u postgres psql -q -c "CREATE ROLE dc_directus LOGIN PASSWORD '$PW';"
  sudo -u postgres psql -q -c "CREATE DATABASE dc_directus OWNER dc_directus;"
  install -o dcdeploy -g dcdeploy -m 600 /dev/null "$ENV"
  printf 'DB_HOST=127.0.0.1\nDB_PORT=5432\nDB_DATABASE=dc_directus\nDB_USER=dc_directus\nDB_PASSWORD=%s\n' "$PW" > "$ENV"
fi

nginx -t 2>&1 | tail -1
echo "BOOTSTRAP-OK"
rm -f "$0"
