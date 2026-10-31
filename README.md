# Becarios de OficiosOsIA

Los departamentos de becarios de OficiosOsIA: agentes de IA para Claude Code que trabajan en los proyectos de los clientes. Es un *marketplace* de plugins con cuatro plugins (y un quinto por subir):

| Plugin | Qué trae | Entrada |
| --- | --- | --- |
| `marketing` | Dirección de marketing, SEO técnico, contenidos, redes sociales, SEO local y analítica. Skill `/marketing:marketing`. | `mk-lead` |
| `soporte` | Jefatura de soporte IT y cinco especialistas: soporte a usuarios, infraestructura, sistemas, comunicaciones y conectividad. Skill `/soporte:soporte`. | `it-lead` |
| `seguridad` | Responsable de seguridad y cinco especialistas: aplicaciones, nube y datos, pentesting, dependencias y secretos, y cumplimiento y privacidad. Skill `/seguridad:seguridad`. | `sec-lead` |
| `oficina` | El skill `encargo`, que ejecuta en la nube una tarea lanzada desde el panel, y el prompt y el script de la tarea programada. | — |
| `desarrollo` | *(a medias)* El plugin `becarios` de desarrollo: cto, diseno, frontend, backend-datos, backend-servicios, ia-automatizacion, qa-funcional, qa-tecnico y delivery. Ya están `diseno` e `ia-automatizacion`; faltan por subir los otros siete. Ver [`plugins/desarrollo/README.md`](plugins/desarrollo/README.md). | `cto` |

Cada departamento entra por su becario de entrada: él planifica, reparte y revisa, y el resto hace el trabajo. Todo termina en un **PR** que revisa y fusiona una persona.

```
plugins/
├── marketing/   agents/ (6) · skills/marketing/
├── soporte/     agents/ (6) · skills/soporte/
├── seguridad/   agents/ (6) · skills/seguridad/
├── oficina/     skills/encargo/ · rutina/prompt.md · rutina/setup.sh
└── desarrollo/  agents/ (diseno, ia-automatizacion; faltan los otros 7) · README.md
```

## Usarlos en tu ordenador

En Claude Code:

```
/plugin marketplace add oficiososia/becarios
/plugin install marketing@oficiososia
/plugin install soporte@oficiososia
/plugin install seguridad@oficiososia
```

Después, en la copia del repositorio del proyecto:

- `/marketing:marketing <URL de la tarea de Notion>`: plan de la dirección, producción, revisión y, cuando dices «sí», PR.
- `/soporte:soporte <URL de la tarea de Notion>`: diagnóstico de la jefatura, intervención de los especialistas, veredicto y, cuando dices «sí», PR con el informe y lo pendiente de una persona.
- `/seguridad:seguridad <URL de la tarea de Notion>`: modelo de amenazas y alcance del responsable de seguridad, auditoría de los especialistas, veredicto y, cuando dices «sí», PR con los arreglos probados y una subtarea por cada hallazgo pendiente.

Hace falta Notion conectado (el conector de Claude o el servidor MCP; compruébalo con `/mcp`). Para actualizar: `/plugin marketplace update oficiososia`.

## Cómo funciona en la nube

Desde el panel de OficiosOsIA asignas una tarea a un departamento de una oficina y la lanzas. El panel llama al disparador de API de **tu** tarea programada de Claude Code para ese proyecto, así que la tarea corre en la nube de Anthropic **con tu suscripción** (la de Pablo o la de Miguel, según quién la lance), sin claves de la API de pago por uso.

1. El panel manda el encargo (`ENCARGO OFICIOSOSIA v1`: la tarea de Notion, el departamento, el equipo y quién la lanza).
2. La tarea programada abre una sesión en la nube con el repositorio del proyecto, clona este repositorio en `~/becarios` y sigue [`plugins/oficina/skills/encargo/SKILL.md`](plugins/oficina/skills/encargo/SKILL.md).
3. El departamento trabaja la tarea en una rama `claude/<departamento>-<slug>` y abre el PR. Vercel crea la preview del PR, que hace de DEMO.
4. La tarea de Notion queda en `PR y revisión`, `En espera`, con el enlace del PR. Los hallazgos de seguridad que no se arreglan en el PR, como subtareas (con los detalles solo en Notion si el repositorio es público). En soporte, lo que exige entrar en una cuenta (DNS, dominio, correo, router) queda como «Pendiente de una persona», con los pasos exactos.
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
- Cambiar variables de entorno de producción, dominios o DNS, ni tocar routers, buzones de correo o cuentas de usuario.
- Pedir o escribir contraseñas, o ejecutar comandos destructivos.
- Hacer pruebas de seguridad fuera del alcance: solo el repositorio, el build local, la preview y la DEMO del proyecto; producción, solo con una URL autorizada por escrito en la tarea; nunca terceros, denegación de servicio, fuerza bruta ni ingeniería social.
- Publicar en un repositorio público los detalles explotables de un fallo: van solo en Notion.
- Publicar en redes sociales o tocar cuentas de anuncios, de Google Business Profile o de analítica.
- Escribir secretos en el código, en Notion o en el PR.
