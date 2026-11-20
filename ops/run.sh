#!/usr/bin/env bash
A=/srv/desafiocircular/www/acme/.well-known/acme-challenge; mkdir -p $A; chmod -R o+rX /srv/desafiocircular/www
echo ok > $A/t.txt
curl -s -o /dev/null -w "local: %{http_code}\n" -H "Host: preview.desafiocircular.org" http://127.0.0.1/.well-known/acme-challenge/t.txt
curl -s -o /dev/null -w "publico: %{http_code}\n" http://preview.desafiocircular.org/.well-known/acme-challenge/t.txt
rm -f $A/t.txt
