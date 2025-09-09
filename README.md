## Narrative Presentation System

A clean, offline-first presentation system that turns JSON or Markdown into interactive web presentations with rich formatting, Mermaid diagrams, glossary tooltips, and a built-in table of contents.

### Highlights
- **Offline-first**: Works locally in your browser, no servers or tracking
- **Dual format**: **JSON** and **Markdown** (with JSON front matter)
- **Self-contained**: Embed presentation directly in HTML for single-file distribution
- **Mermaid support**: Flowchart, sequence, gantt, pie
- **Glossary tooltips**: Hover over terms to see definitions
- **Keyboard controls**: Navigate with arrows/space; toggle theme, fullscreen, and TOC
- **Multilingual landing UI**: English and French

---

### Quick Start
1. Download or clone this repository
2. Open `index.html` in any modern browser
3. Click "Select File" and choose a `.json` or `.md` presentation file

**For self-contained presentations:** Edit `index.html` and add your Markdown content inside the `<script type="text/markdown" id="presentation-md">` block or JSON content inside `<script type="application/json" id="presentation-json">`. The presentation will render automatically without the landing page.

All rendering happens locally in your browser. External links open in a new tab with `rel="noopener"`.

Note: Loading via URL parameters (e.g., `?md=...`, `?data=...`) is not supported in this build—use the file picker.

---

### Building Standalone Presentations

For distribution, use the provided bundler scripts to create fully self-contained HTML files:

#### Linux/macOS
```bash
./scripts/build-standalone.sh path/to/source.md dist/presentation.html
./scripts/build-standalone.sh path/to/source.json dist/presentation.html
# Optional: custom template
./scripts/build-standalone.sh source.md dist/out.html path/to/template.html
```

#### Windows (PowerShell)
```powershell
./scripts/build-standalone.ps1 -Input .\source.md -Output .\dist\presentation.html
./scripts/build-standalone.ps1 -Input .\source.json -Output .\dist\presentation.html
# Optional: custom template
./scripts/build-standalone.ps1 -Input .\source.md -Output .\dist\out.html -Template .\custom-template.html
```

These scripts automatically:
- Inline all vendor assets (`pico.min.css`, `mermaid.min.js`, `marked.min.js`)
- Inject your presentation content
- Escape any `</script>` sequences to prevent HTML parsing issues
- Remove export UI elements if present in the template

The resulting HTML file works completely offline and contains everything needed.

---

### Controls and Shortcuts
- **Upload**: `Ctrl+U` (Windows/Linux) — open file picker
- **Theme**: `T` — toggle Light/Dark
- **Fullscreen**: `F` — enter/exit fullscreen
- **TOC**: `H` — show/hide table of contents
- **Navigation**: `←/→` or `↑/↓` or `Space` — move between sections; `Home`/`End` to jump
- On-screen buttons: previous/next, theme, fullscreen, TOC, upload, edit
- **Editor features**: Press `E` to open editor; "Download .md" saves current content as a `.md` file

---

### Viewer UX Features

#### Table of Contents & Navigation
- **Sticky TOC**: Right-hand rail with section/subsection links that stays visible while scrolling
- **Scroll-spy highlighting**: Active section automatically highlighted as you scroll
- **Smooth scrolling**: Click TOC links for animated navigation to sections
- **Toggle visibility**: Press `H` or click the TOC button to show/hide the table of contents

#### Progress Tracking
- **Top progress bar**: Visual indicator showing scroll position through the presentation
- **Real-time updates**: Progress bar fills as you scroll through content

#### On-screen Controls
Fixed overlay buttons in the bottom-right corner:
- **Navigation**: Previous/next arrows for section-by-section movement
- **Theme toggle**: Switch between light and dark modes (persists in localStorage)
- **Fullscreen**: Enter presentation mode with `F` key
- **TOC toggle**: Show/hide table of contents
- **File upload**: Quick access to load new presentations

#### Interactive Media
- **Image modals**: Click any image to view it enlarged with caption
- **Diagram modals**: Click Mermaid diagrams to view them in a larger modal
- **External links**: Automatically open in new tabs with security attributes

---

### Authoring Presentations
You can author in either JSON or Markdown. Both map to the same internal structure.

#### Minimal JSON example
```json
{
  "title": "My Presentation",
  "sections": [
    {
      "id": "intro",
      "title": "Introduction",
      "content": [
        { "type": "paragraph", "value": "Welcome to my presentation!" }
      ]
    }
  ]
}
```

