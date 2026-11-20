#!/usr/bin/env bash
# 1) Verifica bootstrap. 2) Node 22 (fnm, usuario) + Directus 11 en 127.0.0.1:8055.
set -u
S=/srv/desafiocircular; ENV=$S/.env
echo "=== VERIFICACION ==="
free -h | grep -i swap
sudo -n /usr/sbin/nginx -t 2>&1 | tail -1
ls -l $S/infra/nginx/ /etc/nginx/sites-enabled/desafiocircular.conf
[ -s $ENV ] && echo ".env OK ($(stat -c %a $ENV))" || echo ".env FALTA"
set -a; . $ENV; set +a
PGPASSWORD=$DB_PASSWORD psql -h 127.0.0.1 -U $DB_USER -d $DB_DATABASE -tAc "select 'DB OK '||current_user" 2>&1
echo "--- ufw ---"; cat $S/ufw.txt

echo "=== NODE 22 ==="
export FNM_DIR=$HOME/.fnm PATH=$HOME/.fnm:$PATH
if ! command -v fnm >/dev/null; then
  curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir $HOME/.fnm --skip-shell >/dev/null 2>&1
fi
eval "$(fnm env --shell bash)"
fnm install 22 >/dev/null 2>&1; fnm default 22; fnm use 22 >/dev/null
node -v; npm -v

echo "=== DIRECTUS ==="
D=$S/directus; mkdir -p $D $S/data/uploads; cd $D
[ -f package.json ] || npm init -y >/dev/null
npm i --no-audit --no-fund --loglevel=error directus@11 2>&1 | tail -3
npx directus --version 2>&1 | tail -1
if [ ! -f $D/.env ]; then
  ADMIN_PW=$(openssl rand -base64 18 | tr -d '/+=')
  install -m 600 /dev/null $D/.env
  cat > $D/.env <<E
HOST=127.0.0.1
PORT=8055
PUBLIC_URL=http://127.0.0.1:8055
DB_CLIENT=pg
DB_HOST=$DB_HOST
DB_PORT=$DB_PORT
DB_DATABASE=$DB_DATABASE
DB_USER=$DB_USER
DB_PASSWORD=$DB_PASSWORD
KEY=$(openssl rand -hex 32)
SECRET=$(openssl rand -hex 32)
ADMIN_EMAIL=admin@example.com
ADMIN_PASSWORD=$ADMIN_PW
STORAGE_LOCATIONS=local
STORAGE_LOCAL_ROOT=$S/data/uploads
TELEMETRY=false
E
fi
npx directus bootstrap 2>&1 | tail -5
echo "=== ARRANQUE DE PRUEBA ==="
( npx directus start > /tmp/directus.log 2>&1 & )
for i in $(seq 1 40); do sleep 2; curl -fs http://127.0.0.1:8055/server/health && break; done; echo
ps -u dcdeploy -o rss=,cmd= | grep -i directus | grep -v grep | head -2
pkill -u dcdeploy -f "directus" 2>/dev/null
tail -5 /tmp/directus.log
