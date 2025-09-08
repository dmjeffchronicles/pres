## Authoring presentations

Create decks in JSON or Markdown (Markdown uses JSON front matter). Keep IDs unique. Required: `title`, `sections`.

### Minimal JSON
```json
{
  "title": "My Presentation",
  "sections": [
    {
      "id": "intro",
      "title": "Introduction",
      "content": [
        { "type": "paragraph", "value": "Welcome!" }
      ]
    }
  ]
}
```

### Minimal Markdown
````markdown
```json frontmatter
{ "title": "My Presentation" }
```

## Introduction {#intro}
Welcome!
````

### Sections and subsections
- **Section**: `{ id, title, content, subsections? }`
- **Subsection**: `{ id, title, content }`
- In Markdown, add IDs via `{#your-id}` on headings; use `###` for subsections.

### Content blocks (JSON)
- **paragraph**: `{ "type": "paragraph", "value": "text" }`
- **image**: `{ "type": "image", "value": { "src": "https://...", "alt": "...", "caption?": "..." } }`
- **mermaid**: `{ "type": "mermaid", "value": "diagram text" }`
- **kpi-grid**: `{ "type": "kpi-grid", "value": [ { "label": "...", "value": "..." } ] }`
- **blockquote**: `{ "type": "blockquote", "value": { "text": "...", "cite?": "..." } }`
- **glossary**: `{ "type": "glossary" }` (placeholder renders glossary list)

Markdown equivalents:
- Diagrams: code fence ` ```mermaid ... ``` `
- KPI grid: code fence ` ```kpi-grid` then a JSON array, end fence
- Glossary list: ` ```glossary ``` ` or inline `[[glossary]]`
- Admonitions: blockquote with first line `[!NOTE|TIP|WARN|QUOTE]: Heading`

### Optional features
- **Theme** (both palettes required; mode toggles at runtime):
```json
"theme": {
  "mode": "light",
  "colors": {
    "light": { "primary": "#2563eb", "secondary": "#6b7280", "background": "#ffffff", "surface": "#f8f9fa", "text": "#1a1a1a", "text-secondary": "#6c757d" },
    "dark":  { "primary": "#60a5fa", "secondary": "#9ca3af", "background": "#1a1a1a", "surface": "#2a2a2a", "text": "#ffffff", "text-secondary": "#9ca3af" }
  }
}
```
- **Mermaid config** (whitelisted keys only: `flowchart`, `sequence`, `gantt`, `pie`, `themeVariables`; plus `theme`, `fontFamily`). `htmlLabels` disabled; strict security:
```json
"mermaid": {
  "config": {
    "flowchart": { "curve": "basis" },
    "sequence": { "diagramMarginX": 60, "diagramMarginY": 20 },
    "gantt": { "barHeight": 32 },
    "pie": { "textPosition": 0.75 },
    "themeVariables": { "primaryColor": "#2563eb" }
  },
  "perChartDefaults": { "flowchart": { "useMaxWidth": true } }
}
```
- **Navigation** (custom order):
```json
"navigation": { "mode": "ordered", "order": ["intro", "strategy", "results", "conclusion"] }
```
- **Hero** (landing block):
```json
"hero": {
  "title": "Executive Summary 2024",
  "subtitle": "Strategic insights",
  "highlights": [ { "metric": "Revenue", "value": "$2.5M", "label": "Q4" } ],
  "callToActions": [ { "text": "View Details", "link": "#strategy", "primary": true } ]
}
```
- **Glossary** (tooltips + list):
```json
"glossary": [ { "term": "KPI", "definition": "Key Performance Indicator" } ]
```
Use `[[glossary]]` or a ` ```glossary` code block to render the list.

### Validate and view
- Validate against `schema.json`.
- Open `index.html` in a browser and upload your `.json` or `.md` file.


