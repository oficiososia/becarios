---
name: arranque
description: "Llama al departamento de Arranque en tu Claude Code para un proyecto que empieza desde cero: la Jefatura de arranque elige el stack y planifica, el equipo monta los cimientos (plataforma, sistema de diseño, frontend y backend base, calidad y documentación) y la Jefatura revisa. Deja el esqueleto en una rama, pregunta antes de abrir el PR y crea el backlog del MVP en Notion."
argument-hint: "<URL de la tarea de Notion>"
disable-model-invocation: true
---

# Departamento de Arranque

Encargo: $ARGUMENTS. Tiene que ser la URL (o el id) de una tarea de Notion de la base Tareas. Si está vacío, pregunta qué tarea y para.

Es el mismo flujo de arranque que hace la oficina en la nube (`plugins/oficina/skills/encargo/SKILL.md`, departamento `arranque`), pero en tu ordenador y contigo delante: **preguntas antes de abrir el PR** y antes de crear las tareas del backlog. Tú coordinas: el plan, el código, las pruebas y la documentación los hacen los agentes.

- `ar-lead`: descubrimiento técnico, stack, ADR, plan por hitos y veredicto final. Solo planifica y revisa.
- `ar-analisis`: alcance del MVP, mapa de la web, contenidos, lo que pedir al cliente y backlog.
- `ar-plataforma`, `ar-diseno`, `ar-frontend`, `ar-backend` y `ar-calidad`: montan los cimientos.
- `ar-documentacion`: README, `CLAUDE.md`, arquitectura, ADR y traspaso a Desarrollo.

En el plugin, los agentes se llaman `arranque:<id>` (por ejemplo, `arranque:ar-lead`).

## Antes de empezar (lo hace una persona)

El equipo **no crea** repositorios, cuentas, proyectos ni nada que se pague. Antes de lanzar el arranque, una persona:

1. Crea el repositorio en GitHub con al menos un commit (por ejemplo, un README inicial).
2. Si el proyecto los va a usar, crea los proyectos de Vercel y Supabase (o los deja para después: el arranque deja los pasos escritos).
3. Pone la URL del repositorio en `Repositorio` de su fila de Proyectos en Notion, y el departamento de Arranque en su equipo.

Si el repositorio ya tiene código real (algo más que un README, un `.gitignore` o una licencia), no es un arranque: `ar-lead` lo dirá y recomendará pasarlo a Desarrollo. Solo se sigue si la tarea dice expresamente que hay que rehacerlo.

## Límites

- No se crean repositorios, cuentas, proyectos de Vercel o Supabase, dominios ni nada que se pague.
- No se aplican migraciones ni se escribe en ningún proyecto real de Supabase: el esquema va como ficheros.
- No se cambian ajustes de producción, variables de Vercel ni la protección de ramas: van como pasos para una persona.
- Nada de datos del negocio inventados: el contenido de relleno se marca como provisional.
- No fusiones y no despliegues.

## Notion

Usa cualquier conexión de Notion (el conector de Claude o el servidor MCP). Si no hay, para y di que hay que conectar Notion (`/mcp`).

| Base | Fuente de datos |
| --- | --- |
| Tareas (Oficios OS) | `collection://2ad3221d-8eb7-8065-904d-000b57a0fe2a` |
| Becarios | `collection://7d90c32f-ede0-42ca-8732-2c80134f885b` |
| Proyectos | `collection://c295eb77-c4a5-4c32-8027-f06f4412bf7d` |

## Pasos

