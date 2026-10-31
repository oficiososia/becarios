---
name: seguridad
description: "Llama al departamento de Ciberseguridad en tu Claude Code para una tarea de Notion: la persona responsable de seguridad hace el modelo de amenazas y fija el alcance, los especialistas auditan (aplicaciones, nube y datos, pentesting, dependencias y secretos, cumplimiento, detección y respuesta) y el responsable da el veredicto. Deja el informe, los arreglos probados y los runbooks en una rama y pregunta antes de abrir el PR."
argument-hint: "<URL de la tarea de Notion>"
disable-model-invocation: true
---

# Departamento de Ciberseguridad

Encargo: $ARGUMENTS. Tiene que ser la URL (o el id) de una tarea de Notion de la base Tareas. Si está vacío, pregunta qué tarea y para.

Es el mismo flujo de seguridad que hace la oficina en la nube (`plugins/oficina/skills/encargo/SKILL.md`, departamento `seguridad`), pero en tu ordenador y contigo delante: **preguntas antes de abrir el PR**. Tú coordinas: el modelo de amenazas, la auditoría y el veredicto los hacen los agentes.

- `sec-lead`: modelo de amenazas, alcance y reglas, reparto y veredicto final. Solo planifica y revisa.
- `sec-aplicaciones`, `sec-nube`, `sec-pentest`, `sec-dependencias`, `sec-cumplimiento` y `sec-respuesta`: auditan, demuestran cada hallazgo, arreglan lo pequeño y seguro con su prueba y escriben runbooks.

En el plugin, los agentes se llaman `seguridad:<id>` (por ejemplo, `seguridad:sec-lead`).

## Límites

- **Solo pruebas autorizadas y dentro del alcance**: el repositorio, el build local, la preview del PR y la DEMO de este proyecto. Producción, solo si la tarea autoriza por escrito una URL concreta. Nunca terceros (Stripe, Supabase o Vercel como plataformas, proveedores, otros clientes).
- Nada de denegación de servicio ni pruebas de carga, fuerza bruta de más de 5 intentos, ingeniería social, sacar datos reales ni dejar persistencia.
- No se tocan cuentas ni producción: ni políticas en la base de datos, ni reglas del firewall, ni claves. Lo que exige entrar en una cuenta va como «Pendiente de una persona», con pasos exactos y cómo verificarlo.
- Nunca se piden, imprimen ni escriben contraseñas, tokens o claves. Un secreto encontrado se describe (tipo y dónde), no se copia.
- No fusiones y no despliegues.

## Regla de divulgación

Antes de escribir hallazgos, mira si el repositorio es público: `gh repo view --json visibility -q .visibility` (o la API de GitHub).

- **Público**: los detalles explotables (endpoints, payloads, pasos para reproducir) van **solo** en las subtareas de Notion, que son privadas. El informe del repositorio y el PR quedan genéricos («se corrige un fallo de control de acceso en la API de reservas»). Los arreglos sí van en el PR.
- **Privado**: el informe puede llevar todos los detalles.

## Notion

Usa cualquier conexión de Notion (el conector de Claude o el servidor MCP). Si no hay, para y di que hay que conectar Notion (`/mcp`).

| Base | Fuente de datos |
| --- | --- |
| Tareas (Oficios OS) | `collection://2ad3221d-8eb7-8065-904d-000b57a0fe2a` |
| Becarios | `collection://7d90c32f-ede0-42ca-8732-2c80134f885b` |
| Proyectos | `collection://c295eb77-c4a5-4c32-8027-f06f4412bf7d` |

## Pasos

