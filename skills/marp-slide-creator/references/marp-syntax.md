# Marp Syntax Reference

## Front Matter

Every Marp file must begin with a YAML front matter block:

```markdown
---
marp: true
theme: default
paginate: true
size: 16:9
---
```

### Common Front Matter Options

| Key | Values | Description |
|-----|--------|-------------|
| `marp` | `true` | Required. Enables Marp rendering. |
| `theme` | `default`, `gaia`, `uncover` | Slide theme |
| `paginate` | `true` / `false` | Show page numbers |
| `size` | `16:9`, `4:3`, `A4` | Slide aspect ratio |
| `header` | any string | Header text on all slides |
| `footer` | any string | Footer text on all slides |
| `backgroundColor` | color code | Background color for all slides |
| `color` | color code | Text color for all slides |

---

## Slide Separator

Use `---` on its own line to separate slides:

```markdown
---
marp: true
---

# Slide 1

Content here

---

## Slide 2

More content
```

---

## Directives

Directives control presentation behavior. They go inside HTML comment tags.

### Global Directives (affect all slides)

Place at the top of the file or in front matter:

```markdown
<!-- theme: gaia -->
<!-- paginate: true -->
<!-- header: My Presentation -->
<!-- footer: © 2024 My Company -->
```

### Local Directives (affect only the current slide)

Prefix the directive with `_`:

```markdown
---
<!-- _class: lead -->

# This slide uses the "lead" class
```

```markdown
---
<!-- _backgroundColor: #1a1a2e -->
<!-- _color: white -->

## Dark Slide
```

### Common Classes

| Class | Effect |
|-------|--------|
| `lead` | Centered large text, suitable for title slides |
| `invert` | Inverts theme colors |

---

## Headings and Text

Standard Markdown headings:

```markdown
# H1 — Main title (use on title/section slides)
## H2 — Slide title
### H3 — Sub-section header
```

Bold, italic, code:

```markdown
**bold text**
*italic text*
`inline code`
```

---

## Lists

Bullet lists:

```markdown
- Item one
- Item two
  - Nested item
```

Numbered lists:

```markdown
1. First step
2. Second step
3. Third step
```

---

## Code Blocks

Always specify a language for syntax highlighting:

````markdown
```python
def hello():
    print("Hello, Marp!")
```
````

````markdown
```bash
npm install -g @marp-team/marp-cli
```
````

---

## Tables

```markdown
| Column A | Column B | Column C |
|----------|----------|----------|
| Value 1  | Value 2  | Value 3  |
| Value 4  | Value 5  | Value 6  |
```

---

## Links

```markdown
[Link text](https://example.com)
```

Note: Clickable links only work in HTML export, not PDF.

---

## Horizontal Rule (within a slide)

Use `***` to draw a visible divider within a slide (not a slide separator):

```markdown
## My Slide

Content above

***

Content below
```

---

## Comments (Speaker Notes)

HTML comments not used as directives become speaker notes:

```markdown
## My Slide

Slide content here

<!-- Speaker note: Mention the key findings here -->
```

---

## Math (KaTeX)

Inline math: `$E = mc^2$`

Block math:

```markdown
$$
\sum_{i=1}^{n} x_i = \frac{n(n+1)}{2}
$$
```
