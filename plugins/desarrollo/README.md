# Departamento de desarrollo

Aquí va el plugin `becarios` de desarrollo, con sus siete becarios: `cto`, `frontend`, `backend-datos`, `backend-servicios`, `qa-funcional`, `qa-tecnico` y `delivery`. Hoy está solo en el ordenador de Pablo: súbelo aquí para que la oficina en la nube lo use.

Lo que tiene que quedar:

```
plugins/desarrollo/
├── .claude-plugin/plugin.json      # name: "desarrollo"
├── agents/                         # cto.md, frontend.md, backend-datos.md, …
├── skills/becarios/SKILL.md        # el coordinador del flujo
└── reference/                      # proceso.md, notion.md, …
```

Después, añade el plugin a `.claude-plugin/marketplace.json` (en la raíz):

```json
{ "name": "desarrollo", "source": "./plugins/desarrollo", "description": "Departamento de desarrollo: cto, frontend, backend, QA funcional y técnico, y delivery." }
```

Mientras no esté, el skill `encargo` usa un flujo mínimo para las tareas de desarrollo (CTO → frontend y backend → QA en la preview → revisión del CTO → PR). Cuando esté, sigue `skills/becarios/SKILL.md`, pero se para en el PR: en la nube no se despliega a producción.
