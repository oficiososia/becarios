---
name: qa
description: "Llama al departamento de QA y testers en tu Claude Code para una tarea de Notion: la Jefatura de QA fija modo y alcance, Reconocimiento saca el mapa de la app, los testers intentan romperla y el verificador demuestra cada fallo con una prueba automática, los usuarios simulados del negocio usan la app en la preview y el analista escribe el informe de predicción. Deja pruebas, informe y veredicto en una rama y pregunta antes de abrir el PR."
argument-hint: "<URL de la tarea de Notion> [rápido|estándar|a fondo] [solo-rompedores|solo-usuarios]"
disable-model-invocation: true
---

# Departamento de QA y testers

Encargo: $ARGUMENTS. Lo primero tiene que ser la URL (o el id) de una tarea de Notion de la base Tareas. Si está vacío, pregunta qué tarea y para. Después, opcionales:

- modo: `rápido` (solo lo que cambia el PR), `estándar` (por defecto) o `a fondo`;
- escuadra: `solo-rompedores` (sin usuarios simulados) o `solo-usuarios` (sin testers, salvo `qa-reconocimiento` y `qa-verificador`).

Es el mismo flujo de QA que hace la oficina en la nube (`plugins/oficina/skills/encargo/SKILL.md`, departamento `qa`), pero en tu ordenador y contigo delante: **preguntas antes de seguir con el plan y antes de abrir el PR**. Tú coordinas: el plan, las pruebas, las simulaciones y el informe los hacen los agentes.

- `qa-lead`: modo, alcance, modelo de la app, reparto, cobertura y veredicto. Nunca prueba la app.
- Testers: `qa-reconocimiento`, `qa-rompedor`, `qa-api` y `qa-verificador`.
- Usuarios simulados: `qa-poblacion`, `qa-enjambre` y `qa-informe`.

En el plugin, los agentes se llaman `qa:<id>` (por ejemplo, `qa:qa-lead`).

## Lo que cuesta

Cada usuario simulado en cada ronda es un subagente que gasta de tu suscripción, igual que una sesión de Claude Code. El mando es **personas × rondas**:

| Modo | Personas × rondas | Sesiones de usuarios |
| --- | --- | --- |
| rápido | 3 × 1 | 3 |
| estándar | 6 × 2 | 12 |
| a fondo | hasta 12 × 4 | hasta 48 |

Nunca más de 12 personas ni de 4 rondas. Si vas justo de uso, `rápido` o `solo-rompedores`.

## Límites

- Solo el build local, la preview del PR y la DEMO de este proyecto, con usuarios y datos de prueba. Producción, solo si la tarea autoriza por escrito una URL concreta.
- Nada de pruebas de carga ni ráfagas de peticiones. Pagos, solo en modo de prueba.
- Nunca datos de personas reales: los perfiles simulados son inventados y los correos, `qa+<id>@example.com`.
- No se cambia código de producto: los fallos se demuestran con pruebas y se arreglan en desarrollo.
- Lo que parezca una vulnerabilidad de seguridad no se investiga aquí: va como subtarea para Ciberseguridad.
- Si el repositorio es **público** (`gh repo view --json visibility -q .visibility`), los pasos de un fallo de permisos van solo en la subtarea de Notion.
- Nunca se piden, imprimen ni escriben contraseñas, tokens o claves. No fusiones y no despliegues.

## Carpetas

Todo lo de una ejecución va en `docs/qa/<AAAA-MM-DD>-<slug>/` (`<run>`):

| Fichero | Quién | Qué |
| --- | --- | --- |
| `mapa.md` | `qa-reconocimiento` | Rutas, formularios, endpoints, roles y estados |
| `modelo.md` | `qa-reconocimiento` y `qa-lead` | El modelo de la app compartido; el resto solo añade enmiendas al final |
| `cobertura.md` | `qa-lead` | Área · qué se prueba · quién · resultado · pendiente |
| `hallazgos.md` | testers y usuarios; estado del verificador | Fallos candidatos y si se confirman |
| `poblacion.json` y `.md` | `qa-poblacion` | Mapa del negocio, perfiles y guion |
| `diarios/<id>.md` | `qa-enjambre` | Un diario por persona, una sección por ronda |
| `capturas/` | todos | Evidencias |
| `informe.md` | `qa-informe` | Informe de predicción y veredicto |

Las pruebas confirmadas van en `tests/qa/` (y `tests/qa/api/`), marcadas como fallo esperado hasta que se arreglen.

## Notion

Usa cualquier conexión de Notion (el conector de Claude o el servidor MCP). Si no hay, para y di que hay que conectar Notion (`/mcp`).

| Base | Fuente de datos |
| --- | --- |
| Tareas (Oficios OS) | `collection://2ad3221d-8eb7-8065-904d-000b57a0fe2a` |
| Becarios | `collection://7d90c32f-ede0-42ca-8732-2c80134f885b` |
| Proyectos | `collection://c295eb77-c4a5-4c32-8027-f06f4412bf7d` |

## Pasos