#### Theme (light/dark palettes)
Provide a mode and two 6-color palettes. Colors automatically theme the UI and Mermaid diagrams.
```json
{
  "theme": {
    "mode": "light",
    "colors": {
      "light": {
        "primary": "#2563eb",
        "secondary": "#6b7280",
        "background": "#ffffff",
        "surface": "#f8f9fa",
        "text": "#1a1a1a",
        "text-secondary": "#6c757d"
      },
      "dark": {
        "primary": "#60a5fa",
        "secondary": "#9ca3af",
        "background": "#1a1a1a",
        "surface": "#2a2a2a",
        "text": "#ffffff",
        "text-secondary": "#9ca3af"
      }
    }
  }
}
```
Mode supports `light` or `dark` and can be toggled at runtime with `T`.

**Theme Requirements & Behavior:**
- Both light and dark palettes are required (no auto mode or single-palette themes)
- Runtime theme toggle persists in localStorage
- Colors automatically apply to Mermaid diagrams and all UI elements
- CSS variables are applied globally, including Pico framework defaults

#### Mermaid Configuration
Customize Mermaid diagram rendering with safe, whitelisted configuration options:
```json
{
  "mermaid": {
    "config": {
      "flowchart": { "useMaxWidth": true, "htmlLabels": false, "curve": "basis" },
      "sequence": { "useMaxWidth": true, "htmlLabels": false },
      "themeVariables": {
        "primaryColor": "#2563eb",
        "lineColor": "#2563eb"
      }
    },
    "perChartDefaults": {
      "flowchart": { "useMaxWidth": true },
      "gantt": { "barHeight": 32 }
    }
  }
}
```
- **Whitelisted keys**: Only `theme`, `fontFamily`, `flowchart`, `sequence`, `gantt`, `pie`, and `themeVariables` are allowed in `config`
- **Per-chart defaults**: Automatically injected when diagrams lack `%%{init:...}%%` directives
- **Security defaults**: `securityLevel: 'strict'` and `htmlLabels: false` are always enforced

#### Navigation (custom order)
Sections render in document order by default. To enforce a custom order, set:
```json
{
  "navigation": {
    "mode": "ordered",
    "order": ["intro", "strategy", "results", "conclusion"]
  }
}
```

#### Hero section
Create an eye-catching landing section with title, subtitle, highlight metrics, and call-to-action buttons:
```json
{
  "hero": {
    "title": "Executive Summary 2024",
    "subtitle": "Strategic insights and key performance indicators for Q1-Q4",
    "highlights": [
      { "value": "$2.5M", "metric": "Revenue", "label": "Q4 Growth" },
      { "value": "15%", "metric": "Efficiency", "label": "Process Improvement" }
    ],
    "callToActions": [
      { "text": "View Details", "link": "#strategy", "primary": true },
      { "text": "Download Report", "link": "/reports/q4.pdf", "primary": false }
    ]
  }
}
```
Hero sections work in both JSON and Markdown front matter. Primary CTAs get accent styling; external links automatically open in new tabs.

#### Content block types
- **paragraph**: plain text; Markdown-style links like `[text](url)` are auto-linked
- **image**: `{ "src": "...", "alt": "...", "caption": "..." }`
- **mermaid**: string diagram definition
- **kpi-grid**: array of `{ "label": "...", "value": "..." }`
- **blockquote**: `{ "text": "...", "cite": "..." }`
- **glossary**: placeholder that renders the glossary list

Example:
```json
{
  "type": "kpi-grid",
  "value": [ { "label": "Revenue", "value": "$2.5M" } ]
}
```

#### KPI Grid Notes
KPI grids feature responsive design with smart text handling:
- **Container-query sizing**: Value and label text scale fluidly based on card width (7cqi and 3.5cqi units)
- **Two-line clamping**: Values and labels are limited to 2 lines with ellipsis overflow
- **Non-breaking behavior**: Text won't split words or wrap awkwardly
- **Fallback support**: Graceful degradation when container queries aren't supported by the browser

#### Markdown authoring
Start your `.md` with a JSON front matter block, then write sections with `##` and subsections with `###`.
```markdown
```json frontmatter
{
  "title": "My Presentation",
  "theme": {
    "mode": "light",
    "colors": {
      "light": {
        "primary": "#2563eb",
        "secondary": "#6b7280",
        "background": "#ffffff",
        "surface": "#f8f9fa",
        "text": "#1a1a1a",
        "text-secondary": "#6c757d"
      },
      "dark": {
        "primary": "#60a5fa",
        "secondary": "#9ca3af",
        "background": "#1a1a1a",
        "surface": "#2a2a2a",
        "text": "#ffffff",
        "text-secondary": "#9ca3af"
      }
    }
  },
  "glossary": [ { "term": "KPI", "definition": "Key Performance Indicator" } ]
}
```

## Introduction {#intro}
Welcome to my presentation!

### Details {#details}
More info here.
```

Special markdown blocks:
- ```mermaid ...``` for diagrams
- ```kpi-grid ...``` for KPI cards (JSON array)
- ```glossary``` to insert the glossary list
- Images with captions: `![Alt text](url "Caption text")`

