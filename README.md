# desafiocircular.org — Plataforma digital de Fundación Desafío Circular

Visibilizamos la sostenibilidad que crea valor.

Plataforma orientada a la contactabilidad: convertir visitas en leads, alianzas, patrocinios y contratos.

## Stack

| Capa | Tecnología |
|---|---|
| Sitio | Astro |
| Panel, contenido y mini CRM | Directus + PostgreSQL |
| Mailings | Listmonk (SMTP vía Google Workspace, cuenta dedicada) |
| Automatizaciones | n8n |
| Blog asistido | Claude API |
| Infraestructura | VPS Hostinger · Ubuntu 24.04 · Nginx · PM2 |
| DNS | GoDaddy (no modificar MX ni TXT de Google) |

## Flujo de ramas

```
develop → preview.desafiocircular.org (con clave) → aprobación → main → producción
```

Nada llega a producción sin pasar por preview.

## Reglas operativas

- Secretos solo en `.env` (fuera del repositorio). Ver `.env.example` cuando exista.
- El VPS es compartido con betosalinas.cl: no tocar su configuración ni sus procesos.
- Decisiones técnicas relevantes en `CHANGELOG.md` y `docs/`.

## Estructura (planificada)

```
/web        Sitio Astro
/directus   Configuración, esquema y extensiones de Directus
/infra      Nginx, PM2, scripts de despliegue y respaldo
/docs       Decisiones y documentación técnica
```
