#!/usr/bin/env bash
N=/srv/desafiocircular/infra/nginx
cp $GITHUB_WORKSPACE/infra/nginx/fase2-preview.conf $N/fase2-preview.conf
cp $N/fase2-preview.conf $N/desafiocircular.conf
ls -la $N | grep htpasswd
if sudo -n /usr/sbin/nginx -t 2>&1 | tail -1 | grep -q successful; then sudo -n /usr/bin/systemctl reload nginx && echo RELOAD-OK
else sudo -n /usr/sbin/nginx -t; cp $N/fase1-http.conf $N/desafiocircular.conf; echo "REVERTIDO A FASE1"; fi
sleep 1
curl -s -o /dev/null -w "https sin clave: %{http_code}\n" https://preview.desafiocircular.org/
curl -s -o /dev/null -w "http: %{http_code} -> %{redirect_url}\n" http://preview.desafiocircular.org/
curl -s -o /dev/null -w "betosalinas.cl: %{http_code}\n" https://betosalinas.cl/
curl -sI https://preview.desafiocircular.org/ | grep -iE "x-robots|strict|www-auth"
