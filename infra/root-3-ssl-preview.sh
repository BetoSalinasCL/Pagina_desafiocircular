#!/usr/bin/env bash
# Root, una vez: certificado SSL de preview + clave de acceso. Imprime la clave SOLO en esta consola.
set -euo pipefail
[ "$(id -u)" = 0 ] || { echo "Ejecutar como root"; exit 1; }
N=/srv/desafiocircular/infra/nginx
certbot certonly --webroot -w /srv/desafiocircular/www/acme -d preview.desafiocircular.org \
  --non-interactive --agree-tos --register-unsafely-without-email --keep-until-expiring \
  --deploy-hook "systemctl reload nginx"
PW=$(openssl rand -base64 12 | tr -d '/+=')
printf 'desafio:%s\n' "$(openssl passwd -apr1 "$PW")" > $N/.htpasswd
chown root:www-data $N/.htpasswd; chmod 640 $N/.htpasswd
cp $N/fase2-preview.conf $N/desafiocircular.conf && chown dcdeploy: $N/desafiocircular.conf
nginx -t && systemctl reload nginx
echo; echo "================================================"
echo " Preview: https://preview.desafiocircular.org"
echo " Usuario: desafio"
echo " Clave:   $PW"
echo " (guárdala en tu gestor de claves; no se vuelve a mostrar)"
echo "================================================"
echo "ROOT3-OK"; rm -f "$0"
