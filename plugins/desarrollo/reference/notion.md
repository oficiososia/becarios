# Notion para los becarios

Usa cualquier conexión de Notion disponible: el conector de Claude o el servidor MCP de Notion. Si no hay herramientas de Notion o piden autorización, para y di que hay que conectar Notion (`/mcp`).

## Bases

| Base | Fuente de datos | Para qué |
| --- | --- | --- |
| Tareas (Oficios OS) | `collection://2ad3221d-8eb7-8065-904d-000b57a0fe2a` | Las tareas de todos los proyectos. |
| Becarios | `collection://7d90c32f-ede0-42ca-8732-2c80134f885b` | La ficha de cada becario (panel OficiosOsIA). |
| Proyectos | `collection://c295eb77-c4a5-4c32-8027-f06f4412bf7d` | Una fila por proyecto: `Proyecto en tareas`, `Repositorio` y `Becarios` (el equipo, de todos los departamentos). |
| Registro de entrega | `collection://369023a7-d413-411d-adbf-5d5a91d5267c` | Una fila por entrega, relacionada con su tarea (`Registro de entrega` en Tareas). |

### Columnas de Tareas

- `Título de la tarea` (título) y `Proyecto relacionado` (texto, igual que `Proyecto en tareas` de Proyectos).
- `Estado`: `Inbox`, `Por hacer`, `En progreso`, `En espera` o `Hecha`.
- `Fase`: `Preparación`, `Desarrollo y unitarias`, `Auditoría`, `Producción`, `Intervención`, `Despliegue DEMO`, `QA DEMO`, `PR y revisión`, `Despliegue PROD`, `QA PROD` o `Cerrada`. Desarrollo usa todas menos `Auditoría` (ciberseguridad), `Producción` (marketing) e `Intervención` (soporte IT).
- `Becario` (selección múltiple): quién tiene la tarea **ahora**; varios si trabajan a la vez.
- `Bloqueo` (texto): el motivo cuando `Estado = En espera`.
- `PR` (URL), `Versión` (SHA corto del commit), `Prioridad`, `Tipo de tarea`, `Estimación (horas)`, `Área` y `Notas`.
- `Tarea padre` y `Subtareas` (relación de la base consigo misma) y `Registro de entrega` (relación).

## Tareas padre y subtareas

Una tarea con `Tarea padre` es una **subtarea**: el panel no la enseña (ni en la oficina, ni en el kanban, ni en «Asignar tareas») y las vistas de trabajo de Notion tampoco; «Todas las tareas» sí. Los defectos y los trabajos de seguimiento que salen de una tarea se crean como subtareas: `Tarea padre` = la tarea, `Estado = Inbox`, el mismo `Proyecto relacionado` y `Becario` vacío (la asigna una persona desde el panel). Cuerpo: pasos para reproducirlo, esperado, obtenido, evidencia y gravedad.

## Ficha del becario (panel OficiosOsIA)

Antes de empezar cualquier tarea, busca tu fila en la base «Becarios» (data source `7d90c32f-ede0-42ca-8732-2c80134f885b`): la que tiene en la columna `Id` tu nombre de agente. Los ids, por departamento:

- Desarrollo: `cto`, `diseno`, `frontend`, `backend-datos`, `backend-servicios`, `ia-automatizacion`, `qa-funcional`, `qa-tecnico`, `delivery`.
- Ciberseguridad: `sec-lead`, `sec-aplicaciones`, `sec-nube`, `sec-pentest`, `sec-dependencias`, `sec-cumplimiento`.
- Marketing: `mk-lead`, `mk-seo`, `mk-contenidos`, `mk-rrss`, `mk-local`, `mk-analitica`.
- Soporte IT: `it-lead`, `it-soporte`, `it-infraestructura`, `it-sistemas`, `it-comunicaciones`, `it-conectividad`.

Qué hacer con tu fila:

- Si `Pausado` está marcado, no trabajes: termina con resultado BLOQUEADO y el motivo «Becario pausado en el panel».
- Si hay `Instrucciones`, síguelas en toda la tarea, salvo que contradigan `proceso.md` o las reglas del repositorio (`CLAUDE.md`); en ese caso mandan esas y lo dices en tu informe.
- `Modelo` y `Esfuerzo` los aplica quien te lanza (el coordinador): si tienen valor, te lanza con ese `model` y ese `effort`; si están vacíos, con lo que diga la cabecera de tu fichero.
- Si no encuentras la base o tu fila, sigue como siempre.

Las fichas se editan desde la pestaña «Becarios» del panel. Lo que se cambie allí vale desde la siguiente tarea.
