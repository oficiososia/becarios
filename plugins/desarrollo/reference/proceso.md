# Proceso del departamento de desarrollo

Cómo trabajan los becarios de desarrollo de OficiosOsIA, en tu ordenador (`/desarrollo:becarios`) y en la nube (skill `encargo` de la oficina). En la nube el proceso **se para en el PR**.

## Fases (columna «Fase» de Notion)

| Fase | Quién | Qué tiene que quedar hecho para pasar a la siguiente |
| --- | --- | --- |
| Preparación | `cto` (y `diseno` si hay interfaz) | Plan técnico con becarios, orden y qué se prueba. Si hay interfaz, especificación en `docs/diseno/`. Rama creada. |
| Desarrollo y unitarias | `frontend`, `backend-datos`, `backend-servicios`, `ia-automatizacion` | Código con sus pruebas unitarias. Migraciones solo como ficheros. Build, lint, tipos y pruebas en verde. |
| Despliegue DEMO | `delivery` | PR en borrador y preview de Vercel en `READY`. `Versión` apuntada. |
| QA DEMO | `qa-funcional` ∥ `qa-tecnico` | Todos los criterios comprobados en la preview, en móvil y escritorio. API y regresión en verde. Defectos arreglados o convertidos en subtareas. |
| PR y revisión | `cto` revisa; `delivery` cierra | Veredicto APROBADO del CTO, PR listo para revisar, `PR` y registro de entrega en Notion. `Estado = En espera` hasta que una persona fusiona. |
| Despliegue PROD | `delivery` | Solo en local, después de fusionar y con el «sí» explícito de una persona. Despliegue de producción en `READY`. |
| QA PROD | `qa-funcional` | Comprobación en producción, solo lectura y sin datos reales de clientes. |
| Cerrada | — | `Estado = Hecha`. |

## Rama, commits y PR

- Rama: `claude/desarrollo-<slug>` desde la rama por defecto actualizada. `<slug>`: el título en minúsculas, sin tildes, con guiones y como mucho 40 caracteres.
- Commits pequeños, en español y con prefijo del becario o del área: `datos: …`, `servicios: …`, `frontend: …`, `diseño: …`, `ia: …`, `qa: …`.
- Antes de cada commit, `git diff --cached`: nada de secretos ni datos personales.
- PR contra la rama por defecto, título `[Desarrollo] <título de la tarea>`. Cuerpo: resumen en tres líneas, enlace a la tarea de Notion, qué ha hecho cada becario, cómo se ha probado (comandos, resultados, URL de la DEMO), riesgos y pendientes, y una lista de casillas para revisar.
- Un PR por tarea. El PR lo fusiona siempre una persona.

## Reglas que no se rompen

- Las migraciones van como ficheros en `supabase/migrations/`; nunca se aplican en producción desde una sesión de becarios.
- Las claves privadas solo en variables de entorno del servidor. En el navegador, solo las públicas.
- Los permisos se comprueban en el servidor (RLS y endpoints), no solo en la interfaz.
- Nada se desactiva para que pase el build: ni pruebas ni reglas del lint.
- Defectos que no se arreglan en la tarea: subtareas en Notion (`Tarea padre` = la tarea, `Estado = Inbox`, sin `Becario`).
