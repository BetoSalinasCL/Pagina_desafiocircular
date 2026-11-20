#!/usr/bin/env bash
C=/srv/desafiocircular/infra/nginx/desafiocircular.conf
ls -l $C /srv/desafiocircular/infra/nginx/; head -3 $C; grep -c 443 $C
sudo -n /usr/sbin/nginx -t 2>&1 | tail -2
curl -sv --resolve preview.desafiocircular.org:443:127.0.0.1 https://preview.desafiocircular.org/ -o /dev/null 2>&1 | grep -E "^< HTTP|error|SSL" | head -5
curl -s -o /dev/null -w "publico https: %{http_code} err=%{errormsg}\n" https://preview.desafiocircular.org/
