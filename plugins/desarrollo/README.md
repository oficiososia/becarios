# Departamento de desarrollo

El plugin `desarrollo` lleva cada tarea de Notion del plan al PR. Tiene nueve becarios:

| Becario | Qué hace |
| --- | --- |
| `cto` | Historia, plan técnico, reparto y revisión del PR. Toda tarea de desarrollo entra por él. |
| `diseno` | Diseño UX/UI: recorridos, pantallas, estados, textos y accesibilidad antes de programar. |
| `frontend` | Interfaces, responsive e integración con la API. |
| `backend-datos` | Modelos, migraciones (solo como ficheros), consultas y permisos (RLS). |
| `backend-servicios` | Lógica de negocio, endpoints, funciones e integraciones. |
| `ia-automatizacion` | Chatbots e integraciones con Claude, automatizaciones, WhatsApp y webhooks. |
| `qa-funcional` | Criterios de aceptación y recorridos de usuario en la preview, en móvil y escritorio. |
| `qa-tecnico` | Build, lint y tipos; pruebas de integración, API y regresión; consola de la preview. |
| `delivery` | PR, preview de Vercel (la DEMO), versión y registro de entrega en Notion. |

```
plugins/desarrollo/
├── .claude-plugin/plugin.json
├── agents/              # los nueve becarios
├── skills/becarios/     # /desarrollo:becarios, el coordinador
└── reference/           # proceso.md (fases y reglas) y notion.md (bases y ficha del becario)
```

## Cómo trabaja

Preparación (`cto`, y `diseno` si hay interfaz) → Desarrollo y unitarias (`frontend`, `backend-datos`, `backend-servicios`, `ia-automatizacion`) → Despliegue DEMO (`delivery`: PR en borrador y preview) → QA DEMO (`qa-funcional` ∥ `qa-tecnico`) → PR y revisión (revisión del `cto` y PR listo) → y, solo si una persona lo confirma después de fusionar, Despliegue PROD → QA PROD → Cerrada.

- En tu ordenador: `/desarrollo:becarios <URL de la tarea>` (o sin nada, para coger la siguiente del CTO). Pregunta antes de abrir el PR y antes de cualquier cosa en producción.
- En la nube: la lanza el panel y la ejecuta el skill `encargo` de la oficina, que sigue este mismo flujo pero **se para en el PR**.

Los detalles están en [`reference/proceso.md`](reference/proceso.md) y [`reference/notion.md`](reference/notion.md).
