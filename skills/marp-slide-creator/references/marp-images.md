# Marp Image Placement Reference

## Basic Image Syntax

Standard Markdown image (inline, centered):

```markdown
![alt text](./images/photo.png)
```

Size control with alt text:

```markdown
![width:400px](./images/photo.png)
![height:300px](./images/photo.png)
![width:50%](./images/photo.png)
```

---

## Background Images

Marp supports special `bg` keyword in the alt text.

### Full Background

```markdown
![bg](./images/background.jpg)
```

Covers the entire slide. Text overlays on top.

### Background with Opacity

```markdown
![bg opacity:0.3](./images/background.jpg)

## Slide Title

Text is visible over the dimmed background.
```

### Background with Fit

```markdown
![bg fit](./images/diagram.png)
```

Scales the image to fit within the slide without cropping.

### Background with Cover (default)

```markdown
![bg cover](./images/photo.jpg)
```

Fills the entire background, may crop edges.

### Background with Contain

```markdown
![bg contain](./images/logo.png)
```

Scales to fit entirely within background area with padding.

---

## Split Layouts with Background Images

### Left Split (image left, content right)

```markdown
![bg left](./images/photo.jpg)

## Slide Title

Content appears on the right side.

- Bullet point
- Another point
```

### Right Split (image right, content left)

```markdown
![bg right](./images/photo.jpg)

## Slide Title

Content appears on the left side.
```

### Custom Split Ratio

```markdown
![bg left:40%](./images/photo.jpg)

## Slide Title

Image takes 40% of the width, content takes 60%.
```

```markdown
![bg right:30%](./images/photo.jpg)

## Slide Title

Image is 30% wide on the right.
```

---

## Multiple Background Images

Stack multiple images side by side:

```markdown
![bg](./images/photo1.jpg)
![bg](./images/photo2.jpg)
![bg](./images/photo3.jpg)
```

Three images appear side by side across the full background.

---

## Image Filters

Apply CSS-like filters to background images:

```markdown
![bg blur:5px](./images/background.jpg)

## Frosted Glass Effect
```

```markdown
![bg brightness:0.5](./images/photo.jpg)

## Dark Background
```

```markdown
![bg grayscale](./images/photo.jpg)

## Black and White Background
```

Combine filters:

```markdown
![bg blur:3px brightness:0.6](./images/photo.jpg)
```

---

## Remote Images

Use URLs for remote images:

```markdown
![bg](https://example.com/image.jpg)
```

Note: Requires network access. Local images are more reliable.

---

## Best Practices

1. **Use `left` or `right` split for content slides** — keeps text readable without needing text shadows
2. **Use `opacity` when placing text over busy photos** — `opacity:0.3` or `opacity:0.4` usually works
3. **Keep images in `./images/` relative to the slide file** for portability
4. **Prefer vector images (SVG) for diagrams** — they scale without blur
5. **Test image paths** — Marp resolves paths relative to the `.md` file location

---

## Common Image Layout Patterns

### Hero Title Slide

```markdown
<!-- _class: lead -->
![bg](./images/hero.jpg)
![bg opacity:0.5](./images/hero.jpg)

# Presentation Title

## Subtitle
```

### Split Content Slide

```markdown
![bg right:40%](./images/diagram.png)

## How It Works

1. Step one
2. Step two
3. Step three
```

### Full-Bleed Photo Slide

```markdown
<!-- _class: lead invert -->
![bg](./images/photo.jpg)
![bg opacity:0.6](./images/photo.jpg)

# Key Message Here
```