#### Admonitions in blockquotes
Create callout/admonition boxes in Markdown using blockquotes with a first line in the form `[!KIND]: Heading`, followed by the body on subsequent `>` lines. Supported kinds: `NOTE`, `TIP`, `WARN`, `QUOTE` (case-insensitive).

```markdown
> [!NOTE]: Key concept
> This is highlighted content. It supports full Markdown in the body.
>
> - Lists
> - Links and `code`

> [!TIP]: Pro tip
> Keep sections concise for readability.
```

These render as styled, theme-aware callouts matching Light/Dark mode.

#### Glossary
Define glossary terms in JSON (either in the main JSON, or Markdown front matter). When a defined term appears in your content, it is automatically wrapped with a tooltip on hover. You can also insert the full glossary list anywhere.

Define terms (Markdown front matter example shown above uses the same structure):
```json
{
  "glossary": [
    { "term": "KPI", "definition": "Key Performance Indicator" },
    { "term": "OKR", "definition": "Objectives and Key Results" }
  ]
}
```

Use terms in content (tooltips appear on hover):
```markdown
Our OKR process aligns teams on measurable outcomes. Top KPIs are reviewed monthly.
```

Insert the glossary list in one of two ways:
- Code block:
```glossary
```
- Inline placeholder in a paragraph:
```markdown
[[glossary]]
```

Notes:
- Matching is case-insensitive and skips code blocks and Mermaid diagrams.
- Tooltips are positioned to avoid viewport overflow.

Code blocks are rendered with clean styling; language-specific syntax highlighting is not included.

#### Embedded Presentations
For self-contained, single-file presentations, you can embed your Markdown or JSON directly in `index.html`. The viewer prioritizes JSON over Markdown if both are present.

**Markdown embedding:**
```html
<script type="text/markdown" id="presentation-md"><!--
---
{
  "title": "My Self-Contained Presentation",
  "theme": {
    "mode": "light",
    "colors": {
      "light": {
        "primary": "#2563eb",
        "secondary": "#6b7280",
        "background": "#ffffff",
        "surface": "#f8f9fa",
        "text": "#1a1a1a",
        "text-secondary": "#6c757d"
      },
      "dark": {
        "primary": "#60a5fa",
        "secondary": "#9ca3af",
        "background": "#1a1a1a",
        "surface": "#2a2a2a",
        "text": "#ffffff",
        "text-secondary": "#9ca3af"
      }
    }
  }
}
---

# My Presentation

Content goes here...

## Section {#section}

More content...
--></script>
```

**JSON embedding:**
```html
<script type="application/json" id="presentation-json">
{
  "title": "My Self-Contained Presentation",
  "theme": {
    "mode": "light",
    "colors": {
      "light": {
        "primary": "#2563eb",
        "secondary": "#6b7280",
        "background": "#ffffff",
        "surface": "#f8f9fa",
        "text": "#1a1a1a",
        "text-secondary": "#6c757d"
      },
      "dark": {
        "primary": "#60a5fa",
        "secondary": "#9ca3af",
        "background": "#1a1a1a",
        "surface": "#2a2a2a",
        "text": "#ffffff",
        "text-secondary": "#9ca3af"
      }
    }
  },
  "sections": [
    {
      "id": "intro",
      "title": "Introduction",
      "content": [
        { "type": "paragraph", "value": "Welcome to my presentation!" }
      ]
    }
  ]
}
</script>
```

When this block is present and contains content, the viewer automatically renders it on load. If empty or missing, the landing page appears as usual. This enables:

- **Single-file distribution**: No separate JSON/Markdown files needed
- **Offline portability**: Email or share just the HTML file
- **Version control**: Presentation content lives with the viewer code
- **Easy deployment**: Works on any static hosting (GitHub Pages, etc.)

---

### Samples
See complete examples in `samples/`:
- JSON: `samples/json/technical-documentation.json`, `samples/json/technical-architecture.json`
- Markdown: `samples/md/technical-documentation.md`, `samples/md/executive-summary.md`

---

### Schema Validation
`schema.json` defines the JSON structure used by the viewer. It includes the 6-color light/dark theme palettes, content blocks, sections/subsections, and navigation order. Use it with your editor or preferred JSON schema validator.

---

### Limitations
- **No syntax highlighting**: Code blocks render as plain text (no Prism.js or similar)
- **No URL parameter loading**: Cannot load presentations via `?md=...` or `?data=...` URLs
- **Mermaid htmlLabels disabled**: Security restriction prevents HTML in diagram labels
- **Single file uploads only**: No support for presentations split across multiple files

---

### Development
- Main viewer: `index.html`
- Schema: `schema.json`
- Vendor deps (offline): `vendor/`
- Build scripts: `scripts/build-standalone.sh`, `scripts/build-standalone.ps1`
- Examples: `samples/`

Contributions welcome. Open an issue or PR.

### License
MIT License.
