#!/usr/bin/env bash
# Root, una vez: servicio systemd para Directus (usuario dcdeploy) + reinicio programado 03:00 Chile.
set -euo pipefail
[ "$(id -u)" = 0 ] || { echo "Ejecutar como root"; exit 1; }
NODE=/home/dcdeploy/.fnm/aliases/default/bin/node
CLI=/srv/desafiocircular/directus/node_modules/directus/cli.js
[ -x "$NODE" ] && [ -f "$CLI" ] || { echo "Falta node o directus: $NODE $CLI"; exit 1; }

cat > /etc/systemd/system/dc-directus.service <<S
[Unit]
Description=Directus - Fundacion Desafio Circular
After=network.target postgresql.service
[Service]
User=dcdeploy
WorkingDirectory=/srv/desafiocircular/directus
ExecStart=$NODE $CLI start
Restart=always
RestartSec=5
MemoryMax=700M
NoNewPrivileges=true
[Install]
WantedBy=multi-user.target
S
systemctl daemon-reload
systemctl enable --now dc-directus
cat > /etc/sudoers.d/dcdeploy <<'S'
dcdeploy ALL=(root) NOPASSWD: /usr/sbin/nginx -t, /usr/bin/systemctl reload nginx, /usr/bin/systemctl restart dc-directus, /usr/bin/systemctl status dc-directus
S
chmod 440 /etc/sudoers.d/dcdeploy; visudo -cf /etc/sudoers.d/dcdeploy >/dev/null

systemctl stop dc-reboot.timer 2>/dev/null || true
systemd-run --unit=dc-reboot --on-calendar="2026-11-20 06:00:00 UTC" /usr/bin/systemctl reboot
systemctl list-timers dc-reboot.timer --no-pager | head -2
sleep 3; curl -fs http://127.0.0.1:8055/server/health && echo
echo "ROOT2-OK"
rm -f "$0"
