# Becarios de OficiosOsIA

Todos los becarios de OficiosOsIA: agentes de IA para Claude Code que trabajan en los proyectos de los clientes. Es un *marketplace* de ocho plugins:

| Plugin | Qué trae | Entrada |
| --- | --- | --- |
| `producto` | Product Owner, Project Manager y CTO de producto. Convierten las peticiones del panel en tareas de Notion y contestan el chat. Skill `/producto:producto`. | — |
| `arranque` | El equipo de desarrollo completo para proyectos que empiezan desde cero: Jefatura de arranque, análisis y alcance, plataforma y DevOps, sistema de diseño, frontend base, backend base, calidad y documentación. Skill `/arranque:arranque`. | `ar-lead` |
| `desarrollo` | CTO, diseño UX/UI, frontend, backend de datos y de servicios, IA y automatizaciones, QA funcional, QA técnico y delivery. Skill `/desarrollo:becarios`. | `cto` |
| `qa` | QA y testers en dos escuadras. **Testers**: Jefatura de QA, reconocimiento, rompedor, API y permisos y verificador, que demuestra cada fallo con una prueba automática. **Usuarios simulados**: población simulada, enjambre de usuarios y analista, que simulan a los clientes del negocio usando la app y predicen dónde se atascan. Skill `/qa:qa`. | `qa-lead` |
| `seguridad` | Responsable de seguridad y cinco especialistas: aplicaciones, nube y datos, pentesting, dependencias y secretos, y cumplimiento y privacidad. Skill `/seguridad:seguridad`. | `sec-lead` |
| `marketing` | Dirección de marketing, SEO técnico, contenidos, redes sociales, SEO local y analítica. Skill `/marketing:marketing`. | `mk-lead` |
| `soporte` | Jefatura de soporte IT y cinco especialistas: soporte a usuarios, infraestructura, sistemas, comunicaciones y conectividad. Skill `/soporte:soporte`. | `it-lead` |
| `oficina` | El skill `encargo`, que ejecuta en la nube una tarea lanzada desde el panel, y el prompt y el script de la tarea programada. | — |

Cada departamento entra por su becario de entrada: él planifica, reparte y revisa, y el resto hace el trabajo. Todo termina en un **PR** que revisa y fusiona una persona.

**¿Empiezas desde cero?** Sigue la guía paso a paso [`docs/puesta-en-marcha.pdf`](docs/puesta-en-marcha.pdf): cuentas, Claude Code, plugins, Notion, el panel y la primera tarea en la nube.

```
plugins/
├── producto/    agents/ (3) · skills/producto/
├── arranque/    agents/ (8) · skills/arranque/
├── desarrollo/  agents/ (9) · skills/becarios/ · reference/
├── qa/          agents/ (8) · skills/qa/
├── seguridad/   agents/ (6) · skills/seguridad/
├── marketing/   agents/ (6) · skills/marketing/
├── soporte/     agents/ (6) · skills/soporte/
└── oficina/     skills/encargo/ · rutina/prompt.md · rutina/setup.sh
```

## Usarlos en tu ordenador

En Claude Code:

```
/plugin marketplace add oficiososia/becarios
/plugin install producto@oficiososia
/plugin install arranque@oficiososia
/plugin install desarrollo@oficiososia
/plugin install qa@oficiososia
/plugin install seguridad@oficiososia
/plugin install marketing@oficiososia
/plugin install soporte@oficiososia
/plugin install oficina@oficiososia
```

Después:

- `/producto:producto` (desde cualquier carpeta): contesta el chat del panel y convierte las peticiones pendientes en tareas de Notion, cuando dices «sí». También `/producto:producto chat` o `/producto:producto <URL de una petición>`.
- `/arranque:arranque <URL de la tarea de Notion>`, en la copia del repositorio recién creado: la Jefatura de arranque elige el stack y planifica, el equipo monta los cimientos (plataforma y CI, sistema de diseño, frontend y backend base, calidad, documentación), la Jefatura revisa y, cuando dices «sí», PR con todo el esqueleto y el backlog del MVP como tareas nuevas en Notion.
- `/desarrollo:becarios <URL de la tarea de Notion>`, en la copia del repositorio del proyecto (sin URL, coge la siguiente tarea del CTO): plan del CTO, diseño, desarrollo con pruebas, DEMO en la preview, QA, revisión y, cuando dices «sí», PR. A producción, solo si lo pides después de fusionar.
- `/qa:qa <URL de la tarea de Notion> [rápido|estándar|a fondo] [solo-rompedores|solo-usuarios]`, en la copia del repositorio: la Jefatura de QA fija modo y alcance, Reconocimiento saca el mapa de la app, los testers intentan romperla y el verificador deja cada fallo confirmado como prueba en `tests/qa/`; los usuarios simulados del negocio usan la app en la preview por rondas y el analista escribe el informe de predicción. Veredicto APTO, APTO CON RIESGOS o NO APTO y, cuando dices «sí», PR con las pruebas y el informe y una subtarea por fallo. Cada usuario simulado gasta de tu suscripción: rápido 3 × 1, estándar 6 × 2, a fondo como mucho 12 × 4 (personas × rondas).
- `/seguridad:seguridad <URL de la tarea de Notion>`: modelo de amenazas y alcance del responsable de seguridad, auditoría de los especialistas, veredicto y, cuando dices «sí», PR con los arreglos probados y una subtarea por cada hallazgo pendiente.
- `/marketing:marketing <URL de la tarea de Notion>`: plan de la dirección, producción, revisión y, cuando dices «sí», PR.
- `/soporte:soporte <URL de la tarea de Notion>`: diagnóstico de la jefatura, intervención de los especialistas, veredicto y, cuando dices «sí», PR con el informe y lo pendiente de una persona.

