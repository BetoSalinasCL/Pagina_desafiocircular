# Canal de operación del VPS

- Runner self-hosted de GitHub Actions en el VPS, usuario `dcdeploy` (sin sudo por defecto), servicio systemd `actions.runner.*`.
- Flujo: commit en rama `ops` modificando `ops/run.sh` → workflow `ops` lo ejecuta → salida en rama `ops-logs` (`latest.log`, `logs/<sha>.log`).
- Solo conexiones salientes desde el VPS; no se abren puertos ni se comparten llaves SSH.
- **Requisito:** repositorio privado. Un runner self-hosted en repo público permite ejecución de código de terceros y expone los logs.
- No imprimir secretos en los scripts: los logs quedan en el historial de git.
- Permisos adicionales de `dcdeploy` (sudoers) se otorgan puntualmente y se registran aquí.
