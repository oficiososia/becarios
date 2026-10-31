---
name: becarios
description: "Llama al departamento de desarrollo en tu Claude Code para una tarea de Notion: el CTO hace el plan, diseño especifica la interfaz, frontend, backend e IA programan con pruebas, QA funcional y técnico prueban en la preview, el CTO revisa y delivery deja el PR con su DEMO. Pregunta antes de abrir el PR y antes de cualquier cosa en producción."
argument-hint: "[URL de la tarea de Notion | vacío = la siguiente del CTO]"
disable-model-invocation: true
---

# Departamento de desarrollo

Encargo: $ARGUMENTS. Si es la URL (o el id) de una tarea de Notion, trabaja esa. Si está vacío, coge la siguiente tarea del CTO: en Tareas, las que tienen `Becario` = `cto`, `Fase = Preparación` y `Estado` en `Por hacer` o `En progreso`, del proyecto de este repositorio; la de prioridad más alta y, a igualdad, la más antigua. Si no hay ninguna, dilo y para.

Es el mismo flujo que hace la oficina en la nube (`plugins/oficina/skills/encargo/SKILL.md`, departamento `desarrollo`), pero en tu ordenador y contigo delante: **preguntas antes de abrir el PR** y nada pasa a producción sin tu «sí» explícito después de fusionar. Tú coordinas: el plan, el código, las pruebas y la revisión los hacen los agentes.

- `cto`: plan técnico, reparto y revisión. Solo planifica y revisa.
- `diseno`, `frontend`, `backend-datos`, `backend-servicios` e `ia-automatizacion`: diseñan y programan con sus pruebas.
- `qa-funcional` y `qa-tecnico`: prueban en la preview (DEMO).
- `delivery`: PR, DEMO, versión y registro de entrega.

En el plugin, los agentes se llaman `desarrollo:<id>` (por ejemplo, `desarrollo:cto`). El proceso completo está en `reference/proceso.md` y las bases de Notion en `reference/notion.md`, junto a este skill (en la carpeta del plugin).

## Antes de lanzar a cada becario

Lee su fila en la base «Becarios» de Notion (data source `7d90c32f-ede0-42ca-8732-2c80134f885b`, columna `Id`):

- `Pausado` marcado → no lo lances: `[<id>] Pausado en el panel ⏸` y sigue sin él (si es el `cto`, para: todo entra por él).
- `Instrucciones` → van en su encargo, como reglas para toda la tarea (salvo que contradigan este skill o el `CLAUDE.md` del repositorio).
- `Modelo` con valor → pásalo como `model`; `Esfuerzo` con valor → como `effort`. Vacíos, o si no encuentras la base o la fila: no pases ninguno; manda la cabecera del fichero del agente.

Solo lanzas a los becarios que están en el equipo del proyecto (`Becarios` de su fila en Proyectos).

## Pasos

1. **Leer** la tarea entera y, de Proyectos, `Repositorio` y `Becarios`. Comprueba que estás en una copia de ese repositorio; si no, dilo y para.
2. **Notion**: `Estado = En progreso`, `Fase = Preparación`, `Becario = ["cto"]`.
3. **Plan**: lanza `cto`. Enseña el plan en pocas líneas y pregunta: `¿Sigo con este plan? (sí / cambios: … / parar)`.
4. **Rama**: `claude/desarrollo-<slug>` desde la rama por defecto actualizada.
5. **Diseño** (si hay interfaz): `diseno`, todavía en Preparación. Guarda su especificación en `docs/diseno/` y haz commit.
6. **Desarrollo y unitarias**: `Fase = Desarrollo y unitarias`, `Becario` = quienes trabajan. Lanza `backend-datos` antes que quien use sus tablas; lo independiente en paralelo. Commits pequeños con lo que escriban. Al final, build y pruebas en verde.
7. **Despliegue DEMO**: `Fase = Despliegue DEMO`, `Becario = ["delivery"]`. Push y PR en **borrador** para que Vercel cree la preview; `delivery` la espera y apunta `Versión`.
8. **QA DEMO**: `Fase = QA DEMO`, `Becario = ["qa-funcional", "qa-tecnico"]`, en paralelo contra la preview. Lo que falle vuelve a quien toque y se repite el paso.
9. **Revisión**: lanza `cto` con el diff y los informes. Si pide cambios, vuelve a quien toque.
10. **Confirmar**: enseña el veredicto, la DEMO, las pruebas y los pendientes, y pregunta: `¿Paso el PR a listo para revisar? (sí / cambios: … / solo borrador)`.
11. **PR y revisión** tras el «sí»: `delivery` pasa el PR a listo, apunta `PR` y `Versión` y crea el registro de entrega. En la tarea: `Fase = PR y revisión`, `Estado = En espera`, `Bloqueo = PR listo para revisar: <URL>`, `Becario = ["cto"]` y la sección `## Desarrollo · <AAAA-MM-DD>` al final del cuerpo.
12. **Producción, solo si lo pides después de fusionar**: si dices «despliega <tarea>» con el PR ya fusionado, pregunta una vez más: `¿Confirmas el paso a producción de <versión>? (sí / no)`. Con el «sí», `Fase = Despliegue PROD` y `delivery` comprueba el despliegue; luego `Fase = QA PROD` con `qa-funcional` contra producción en solo lectura; si todo va bien, `Fase = Cerrada` y `Estado = Hecha`.

Defectos que no se arreglan en esta tarea: subtareas en Tareas con `Tarea padre` = esta, `Estado = Inbox`, mismo `Proyecto relacionado` y sin `Becario`.

## Límites

- No fusionas el PR.
- Nada en producción sin el «sí» explícito del paso 12: ni despliegues, ni migraciones, ni variables de entorno, ni dominios.
- No escribes secretos en el código, los commits, Notion ni el PR.
- No tocas otras tareas de Notion que esta y sus subtareas nuevas.

## Cómo hablas

```
[Desarrollo] «Reserva de clases desde el móvil» · Energym · a trabajar
[cto] Plan: datos → servicios ∥ diseño → frontend · 3 riesgos ⏸
[backend-datos] Tabla reservas con RLS · 4 pruebas ✅
[frontend] Pantalla de reserva · móvil y escritorio ✅
[delivery] PR #31 en borrador · DEMO lista ✅
[qa-funcional] 5 de 5 criterios ✅ · [qa-tecnico] build y API ✅
[cto] Revisión: APROBADO ⏸
[Desarrollo] PR #31 listo · tarea en «PR y revisión» ✅
```

Unas 15 palabras como mucho por línea. Al final, ✅ hecho, ❌ fallo o ⏸ esperando algo.
