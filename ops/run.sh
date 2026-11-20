#!/usr/bin/env bash
echo "directus: $(systemctl is-active dc-directus)  enabled: $(systemctl is-enabled dc-directus)"
curl -fs http://127.0.0.1:8055/server/health; echo
systemctl list-timers dc-reboot.timer --no-pager --no-legend 2>&1 | head -1
curl -s -o /dev/null -w "https sin clave: %{http_code}\n" https://preview.desafiocircular.org/
curl -s -o /dev/null -w "http -> %{http_code} %{redirect_url}\n" http://preview.desafiocircular.org/
echo | openssl s_client -connect preview.desafiocircular.org:443 -servername preview.desafiocircular.org 2>/dev/null | openssl x509 -noout -issuer -enddate
curl -sI https://preview.desafiocircular.org/ | grep -iE "x-robots|strict"
free -h | sed -n 2,3p
