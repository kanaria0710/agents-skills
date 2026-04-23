# Marp Themes Reference

## Built-in Themes

Marp CLI includes three built-in themes:

### 1. `default`

- Clean white background
- Dark text
- Suitable for: general business, technical presentations
- Best for: most use cases

```markdown
---
marp: true
theme: default
---
```

### 2. `gaia`

- Blue gradient background
- Colorful accents
- Suitable for: marketing, product showcases, modern business
- Classes available: `lead`, `invert`

```markdown
---
marp: true
theme: gaia
---
```

### 3. `uncover`

- Minimal white background with strong typography
- Red accent color
- Suitable for: academic, research, minimal presentations

```markdown
---
marp: true
theme: uncover
---
```

---

## Theme + Class Combinations

### Title Slide (lead class)

```markdown
---
marp: true
theme: gaia
---

<!-- _class: lead -->

# My Presentation Title

## Subtitle here

Author Name | 2024
```

### Inverted Slide

```markdown
---
<!-- _class: invert -->

## This slide has inverted colors
```

---

## Global vs. Local Color Overrides

### Global (all slides)

Set in front matter:

```markdown
---
marp: true
theme: default
backgroundColor: "#f0f4f8"
color: "#2d3748"
---
```

### Local (single slide)

```markdown
---
<!-- _backgroundColor: "#1a202c" -->
<!-- _color: "#ffffff" -->

## Dark Slide

This one slide has a dark background.
```

---

## Pagination Styling

```markdown
---
marp: true
paginate: true
---
```

To hide page number on a specific slide:

```markdown
---
<!-- _paginate: false -->

# Title Slide (no page number)
```

---

## Header and Footer

### Global

```markdown
---
marp: true
header: "My Company | Confidential"
footer: "© 2024 My Company"
---
```

### Local override

```markdown
---
<!-- _header: "" -->
<!-- _footer: "Special Footer for this slide" -->
```

---

## Custom Themes (Advanced)

Custom themes are written in CSS and loaded via CLI:

```bash
marp --theme ./my-theme.css slides.md
```

Or reference in front matter when using a local theme file:

```markdown
---
marp: true
theme: my-custom-theme
---
```

Custom theme CSS must start with:

```css
/* @theme my-custom-theme */

section {
  background: #fff;
  font-family: 'Helvetica Neue', sans-serif;
}

section.lead {
  background: #003366;
  color: white;
}
```

---

## Theme Selection Guide

| Scenario | Recommended Theme |
|----------|------------------|
| Technical talk / engineering | `default` |
| Business / marketing | `gaia` |
| Academic / research | `uncover` |
| Minimalist style | `uncover` |
| Colorful / modern | `gaia` |
| Custom branding | Custom CSS |
