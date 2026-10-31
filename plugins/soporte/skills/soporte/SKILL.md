---
name: soporte
description: "Llama al departamento de Soporte IT en tu Claude Code para una tarea de Notion: la Jefatura de soporte diagnostica y reparte, los especialistas intervienen (soporte, infraestructura, sistemas, comunicaciones, conectividad) y la Jefatura da el veredicto. Deja el informe, los arreglos seguros y las guías en una rama y pregunta antes de abrir el PR."
argument-hint: "<URL de la tarea de Notion>"
disable-model-invocation: true
---

# Departamento de Soporte IT

Encargo: $ARGUMENTS. Tiene que ser la URL (o el id) de una tarea de Notion de la base Tareas. Si está vacío, pregunta qué tarea y para.

Es el mismo flujo de soporte que hace la oficina en la nube (`plugins/oficina/skills/encargo/SKILL.md`, departamento `soporte`), pero en tu ordenador y contigo delante: **preguntas antes de abrir el PR**. Tú coordinas: el diagnóstico, las intervenciones y el veredicto los hacen los agentes.

- `it-lead`: diagnóstico, gravedad, reparto y veredicto final. Solo planifica y revisa.
- `it-soporte`, `it-infraestructura`, `it-sistemas`, `it-comunicaciones` e `it-conectividad`: comprueban, arreglan lo que vive en el repositorio y escriben guías y runbooks.

En el plugin, los agentes se llaman `soporte:<id>` (por ejemplo, `soporte:it-lead`).

## Límites

- No se toca infraestructura de producción desde la sesión: DNS, dominios, variables de entorno, planes, cuentas de usuario, correo ni routers. Lo que exige entrar en una cuenta va como «Pendiente de una persona», con pasos exactos y cómo verificarlo.
- Nunca se piden ni se escriben contraseñas o secretos.
- Nada de comandos destructivos: ni borrar, ni reiniciar servicios de producción, ni restaurar copias.
- No fusiones y no despliegues.

## Notion

Usa cualquier conexión de Notion (el conector de Claude o el servidor MCP). Si no hay, para y di que hay que conectar Notion (`/mcp`).

| Base | Fuente de datos |
| --- | --- |
| Tareas (Oficios OS) | `collection://2ad3221d-8eb7-8065-904d-000b57a0fe2a` |
| Becarios | `collection://7d90c32f-ede0-42ca-8732-2c80134f885b` |
| Proyectos | `collection://c295eb77-c4a5-4c32-8027-f06f4412bf7d` |

## Pasos

1. **Leer** la tarea entera (síntoma, desde cuándo, a quién afecta). De Proyectos, la fila de su `Proyecto relacionado`: `Repositorio` y `Becarios` (el equipo: solo lanzas especialistas de soporte que estén ahí). Comprueba que estás en una copia de ese repositorio; si no, dilo y para.
2. **Fichas**: de Becarios, la fila de cada especialista. Si está `Pausado`, no lo lances. Sus `Instrucciones` van en su encargo; `Modelo` y `Esfuerzo`, si tienen valor, como `model` y `effort`.
3. **Notion**: `Estado = En progreso`, `Fase = Preparación`, `Becario = ["it-lead"]`.
4. **Diagnóstico**: lanza `it-lead` con la tarea, el repositorio, la URL de la web y el equipo. Enseña la gravedad, las hipótesis y el reparto en pocas líneas y pregunta: `¿Sigo con este plan? (sí / cambios: … / parar)`.
5. **Rama**: `claude/soporte-<slug>` desde la rama por defecto actualizada.
6. **Intervención**: `Fase = Intervención` y `Becario` = los especialistas que trabajan. Lánzalos en paralelo cuando son independientes. Haz commits pequeños con lo que escriban.
7. **Veredicto**: lanza `it-lead` con todos los informes. Guarda su informe en `docs/soporte/<AAAA-MM-DD>-<slug>.md` y haz commit.
8. **Confirmar**: enseña el veredicto (RESUELTA, MITIGADA o PENDIENTE DE UNA PERSONA), lo pendiente de una persona y los ficheros, y pregunta: `¿Abro el PR? (sí / cambios: … / solo rama)`.
9. **Cerrar** tras el «sí»:
   - PR contra la rama por defecto, título `[Soporte IT] <título>`, con el mismo cuerpo que el skill `encargo` y la sección «Pendiente de una persona» con los pasos exactos.
   - En la tarea: `PR`, `Fase = PR y revisión`, `Estado = En espera`, `Bloqueo = PR listo para revisar: <URL>` (o el primer paso pendiente de una persona, si el veredicto es ese), `Becario = ["it-lead"]` y la sección `## Soporte IT · <AAAA-MM-DD>` al final del cuerpo con el veredicto, lo pendiente y el enlace al informe.
   - Si el diagnóstico encuentra un defecto de producto que tiene que arreglar desarrollo, una subtarea: `Tarea padre` = esta, `Estado = Inbox`, mismo `Proyecto relacionado`, sin `Becario`, con pasos, esperado, obtenido, evidencia y gravedad.

## Cómo hablas

```
[Soporte IT] «No llegan los correos de reserva» · Energym · a trabajar
[it-lead] Gravedad alta · comunicaciones ∥ infraestructura ⏸
[it-comunicaciones] Falta DKIM de Resend · DMARC sin publicar ✅
[it-infraestructura] DNS correcto · SSL caduca en 60 días ✅
[it-lead] Veredicto: PENDIENTE DE UNA PERSONA · 2 registros DNS ⏸
[Soporte IT] PR #18 abierto · tarea en «PR y revisión» ✅
```

Unas 15 palabras como mucho por línea. Al final, ✅ hecho, ❌ fallo o ⏸ esperando algo.
