# Narrative Presentation System

A clean, offline-first presentation system that transforms JSON into interactive web presentations. Perfect for business presentations, documentation, or storytelling with rich content blocks.

## 🚀 Quick Start

1. **Download** the latest release zip file
2. **Extract** all files to a folder
3. **Edit** `presentation.json` with your content
4. **Open** `index.html` in any modern web browser

That's it! Your presentation is ready to use offline.

## 📋 File Structure

```
presentation-system/
├── index.html          # Main presentation viewer
├── presentation.json   # Your presentation content (edit this)
├── schema.json         # JSON schema for validation
├── vendor/             # Offline dependencies
│   ├── pico.min.css    # CSS framework
│   └── mermaid.min.js  # Diagram rendering
└── samples/            # Example presentations
    ├── business-analytics.json
    └── innovation-roadmap.json
```

## 🎨 Creating Your Presentation

Edit `presentation.json` following the schema in `schema.json`. Here's a minimal example:

```json
{
  "title": "My Presentation",
  "sections": [
    {
      "id": "intro",
      "title": "Introduction",
      "content": [
        {
          "type": "paragraph",
          "value": "Welcome to my presentation!"
        }
      ]
    }
  ]
}
```

### Content Block Types

| Type | Description | Example |
|------|-------------|---------|
| `paragraph` | Plain text with glossary highlighting | `"Welcome to our company"` |
| `image` | Image with caption | `{"src": "chart.png", "alt": "Sales chart", "caption": "Q4 Performance"}` |
| `mermaid` | Diagrams (flowcharts, sequences, etc.) | `"graph TD; A-->B;"` |
| `kpi-grid` | Key performance indicators | `[{"label": "Revenue", "value": "$2.5M"}]` |
| `blockquote` | Pull quotes | `{"text": "Great quote", "cite": "Author"}` |
| `glossary` | Auto-generated term list | `{}` |

### Theme Customization

Customize colors with the 6-color theme system:

```json
{
  "theme": {
    "mode": "auto",
    "colors": {
      "primary": "#your-brand-blue",
      "secondary": "#neutral-gray",
      "background": "#page-bg",
      "surface": "#card-bg",
      "text": "#main-text",
      "text-secondary": "#muted-text"
    }
  }
}
```

### Navigation Order

Control section order with custom navigation:

```json
{
  "navigation": {
    "order": ["intro", "strategy", "results", "conclusion"]
  }
}
```

### External Links

Add external links that open in new tabs:

```json
{
  "hero": {
    "callToActions": [
      {
        "text": "Visit Website",
        "link": "https://example.com",
        "primary": true
      }
    ]
  }
}
```

External URLs (starting with `http://` or `https://`) automatically open in new tabs with proper security attributes.

### Links in Content

Add clickable links within your paragraph text using markdown syntax:

```json
{
  "sections": [
    {
      "id": "about",
      "title": "About Us",
      "content": [
        {
          "type": "paragraph",
          "value": "Visit our [company website](https://example.com) to learn more about our services."
        }
      ]
    }
  ]
}
```

Links are automatically detected and formatted with proper external link handling.

### Hero Section

Add a compelling introduction:

```json
{
  "hero": {
    "title": "Executive Summary",
    "subtitle": "Key insights and recommendations",
    "callToActions": [
      {
        "text": "View Details",
        "link": "#strategy",
        "primary": true
      }
    ]
  }
}
```

### Glossary

Define terms for automatic highlighting:

```json
{
  "glossary": [
    {
      "term": "KPI",
      "definition": "Key Performance Indicator"
    }
  ]
}
```

## 🎯 Features

- **Offline-first**: Works without internet connection
- **Responsive**: Adapts to any screen size
- **Themeable**: 6-color customization system
- **Interactive**: Mermaid diagrams, glossary tooltips
- **Accessible**: Keyboard navigation, screen reader support
- **Fast**: No build process, pure HTML/CSS/JS

## 🔧 Schema Validation

The included `schema.json` validates your presentation structure. Use it with:

- VS Code JSON extensions
- Online JSON validators
- Your preferred JSON schema validator

## 📝 Examples

Check the `samples/` folder for complete examples:

- **Business Analytics**: Financial dashboard with KPIs
- **Innovation Roadmap**: Timeline with Mermaid diagrams

## 🎨 Customization

### Colors
Edit the `colors` object in your JSON to match your brand.

### Layout
The system uses Pico CSS for clean, minimal styling.

### Diagrams
Mermaid.js supports flowcharts, sequences, Gantt charts, and more.

## 🛠️ Development

To modify the presentation system:

1. Edit `index.html` for layout changes
2. Update `schema.json` for new features
3. Test with sample presentations

## 📄 License

MIT License - see LICENSE file for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with sample presentations
5. Submit a pull request

---

**Built with:** HTML5, CSS3, JavaScript ES6+, Mermaid.js, Pico CSS
