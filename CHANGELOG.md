# Changelog

## 2026-11-19
- Inicialización del repositorio: README, .gitignore, CHANGELOG.
- Ramas: `main` (producción) y `develop` (preview).
- Decisión: secretos y volcados de base de datos excluidos del repositorio por `.gitignore`.

## 2026-11-19 (2)
- Runner self-hosted en el VPS (usuario `dcdeploy`, sin sudo) y workflow `ops` como canal de operación remota. Ver `docs/ops.md`.
- Primer script: diagnóstico de solo lectura del VPS.

## 2026-11-19 (3)
- Diagnóstico del VPS documentado en `docs/diagnostico-vps.md`.
- `infra/bootstrap-root.sh`: swap, sitio Nginx propio, sudo mínimo para dcdeploy, base PostgreSQL propia.

## 2026-11-19 (4)
- Directus 11 instalado y probado (health ok). Servicio systemd `dc-directus`.
- Reinicio del VPS programado 03:00 Chile por kernel/libc pendientes.

## 2026-11-19 (5)
- DNS: zona administrada en Socio Virtual (ns1/ns2.sociovirtual.com), no en GoDaddy. Registro A `preview` → 177.7.56.127 creado.
- Hallazgo: SPF autoriza solo Zoho (`-all`) mientras el MX es Google; sin DKIM ni DMARC visibles. Pendiente de decisión.
- Nginx preview: fase 1 HTTP (ACME) y fase 2 HTTPS con clave + noindex.
