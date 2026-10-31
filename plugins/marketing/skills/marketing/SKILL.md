---
name: marketing
description: "Llama al departamento de marketing en tu Claude Code para una tarea de Notion: la dirección fija posicionamiento y reparto, los miembros producen (SEO técnico, contenidos, redes sociales, SEO local, analítica) y la dirección revisa. Deja los cambios en una rama y pregunta antes de abrir el PR."
argument-hint: "<URL de la tarea de Notion>"
disable-model-invocation: true
---

# Departamento de marketing

Encargo: $ARGUMENTS. Tiene que ser la URL (o el id) de una tarea de Notion de la base Tareas. Si está vacío, pregunta qué tarea y para.

Es el mismo flujo de marketing que hace la oficina en la nube (`plugins/oficina/skills/encargo/SKILL.md`, departamento `marketing`), pero en tu ordenador y contigo delante: **preguntas antes de abrir el PR**. Tú coordinas: el plan, los textos y la revisión los hacen los agentes.

- `mk-lead`: posicionamiento, mensajes, reparto y revisión. Solo planifica y revisa.
- `mk-seo`, `mk-contenidos`, `mk-rrss`, `mk-local` y `mk-analitica`: producen y escriben en el repositorio.

En el plugin, los agentes se llaman `marketing:<id>` (por ejemplo, `marketing:mk-lead`).

## Límites

- No se publica nada en redes, ni se tocan cuentas de anuncios, de Google Business Profile ni de analítica: todo queda listo para una persona.
- Nada de datos del negocio inventados, reseñas falsas ni analítica sin consentimiento.
- No fusiones, no despliegues y no escribas secretos en ningún sitio.

## Notion

Usa cualquier conexión de Notion (el conector de Claude o el servidor MCP). Si no hay, para y di que hay que conectar Notion (`/mcp`).

| Base | Fuente de datos |
| --- | --- |
| Tareas (Oficios OS) | `collection://2ad3221d-8eb7-8065-904d-000b57a0fe2a` |
| Becarios | `collection://7d90c32f-ede0-42ca-8732-2c80134f885b` |
| Proyectos | `collection://c295eb77-c4a5-4c32-8027-f06f4412bf7d` |

## Pasos

1. **Leer** la tarea entera. De Proyectos, la fila de su `Proyecto relacionado`: `Repositorio` y `Becarios` (el equipo: solo lanzas miembros de marketing que estén ahí). Comprueba que estás en una copia de ese repositorio; si no, dilo y para.
2. **Fichas**: de Becarios, la fila de cada miembro. Si está `Pausado`, no lo lances. Sus `Instrucciones` van en su encargo; `Modelo` y `Esfuerzo`, si tienen valor, como `model` y `effort`.
3. **Notion**: `Estado = En progreso`, `Fase = Preparación`, `Becario = ["mk-lead"]`.
4. **Plan**: lanza `mk-lead` con la tarea, el repositorio, la URL de la preview si la hay y el equipo. Enseña el posicionamiento y el reparto en pocas líneas y pregunta: `¿Sigo con este plan? (sí / cambios: … / parar)`.
5. **Rama**: `claude/marketing-<slug>` desde la rama por defecto actualizada.
6. **Producción**: `Fase = Producción` y `Becario` = los miembros que trabajan. `mk-seo` y `mk-local` suelen ir en paralelo; `mk-contenidos` después de las palabras clave; `mk-rrss` al final. Commits pequeños con lo que escriban.
7. **Revisión**: lanza `mk-lead` con todo lo producido. Lo que pida corregir vuelve a quien toque.
8. **Confirmar**: enseña lo hecho, los ficheros y lo que tiene que hacer una persona, y pregunta: `¿Abro el PR? (sí / cambios: … / solo rama)`.
9. **Cerrar** tras el «sí»:
   - PR contra la rama por defecto, título `[Marketing] <título>`, con el mismo cuerpo que el skill `encargo` y la lista de lo que tiene que hacer una persona.
   - En la tarea: `PR`, `Fase = PR y revisión`, `Estado = En espera`, `Bloqueo = PR listo para revisar: <URL>`, `Becario = ["mk-lead"]` y la sección `## Marketing · <AAAA-MM-DD>` al final del cuerpo con el resumen.
   - Los trabajos de seguimiento que proponga `mk-lead`, como subtareas: `Tarea padre` = esta, `Estado = Inbox`, mismo `Proyecto relacionado`, sin `Becario`.

## Cómo hablas

```
[Marketing] «SEO local de JPR» · JPR · a trabajar
[Marketing] Plan: seo ∥ local, después contenidos y rrss ⏸
[mk-local] NAP coherente · ficha de Google lista para copiar ✅
[mk-rrss] Calendario de noviembre · 12 publicaciones ✅
[Marketing] PR #17 abierto · 4 cosas para una persona ✅
```

Unas 15 palabras como mucho por línea. Al final, ✅ hecho, ❌ fallo o ⏸ esperando algo.