1. **Leer** la tarea entera. De Proyectos, la fila de su `Proyecto relacionado`: `Repositorio` y `Becarios` (el equipo: solo lanzas a los de QA que estén ahí). Comprueba que estás en una copia de ese repositorio; si no, dilo y para. Mira la visibilidad del repositorio.
2. **Fichas**: de Becarios, la fila de cada uno. Si está `Pausado`, no lo lances. Sus `Instrucciones` van en su encargo; `Modelo` y `Esfuerzo`, si tienen valor, como `model` y `effort`.
3. **Notion**: `Estado = En progreso`, `Fase = Preparación`, `Becario = ["qa-lead"]`.
4. **Rama**: `claude/qa-<slug>` desde la rama por defecto actualizada. Si no hay preview, levanta el build local (`npm ci && npm run build && npm run preview` o lo que diga el repositorio).
5. **Preparación**:
   1. `qa-lead` con la tarea, el modo, la escuadra, el repositorio, la visibilidad, la URL y el equipo → modo, alcance y primeras tareas.
   2. `qa-reconocimiento` → `mapa.md` y la primera versión de `modelo.md`.
   3. `qa-lead` otra vez con el mapa → modelo de la app afinado, `cobertura.md` y reparto con un objetivo medible por tarea, y cuántas personas y rondas.
   4. `qa-poblacion` (si hay usuarios simulados) → `poblacion.json`, `poblacion.md` y el guion.
   Enseña el modo, los flujos críticos, el reparto, las personas y el coste (personas × rondas), y pregunta: `¿Sigo con este plan? (sí / cambios: … / parar)`.
6. **Pruebas**: `Fase = Pruebas` y `Becario` = los que trabajan.
   - Testers en paralelo: `qa-rompedor` ∥ `qa-api`, cada uno con su objetivo.
   - Usuarios en paralelo: un `qa-enjambre` por persona en la ronda 1; cuando terminan todos, la ronda 2 con su diario, y así hasta la última.
   - `qa-lead` revisa la cobertura con los informes y, si hace falta, pide otra tarea concreta (como mucho dos vueltas extra).
   - `qa-verificador` con todos los candidatos → pruebas en `tests/qa/` y cada hallazgo confirmado, descartado o duplicado. Ejecuta la suite (`npx playwright test tests/qa`) y comprueba que la CI queda en verde (los confirmados, como fallo esperado).
   - `qa-informe` → `informe.md` (con hasta 3 entrevistas a personas simuladas, relanzando `qa-enjambre` en modo entrevista).
   Commits pequeños (`qa: mapa y modelo de la app`, `qa: pruebas de regresión`, `qa: informe`), revisando `git diff --cached` para que no entre ningún secreto.
7. **Veredicto**: `qa-lead` con el informe, los hallazgos y la cobertura → **APTO**, **APTO CON RIESGOS** o **NO APTO**, y las subtareas.
8. **Confirmar**: enseña el veredicto, la tabla de fallos confirmados, el embudo, las 3 fricciones principales, las subtareas propuestas y lo que no se ha podido probar, y pregunta: `¿Abro el PR? (sí / cambios: … / solo rama)`.
9. **Cerrar** tras el «sí»:
   - PR contra la rama por defecto, título `[QA] <título>`, con el mismo cuerpo que el skill `encargo`, más el veredicto, el embudo, el enlace a `informe.md` y la lista de pruebas nuevas.
   - En la tarea: `PR`, `Fase = PR y revisión`, `Estado = En espera`, `Bloqueo = PR listo para revisar: <URL>` (o «NO APTO: <fallo más grave>»), `Becario = ["qa-lead"]` y la sección `## QA · <AAAA-MM-DD>` al final del cuerpo con el veredicto, el embudo y los fallos.
   - Cada fallo confirmado, una subtarea para desarrollo: `Tarea padre` = esta, `Estado = Inbox`, mismo `Proyecto relacionado`, sin `Becario`, título que empiece por la gravedad («[Alta] …») y, en el cuerpo, los pasos, lo esperado, lo obtenido, la evidencia, la ruta de su prueba y la gravedad. Las sospechas de seguridad, con «Para Ciberseguridad» al principio del cuerpo.

## Cómo hablas

```
[QA] «Probar las reservas antes de abrir» · Energym · modo estándar · a trabajar
[qa-reconocimiento] 14 rutas · 9 endpoints · 3 roles ✅
[qa-lead] 3 flujos críticos · 6 personas × 2 rondas ⏸
[qa-poblacion] 6 perfiles · 1 accesibilidad · 1 desconfiada ✅
[qa-rompedor] 41 casos · 4 fallos candidatos ✅
[qa-api] 9 endpoints · 2 fallos candidatos ✅
[qa-enjambre] Ronda 1: 4 de 6 reservan · 2 abandonan en la hora ✅
[qa-verificador] 5 confirmados · 1 descartado · 5 pruebas nuevas ✅
[qa-informe] Embudo y 3 predicciones (2 de confianza alta) ✅
[qa-lead] Veredicto: APTO CON RIESGOS · 5 subtareas ⏸
[QA] PR #24 abierto · tarea en «PR y revisión» ✅
```

Unas 15 palabras como mucho por línea. Al final, ✅ hecho, ❌ fallo o ⏸ esperando algo.
