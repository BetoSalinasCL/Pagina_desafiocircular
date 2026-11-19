#!/usr/bin/env bash
# Deja el bootstrap root en el VPS y verifica estado de ufw/puertos accesibles.
install -m 700 "$GITHUB_WORKSPACE/infra/bootstrap-root.sh" /srv/desafiocircular/bootstrap-root.sh && ls -l /srv/desafiocircular/
echo "=== ufw (sin sudo, desde reglas legibles) ==="; ls -l /etc/ufw/ 2>&1 | head