Hace falta Notion conectado (el conector de Claude o el servidor MCP; compruébalo con `/mcp`). Para actualizar: `/plugin marketplace update oficiososia`.

## Cuando un proyecto empieza

Para un proyecto nuevo se usa el departamento de **Arranque**: deja en un solo PR los cimientos (arquitectura, plataforma, sistema de diseño, frontend y backend base, calidad y documentación) y el backlog del MVP como tareas en Notion. Después, el día a día lo lleva Desarrollo. El equipo **no crea** repositorios, cuentas, proyectos ni nada que se pague; antes de lanzarlo, una persona:

1. Crea el repositorio en GitHub con al menos un commit (por ejemplo, un README inicial).
2. Si se van a usar, crea los proyectos de Vercel y Supabase (o los deja para después: el arranque deja los pasos escritos).
3. Añade el proyecto a la base Proyectos de Notion con su `Repositorio` y el departamento de Arranque en el equipo, y crea la tarea de arranque (por ejemplo, «Arranque de la web de …», con lo que quiere el cliente).
4. La lanza desde el panel (departamento Arranque) o con `/arranque:arranque <URL>` en una copia del repositorio.

Si el repositorio ya tiene código real, la Jefatura de arranque lo dirá y recomendará pasar la tarea a Desarrollo.

## Cómo funciona en la nube

Desde el panel de OficiosOsIA asignas una tarea a un departamento de una oficina y la lanzas. El panel llama al disparador de API de **tu** tarea programada de Claude Code para ese proyecto, así que la tarea corre en la nube de Anthropic **con tu suscripción** (la de Pablo o la de Miguel, según quién la lance), sin claves de la API de pago por uso.

1. El panel manda el encargo (`ENCARGO OFICIOSOSIA v1`: la tarea de Notion, el departamento, el equipo y quién la lanza).
2. La tarea programada abre una sesión en la nube con el repositorio del proyecto, clona este repositorio en `~/becarios` y sigue [`plugins/oficina/skills/encargo/SKILL.md`](plugins/oficina/skills/encargo/SKILL.md).
3. El departamento trabaja la tarea en una rama `claude/<departamento>-<slug>` y abre el PR. Vercel crea la preview del PR, que hace de DEMO.
4. La tarea de Notion queda en `PR y revisión`, `En espera`, con el enlace del PR. En arranque, el backlog del MVP se crea como tareas nuevas en Inbox. En QA, cada fallo confirmado queda como prueba de regresión en el PR y como subtarea para desarrollo. Los hallazgos de seguridad que no se arreglan en el PR, como subtareas (con los detalles solo en Notion si el repositorio es público). En soporte, lo que exige entrar en una cuenta (DNS, dominio, correo, router) queda como «Pendiente de una persona», con los pasos exactos.
5. Tú revisas el PR y lo fusionas. La sesión de la nube nunca fusiona, nunca despliega a producción y nunca escribe en bases de datos de producción.

