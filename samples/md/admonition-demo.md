---
title: "Admonition Demo"
theme:
  mode: "light"
  colors:
    light:
      primary: "#2563eb"
      secondary: "#6b7280"
      background: "#ffffff"
      surface: "#f8f9fa"
      text: "#1a1a1a"
      "text-secondary": "#6c757d"
    dark:
      primary: "#60a5fa"
      secondary: "#9ca3af"
      background: "#1a1a1a"
      surface: "#2a2a2a"
      text: "#ffffff"
      "text-secondary": "#9ca3af"
---

# Admonition Demo

This document demonstrates the new callout/admonition feature.

## Basic Examples

> [!NOTE]: Important Context
> This sets up why the topic matters. You can include **bold text**, *italic text*, and even `code` in the body.

> [!TIP]: Key Insight
> Keep your hero slide short and visual. Use bullet points for better readability:
> - Point 1
> - Point 2 with **emphasis**
> - Point 3

> [!WARN]: Risk & Mitigation
> We have 2 weeks of runway; cut scope B. Here's what could happen:
> - Timeline slippage
> - Resource constraints
> - Quality issues

> [!QUOTE]: Customer Voice
> "This shaved 30 minutes off every shift and improved our team's morale significantly."

## Advanced Features

### Nested Content

> [!TIP]: Complex Content
> You can include various Markdown elements:
>
> ```javascript
> function example() {
>   console.log("Hello, World!");
> }
> ```
>
> | Feature | Status |
> |---------|--------|
> | Tables | ✅ |
> | Code | ✅ |
> | Lists | ✅ |

### Theme Compatibility

> [!NOTE]: Theme Awareness
> These callouts automatically adapt to light and dark themes. Try toggling the theme with the **T** key to see the difference.

## Regular Blockquotes Still Work

> This is a regular blockquote without the [!TAG]: syntax. It renders as normal text without any special styling.

## All Variants Together

> [!NOTE]: General Information
> Use this for general notes and context.

> [!TIP]: Helpful Advice
> Use this for tips and best practices.

> [!WARN]: Important Warnings
> Use this for risks and important cautions.

> [!QUOTE]: Testimonials
> Use this for customer quotes and testimonials.
