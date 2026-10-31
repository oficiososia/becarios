# Departamento de desarrollo

Aquí va el plugin `becarios` de desarrollo. Tiene nueve becarios: `cto`, `diseno`, `frontend`, `backend-datos`, `backend-servicios`, `ia-automatizacion`, `qa-funcional`, `qa-tecnico` y `delivery`.

Ya están aquí los dos nuevos: `agents/diseno.md` (Diseño UX/UI) y `agents/ia-automatizacion.md` (IA y automatizaciones). Los otros siete están solo en el ordenador de Pablo: súbelos a `agents/`, junto a estos, para que la oficina en la nube los use.

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
{ "name": "desarrollo", "source": "./plugins/desarrollo", "description": "Departamento de desarrollo: cto, diseño UX/UI, frontend, backend, IA y automatizaciones, QA funcional y técnico, y delivery." }
```

Mientras no esté, el skill `encargo` usa un flujo mínimo para las tareas de desarrollo (CTO → diseño si hay interfaz → frontend, backend e IA → QA en la preview → revisión del CTO → PR). Cuando esté, sigue `skills/becarios/SKILL.md`, pero se para en el PR: en la nube no se despliega a producción.