1. **Leer** la tarea entera y, si la enlaza, la petición original. De Proyectos, la fila de su `Proyecto relacionado`: `Repositorio` y `Becarios` (el equipo: solo lanzas a los de arranque que estén ahí). Comprueba que estás en una copia de ese repositorio y que tiene al menos un commit; si no, dilo y para.
2. **Fichas**: de Becarios, la fila de cada becario. Si está `Pausado`, no lo lances. Sus `Instrucciones` van en su encargo; `Modelo` y `Esfuerzo`, si tienen valor, como `model` y `effort`.
3. **Notion**: `Estado = En progreso`, `Fase = Preparación`, `Becario = ["ar-lead"]`.
4. **Plan**: lanza `ar-lead` con la tarea, el repositorio y el equipo, y después `ar-analisis` con su plan. Enseña el stack con su motivo, los hitos, el reparto, el alcance del MVP y lo que hay que pedir al cliente, y pregunta: `¿Sigo con este plan? (sí / cambios: … / parar)`.
5. **Rama**: `claude/arranque-<slug>` desde la rama por defecto actualizada.
6. **Cimientos**: `Fase = Cimientos` y `Becario` = los que trabajan en cada momento.
   1. `ar-plataforma` primero: estructura, herramientas, CI, Vercel y Supabase como código.
   2. Después, en paralelo cuando son independientes: `ar-diseno` ∥ `ar-backend`; luego `ar-frontend` (usa los componentes de diseño y el cliente de Supabase) y `ar-calidad` (prueba las páginas base).
   3. `ar-documentacion` el último, con los ADR de `ar-lead` y los informes de todos.
   Haz commits pequeños con lo que escriba cada uno (`arranque: plataforma y CI`, `arranque: sistema de diseño`…). Comprueba `npm ci`, lint, tipos, pruebas, E2E y build.
7. **Revisión**: lanza `ar-lead` con el diff y los informes. Si su veredicto es **FALTAN COSAS**, vuelve a quien toque y repite. Sigue con **LISTO PARA DESARROLLO**.
8. **Confirmar**: enseña el veredicto, los ficheros principales, lo provisional, lo pendiente de una persona y el backlog del MVP, y pregunta: `¿Abro el PR y creo el backlog en Notion? (sí / cambios: … / solo rama)`.
9. **Cerrar** tras el «sí»:
   - PR contra la rama por defecto, título `[Arranque] <título>`, con el mismo cuerpo que el skill `encargo`, más el stack elegido, el backlog del MVP y la sección «Pendiente de una persona» con los pasos exactos (crear o conectar Vercel y Supabase, cargar variables, proteger la rama).
   - **Backlog del MVP en Notion** (excepción a la regla de subtareas, para que salgan en el panel): cada historia de `docs/arranque/backlog-mvp.md`, como mucho 15, es una **tarea nueva de primer nivel** en Tareas: `Título de la tarea`, `Estado = Inbox`, el mismo `Proyecto relacionado`, `Becario` vacío, `Área = Producto`, `Prioridad` la del backlog, `Notas` = «Creada por Arranque a partir de <título de la tarea>», y en el cuerpo la descripción de una línea y cómo se comprueba que está hecha. Sin `Tarea padre`.
   - En la tarea del arranque: `PR`, `Fase = PR y revisión`, `Estado = En espera`, `Bloqueo = PR listo para revisar: <URL>`, `Becario = ["ar-lead"]` y la sección `## Arranque · <AAAA-MM-DD>` al final del cuerpo con el stack, el veredicto, lo pendiente de una persona y la lista de tareas del backlog creadas.
   - Nada más de Notion se toca.

## Cómo hablas

```
[Arranque] «Web de Cristalería BV» · Cristalería BV · a trabajar
[ar-lead] Repo vacío ✅ · Stack: Astro + Tailwind + Vercel (web de contenidos) ⏸
[ar-analisis] MVP: 7 páginas · 9 historias · 6 cosas que pedir al cliente ✅
[ar-plataforma] Astro 5, Node 22, CI con lint, tipos, pruebas y build ✅
[ar-diseno] Tokens de marca · contraste ok · 7 componentes ✅
[ar-frontend] 7 rutas · SEO base · Lighthouse móvil 97 ✅
[ar-calidad] 7 pruebas de humo + axe en verde ✅
[ar-documentacion] README, CLAUDE.md, 4 ADR y traspaso ✅
[ar-lead] Veredicto: LISTO PARA DESARROLLO ✅
[Arranque] PR #3 abierto · 9 tareas del MVP en Inbox ✅
```

Unas 15 palabras como mucho por línea. Al final, ✅ hecho, ❌ fallo o ⏸ esperando algo.
