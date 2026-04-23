# Marp Troubleshooting Guide

## Installation Issues

### `marp: command not found`

**Cause**: Marp CLI not installed or not in PATH.

**Fix**:
```bash
npm install -g @marp-team/marp-cli
```

After install, restart terminal or run:
```bash
export PATH="$(npm bin -g):$PATH"
```

---

### `npm: command not found`

**Cause**: Node.js is not installed.

**Fix**: Install Node.js from https://nodejs.org (LTS version recommended).

Verify after install:
```bash
node --version
npm --version
```

---

### Permission error during npm install (macOS/Linux)

**Cause**: Global npm directory requires elevated permissions.

**Fix** (avoid sudo when possible):
```bash
# Option 1: Use npx instead of global install
npx @marp-team/marp-cli --version

# Option 2: Change npm global prefix
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
export PATH=~/.npm-global/bin:$PATH
npm install -g @marp-team/marp-cli
```

---

## Rendering Issues

### Slides not rendering / Marp syntax not recognized

**Cause**: Missing `marp: true` in front matter.

**Fix**: Ensure the file starts with:
```markdown
---
marp: true
---
```

---

### Theme not applying

**Cause 1**: Theme name is misspelled.

Valid theme names: `default`, `gaia`, `uncover`

**Cause 2**: Custom theme file path is wrong.

**Fix**:
```markdown
---
marp: true
theme: gaia
---
```

---

### Slides merging / `---` not working as separator

**Cause**: The `---` is not on its own line, or has trailing spaces.

**Fix**: Ensure `---` has no leading/trailing spaces:
```markdown
Slide content here

---

Next slide content
```

---

## Image Issues

### Image not displaying

**Cause 1**: Incorrect relative path.

Images are resolved relative to the `.md` file location.

**Fix**: If the slide is at `~/slide/my-presentation.md`, place images at `~/slide/images/photo.jpg` and reference as:
```markdown
![](./images/photo.jpg)
```

**Cause 2**: File extension case mismatch (e.g., `.JPG` vs `.jpg`).

**Fix**: Rename the file to lowercase extension.

---

### Background image appears but text is unreadable

**Cause**: Image too bright/busy behind text.

**Fix**: Add opacity:
```markdown
![bg opacity:0.3](./images/background.jpg)

## Now text is readable
```

---

### `![bg left]` not splitting correctly

**Cause**: Multiple `---` or malformed front matter.

**Fix**: Verify only one `---` separator between slides. Check for extra whitespace.

---

## Directive Issues

### Directive not taking effect

**Cause**: Directive syntax error.

**Correct format**:
```markdown
<!-- paginate: true -->
<!-- _class: lead -->
```

Common mistakes:
```markdown
<!-- paginate:true -->        ❌ Missing space after colon
<!— paginate: true —>        ❌ Wrong dash character
// paginate: true             ❌ Wrong comment syntax
```

---

### Local directive affecting multiple slides

**Cause**: Used global directive (`paginate`) instead of local (`_paginate`).

**Fix**: Prefix local directives with `_`:
```markdown
<!-- _paginate: false -->    ✅ Only affects this slide
<!-- paginate: false -->     ❌ Affects all subsequent slides
```

---

## File Issues

### File not found when opening

**Cause**: File not saved to correct location.

**Fix**: All slides must be in `~/slide/`. Confirm:
```bash
ls ~/slide/
```

---

### Front matter not parsed correctly

**Cause**: YAML syntax error in front matter.

Common issues:
- Unquoted special characters
- Incorrect indentation
- Missing closing `---`

**Fix**:
```markdown
---
marp: true
theme: default
header: "My Presentation: 2024"   # quote strings with colons
---
```

---

## VS Code / Preview Issues

### Marp extension not previewing

**Cause**: Marp for VS Code extension not installed, or `marp: true` missing.

**Fix**:
1. Install "Marp for VS Code" extension
2. Add `marp: true` to front matter
3. Use `Ctrl+Shift+V` (or `Cmd+Shift+V`) to open preview

---

### Preview shows raw Markdown instead of slides

**Cause**: Using default Markdown preview instead of Marp preview.

**Fix**: Use command palette → "Marp: Open Preview to the Side"