1. **Leer** la tarea entera (qué hay que revisar, URL autorizadas si las hay). De Proyectos, la fila de su `Proyecto relacionado`: `Repositorio` y `Becarios` (el equipo: solo lanzas especialistas de seguridad que estén ahí). Comprueba que estás en una copia de ese repositorio; si no, dilo y para. Mira la visibilidad del repositorio.
2. **Fichas**: de Becarios, la fila de cada especialista. Si está `Pausado`, no lo lances. Sus `Instrucciones` van en su encargo; `Modelo` y `Esfuerzo`, si tienen valor, como `model` y `effort`.
3. **Notion**: `Estado = En progreso`, `Fase = Preparación`, `Becario = ["sec-lead"]`.
4. **Modelo de amenazas**: lanza `sec-lead` con la tarea, el repositorio, la visibilidad, las URL del alcance y el equipo. Enseña los activos, las amenazas principales, el alcance y el reparto en pocas líneas y pregunta: `¿Sigo con este plan? (sí / cambios: … / parar)`.
5. **Rama**: `claude/seguridad-<slug>` desde la rama por defecto actualizada. Si `sec-pentest` interviene y no hay preview, levanta el build local (`npm ci && npm run build && npm run preview` o lo que diga el repositorio).
6. **Auditoría**: `Fase = Auditoría` y `Becario` = los especialistas que trabajan. Lánzalos en paralelo cuando son independientes (`sec-dependencias` ∥ `sec-nube` ∥ `sec-cumplimiento`; `sec-pentest` con la preview o el build local). Cada uno recibe el alcance y la regla de divulgación. Commits pequeños con lo que escriban, revisando `git diff --cached` para que no entre ningún secreto.
7. **Veredicto**: lanza `sec-lead` con todos los informes. Guarda su informe en `docs/seguridad/<AAAA-MM-DD>-<slug>.md` (genérico si el repositorio es público) y haz commit.
8. **Confirmar**: enseña el veredicto (SEGURO, SEGURO CON RIESGOS ACEPTADOS o NO SEGURO), la tabla de hallazgos, lo arreglado, las subtareas propuestas y lo pendiente de una persona, y pregunta: `¿Abro el PR? (sí / cambios: … / solo rama)`.
9. **Cerrar** tras el «sí»:
   - PR contra la rama por defecto, título `[Ciberseguridad] <título>`, con el mismo cuerpo que el skill `encargo` (genérico si el repositorio es público) y la sección «Pendiente de una persona».
   - En la tarea: `PR`, `Fase = PR y revisión`, `Estado = En espera`, `Bloqueo = PR listo para revisar: <URL>` (o «NO SEGURO: <hallazgo más grave, en genérico>» si el veredicto es ese), `Becario = ["sec-lead"]` y la sección `## Ciberseguridad · <AAAA-MM-DD>` al final del cuerpo con el veredicto, la tabla de hallazgos y el enlace al informe.
   - Cada hallazgo no arreglado, una subtarea: `Tarea padre` = esta, `Estado = Inbox`, mismo `Proyecto relacionado`, sin `Becario`, título que empiece por la gravedad («[Alta] …») y, en el cuerpo, los pasos para reproducirlo, lo esperado, lo obtenido, la evidencia y la gravedad. Aquí sí van los detalles completos.

## Cómo hablas

```
[Ciberseguridad] «Auditoría antes de abrir reservas» · Energym · a trabajar
[sec-lead] Repo privado · alcance: preview + build local · 4 especialistas ⏸
[sec-dependencias] 2 vulnerabilidades altas (solo build) · 0 secretos ✅
[sec-nube] 1 tabla sin RLS · faltan HSTS y CSP ✅
[sec-aplicaciones] IDOR en reservas · arreglado con prueba ✅
[sec-pentest] 9 pruebas en la preview · confirma el IDOR, ya corregido ✅
[sec-lead] Veredicto: SEGURO CON RIESGOS ACEPTADOS · 2 subtareas ✅
[Ciberseguridad] PR #21 abierto · tarea en «PR y revisión» ✅
```

Unas 15 palabras como mucho por línea. Al final, ✅ hecho, ❌ fallo o ⏸ esperando algo.
