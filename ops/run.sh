#!/usr/bin/env bash
ls -la /srv/desafiocircular/www/preview/
grep -o "<title>[^<]*" /srv/desafiocircular/www/preview/index.html; grep -c "Circular Awards en cifras" /srv/desafiocircular/www/preview/index.html
curl -s -o /dev/null -w "preview: %{http_code}\n" https://preview.desafiocircular.org/
