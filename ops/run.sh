#!/usr/bin/env bash
set -e
S=/srv/desafiocircular; R=$GITHUB_WORKSPACE/infra
mkdir -p $S/www/acme $S/www/preview
cp $R/nginx/fase1-http.conf $R/nginx/fase2-preview.conf $S/infra/nginx/
cp $R/nginx/fase1-http.conf $S/infra/nginx/desafiocircular.conf
cat > $S/www/preview/index.html <<'H'
<!doctype html><html lang="es"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><meta name="robots" content="noindex"><title>Fundación Desafío Circular — Preview</title>
<style>body{margin:0;min-height:100vh;display:grid;place-items:center;font-family:system-ui,sans-serif;background:#0f1a14;color:#e8efe9}main{max-width:36rem;padding:2rem}h1{font-size:1.6rem;margin:0 0 .5rem}p{opacity:.8;line-height:1.5}</style></head>
<body><main><h1>Fundación Desafío Circular</h1><p>Visibilizamos la sostenibilidad que crea valor.</p><p>Entorno de preview en construcción.</p></main></body></html>
H
chmod -R o+rX $S/www; chmod o+x $S $S/infra $S/infra/nginx
sudo -n /usr/sbin/nginx -t 2>&1 | tail -1 && sudo -n /usr/bin/systemctl reload nginx && echo "NGINX RELOAD OK"
install -m 700 $R/root-3-ssl-preview.sh $S/root-3.sh
echo test > $S/www/acme/t.txt
curl -s -o /dev/null -w "HTTP acme local: %{http_code}\n" -H "Host: preview.desafiocircular.org" http://127.0.0.1/.well-known/acme-challenge/t.txt
rm -f $S/www/acme/t.txt
ls $S/root-2.sh 2>/dev/null && echo "root-2 AUN NO EJECUTADO" || echo "root-2 ejecutado"
systemctl is-active dc-directus 2>&1
