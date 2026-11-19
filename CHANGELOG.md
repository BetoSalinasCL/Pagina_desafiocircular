# Changelog

## 2026-11-19
- Inicialización del repositorio: README, .gitignore, CHANGELOG.
- Ramas: `main` (producción) y `develop` (preview).
- Decisión: secretos y volcados de base de datos excluidos del repositorio por `.gitignore`.

## 2026-11-19 (2)
- Runner self-hosted en el VPS (usuario `dcdeploy`, sin sudo) y workflow `ops` como canal de operación remota. Ver `docs/ops.md`.
- Primer script: diagnóstico de solo lectura del VPS.
