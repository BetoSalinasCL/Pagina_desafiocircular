# Diagnóstico VPS — 2026-11-19

- Ubuntu 24.04.4 · 1 vCPU · 3.8 GiB RAM (≈2.5 GiB disponible) · **sin swap** · disco 11/48 GB.
- Reinicio pendiente (kernel 6.8.0-149, libc6). 60 actualizaciones pendientes.
- Ya instalado: Nginx 1.24, Docker 29, PostgreSQL 16 nativo (solo localhost), Node 20, PM2 (root), certbot, ufw activo, fail2ban.
- SSH: solo llave, root sin contraseña. OK.
- Sitios en Nginx: betosalinas.cl, preview.betosalinas.cl, mk.desafiocircular.org (Streamlit :8501/:8502), mkd, mkd_v2 (nip.io).
- **Streamlit escucha en 0.0.0.0:8501/8502** como root (≈790 MB RAM). Revisar si ufw bloquea esos puertos.
- DNS: desafiocircular.org y www → 170.249.239.131 (hosting actual, fuera del VPS). preview.desafiocircular.org sin registro.

## Decisiones
- Reutilizar PostgreSQL nativo (base y rol propios `dc_directus`) en vez de otro Postgres en Docker: ahorra RAM.
- Swap de 2 GB para absorber picos de memoria.
- Sitio Nginx propio en `/srv/desafiocircular/infra/nginx/desafiocircular.conf` (enlazado en sites-enabled); `dcdeploy` solo puede `nginx -t` y `reload`.
- Secretos en `/srv/desafiocircular/.env` (600, fuera del repo).