Puedes seguir la sesión en directo, o contestar si se queda esperando, desde [claude.ai/code](https://claude.ai/code) o la app de Claude: el panel enseña su enlace.

## Montar la tarea programada (una por persona y por proyecto)

Cada uno (Pablo y Miguel) lo hace en **su** cuenta de claude.ai, una vez por proyecto. Así cada uno usa su suscripción y sus credenciales, y nadie ve las del otro.

### 1. GitHub

La sesión tiene que poder clonar el repositorio del proyecto y abrir PR en él:

- instala la [Claude GitHub App](https://github.com/apps/claude) en el repositorio (lo hace quien administra esa cuenta de GitHub), o
- conecta tu GitHub desde Claude Code con `/web-setup` (te basta con ser colaborador con permiso de escritura).

### 2. Un entorno de la nube para el proyecto

En [claude.ai/code](https://claude.ai/code), crea un entorno (por ejemplo, «Energym») y configúralo:

- **Acceso a la red**: «Custom», con la casilla de la lista por defecto marcada, y estos dominios:

  ```
  api.vercel.com
  *.vercel.app
  api.supabase.com
  *.supabase.co
  api.notion.com
  ```

- **Secretos de red** (tipo Bearer). La sesión los usa sin verlos:

  | Host | Valor |
  | --- | --- |
  | `api.vercel.com` | Un token de Vercel de la cuenta del proyecto (Vercel → Account Settings → Tokens), con acceso solo a su equipo. |
  | `api.supabase.com` | Un *personal access token* de Supabase de la cuenta del proyecto (Supabase → Account → Access Tokens). |

- **Variables de entorno** (no secretas; las ve quien use el entorno):

  ```
  VERCEL_PROJECT_ID=prj_...
  VERCEL_TEAM_ID=team_...
  SUPABASE_PROJECT_REF=abcdefghijklmnop
  ```

  y las variables públicas que necesita la app para compilar y para las pruebas (por ejemplo, `VITE_SUPABASE_URL` y `VITE_SUPABASE_ANON_KEY`). Nunca la clave `service_role` ni secretos de producción.

- **Script de preparación** (opcional): pega [`plugins/oficina/rutina/setup.sh`](plugins/oficina/rutina/setup.sh). Instala las CLI de Vercel y Supabase y Chromium para Playwright.

### 3. La tarea programada

En [claude.ai/code/routines](https://claude.ai/code/routines), crea una tarea nueva (por ejemplo, «Oficina · Energym»):

- **Instrucciones**: el texto de [`plugins/oficina/rutina/prompt.md`](plugins/oficina/rutina/prompt.md), tal cual.
- **Modelo**: el que quieras para coordinar (los becarios usan el de su ficha del panel o el de su fichero).
- **Repositorio**: el del proyecto (solo ese).
- **Entorno**: el del paso 2.
- **Conectores**: deja **Notion** y quita los que no necesite.
- Sin horario: solo se lanza desde el panel.

### 4. El disparador de API y el panel

1. En la tarea, añade un disparador **API** y pulsa **Generate token**.
2. Copia la **Fire URL** y el **token** (solo se enseña una vez).
3. En el panel, pestaña **Conexiones**, pégalos en la fila de ese proyecto. El panel guarda el token cifrado y solo lo usa para lanzar tus tareas.

Si generas un token nuevo, el anterior deja de valer: vuelve a pegarlo en el panel.

## Límites

- Cada tarea programada acepta 30 lanzamientos por hora, y cada cuenta 100 por hora entre todas.
- Cada ejecución gasta de tu suscripción igual que una sesión normal de Claude Code. Si llegas al límite de uso, los lanzamientos se rechazan hasta que se renueva (salvo que tengas activado el uso extra).
- Las tareas programadas y su disparador de API están en *research preview*: pueden cambiar.
- Cada lanzamiento abre una sesión nueva: si lanzas dos veces la misma tarea, trabajan dos sesiones.

## Lo que nunca hacen los becarios

- Fusionar PR, desplegar a producción o promocionar despliegues.
- Aplicar migraciones o escribir en bases de datos de producción.
- Crear repositorios, cuentas, proyectos de Vercel o Supabase, dominios o cualquier cosa que se pague.
- Cambiar variables de entorno de producción, dominios o DNS, ni tocar routers, buzones de correo o cuentas de usuario.
- Pedir o escribir contraseñas, o ejecutar comandos destructivos.
- Probar con datos o cuentas de personas reales: QA usa usuarios de prueba y perfiles simulados inventados.
- Hacer pruebas de seguridad fuera del alcance: solo el repositorio, el build local, la preview y la DEMO del proyecto; producción, solo con una URL autorizada por escrito en la tarea; nunca terceros, denegación de servicio, fuerza bruta ni ingeniería social.
- Publicar en un repositorio público los detalles explotables de un fallo: van solo en Notion.
- Publicar en redes sociales o tocar cuentas de anuncios, de Google Business Profile o de analítica.
- Escribir secretos en el código, en Notion o en el PR.

## Créditos e inspiración

El departamento de QA y testers se inspira en la forma de trabajar de dos proyectos libres:

- [Strix](https://github.com/usestrix/strix) (Apache-2.0): un agente que coordina sin probar, un modelo compartido de la app que el equipo corrige con enmiendas, una tabla de cobertura que se reconcilia antes de terminar y la regla de que no hay hallazgo sin una prueba que lo demuestre.
- [MiroFish](https://github.com/666ghj/MiroFish) (AGPL-3.0): de una semilla a un mapa del negocio, de ahí a perfiles simulados con memoria, simulación por rondas y un informe planificado por secciones con entrevistas a los perfiles.

Aquí no hay código ni prompts copiados de ninguno de los dos: solo la idea del método, escrita de nuevo para Claude Code. No hace falta instalar Strix ni MiroFish, ni sus claves de API de modelos, ni Zep: todo corre con la suscripción de Claude de quien lanza la tarea.
