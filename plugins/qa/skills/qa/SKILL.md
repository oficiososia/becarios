---
name: qa
description: "Llama al departamento de QA en tu Claude Code para una tarea de Notion: la Jefa de QA hace el plan, los perfiles prueban (automatización, accesibilidad, rendimiento, seguridad, visual, exploratorio) y la Jefa da el veredicto. Deja pruebas e informe en una rama y pregunta antes de abrir el PR."
argument-hint: "<URL de la tarea de Notion>"
disable-model-invocation: true
---

# Departamento de QA

Encargo: $ARGUMENTS. Tiene que ser la URL (o el id) de una tarea de Notion de la base Tareas. Si está vacío, pregunta qué tarea y para.

Es el mismo flujo de QA que hace la oficina en la nube (`plugins/oficina/skills/encargo/SKILL.md`, departamento `qa`), pero en tu ordenador y contigo delante: **preguntas antes de abrir el PR**. Tú coordinas: los planes, las pruebas y el veredicto los hacen los agentes.

- `qa-lead`: plan de pruebas, reparto y veredicto final. Solo planifica y revisa.
- `qa-automatizacion`, `qa-accesibilidad`, `qa-rendimiento`, `qa-seguridad`, `qa-visual` y `qa-exploratorio`: prueban y escriben las pruebas.

En el plugin, los agentes se llaman `qa:<id>` (por ejemplo, `qa:qa-lead`).

## Límites

- QA no arregla código de producto: cada defecto es una subtarea en Notion.
- Nada contra producción ni con datos reales de clientes.
- No fusiones, no despliegues y no escribas secretos en ningún sitio.

## Notion

Usa cualquier conexión de Notion (el conector de Claude o el servidor MCP). Si no hay, para y di que hay que conectar Notion (`/mcp`).

| Base | Fuente de datos |
| --- | --- |
| Tareas (Oficios OS) | `collection://2ad3221d-8eb7-8065-904d-000b57a0fe2a` |
| Becarios | `collection://7d90c32f-ede0-42ca-8732-2c80134f885b` |
| Proyectos | `collection://c295eb77-c4a5-4c32-8027-f06f4412bf7d` |

## Pasos

1. **Leer** la tarea entera (historia, criterios, notas). De Proyectos, la fila de su `Proyecto relacionado`: `Repositorio` y `Becarios` (el equipo: solo lanzas perfiles de QA que estén ahí). Comprueba que estás en una copia de ese repositorio; si no, dilo y para.
2. **Fichas**: de Becarios, la fila de cada perfil. Si está `Pausado`, no lo lances. Sus `Instrucciones` van en su encargo; `Modelo` y `Esfuerzo`, si tienen valor, como `model` y `effort`.
3. **Notion**: `Estado = En progreso`, `Fase = Preparación`, `Becario = ["qa-lead"]`.
4. **Plan**: lanza `qa-lead` con la tarea, el repositorio, la URL de la preview si la hay y el equipo. Enseña el plan en pocas líneas y pregunta: `¿Sigo con este plan? (sí / cambios: … / parar)`.
5. **Rama**: `claude/qa-<slug>` desde la rama por defecto actualizada.
6. **Pruebas**: `Fase = Pruebas` y `Becario` = los perfiles que trabajan. Lánzalos en paralelo cuando son independientes. Haz commits pequeños con lo que escriban.
7. **Veredicto**: lanza `qa-lead` con todos los informes. Guarda su informe en `docs/qa/<AAAA-MM-DD>-<slug>.md` y haz commit.
8. **Confirmar**: enseña el veredicto, los hallazgos y los ficheros, y pregunta: `¿Abro el PR y creo N subtareas? (sí / cambios: … / solo rama)`.
9. **Cerrar** tras el «sí»:
   - PR contra la rama por defecto, título `[QA] <título>`, con el mismo cuerpo que el skill `encargo`.
   - En la tarea: `PR`, `Fase = PR y revisión`, `Estado = En espera`, `Bloqueo = PR listo para revisar: <URL>`, `Becario = ["qa-lead"]` y la sección `## QA · <AAAA-MM-DD>` al final del cuerpo con el veredicto y el enlace al informe.
   - Una subtarea por defecto: `Tarea padre` = esta, `Estado = Inbox`, mismo `Proyecto relacionado`, sin `Becario`, con pasos, esperado, obtenido, evidencia y gravedad.

## Cómo hablas

```
[QA] «Auditoría de accesibilidad» · Energym · a trabajar
[QA] Plan: accesibilidad ∥ visual, después automatización ⏸
[qa-accesibilidad] 3 hallazgos (1 bloqueante) · 2 specs nuevos ✅
[QA] Veredicto: NO APTO · 1 bloqueante ⏸
[QA] PR #42 abierto · 3 subtareas en Notion ✅
```

Unas 15 palabras como mucho por línea. Al final, ✅ hecho, ❌ fallo o ⏸ esperando algo.
