---
name: marp-slide-creator
description: Creates and reviews presentation slides using Marp (Markdown-based slide tool). Handles Marp CLI installation check/auto-install, slide creation with proper Marp syntax/themes/image placement, and slide quality review. Saves all slides to ~/slide directory. Use when user says "スライドを作成", "プレゼン資料を作りたい", "Marpでスライドを作って", "スライドをレビューして", "presentation", "create a slide", or "make slides".
compatibility: Requires Node.js for Marp CLI. Saves slides to ~/slide. macOS/Linux/Windows compatible.
metadata:
  category: productivity
  tags: [marp, presentation, slides, markdown]
---

# Marp Slide Creator

Create and review Markdown-based presentations using Marp. All slides are saved to `~/slide/`.

## Critical Rules

- Always save slide files to `~/slide/` (create the directory if it doesn't exist)
- File extension must be `.md`
- Every Marp slide file must start with the front matter block containing `marp: true`
- Always check Marp CLI installation before any operation
- When reviewing, provide actionable, specific feedback

---

## Phase 1: Environment Check

Before creating or reviewing slides, verify Marp CLI is available.

### Check Installation

```bash
marp --version
```

If the command fails:

```bash
# Check if Node.js is available
node --version
npm --version
```

### Install Marp CLI (if missing)

```bash
npm install -g @marp-team/marp-cli
```

If npm is unavailable, inform the user:
> "Node.js/npm is required to install Marp CLI. Please install Node.js from https://nodejs.org and re-run."

### Verify Installation

```bash
marp --version
```

Confirm version output before proceeding.

---

## Phase 2: Determine Mode

Based on user request, choose the appropriate mode:

- **Create mode**: User wants to make a new slide deck
- **Review mode**: User wants feedback on an existing `.md` file in `~/slide/`

---

## Phase 3: Create Mode

### Step 1: Gather Slide Requirements

Ask or infer from the user:
- Topic / title
- Approximate number of slides
- Target audience (technical, business, general)
- Theme preference (`default`, `gaia`, `uncover`) — default to `default` if unspecified

### Step 2: Determine File Name

Use a descriptive kebab-case filename. Example: `intro-to-kubernetes.md`

Confirm with the user if unclear.

### Step 3: Ensure Save Directory Exists

```bash
mkdir -p ~/slide
```

### Step 4: Write the Slide File

Save to `~/slide/<filename>.md`.

**Required structure for every file:**

```markdown
---
marp: true
theme: default
paginate: true
---

# Slide Title

Speaker notes or intro text

---

## Slide 2 Title

Content here

---
```

**Slide construction guidelines:**

- Separate each slide with `---` on its own line
- Keep each slide focused on one idea (max 5–7 bullet points)
- Use `# H1` for title slides, `## H2` for section headers, `### H3` for sub-sections
- Use `<!-- _class: lead -->` for visually emphasized slides (centered, large text)
- For background images: see `references/marp-images.md`
- For theme options and directives: see `references/marp-themes.md`
- For full syntax reference: see `references/marp-syntax.md`

### Step 5: Confirm File Written

After writing the file, confirm:
> "スライドを `~/slide/<filename>.md` に保存しました。"

Show the user the first few slides as a preview in the response.

---

## Phase 4: Review Mode

### Step 1: Load the File

Read the specified `.md` file from `~/slide/`.

If the user doesn't specify a filename, list files in `~/slide/`:

```bash
ls ~/slide/*.md
```

Ask the user which file to review.

### Step 2: Review Checklist

Evaluate the slide file against the following criteria:

**Structure:**
- [ ] Front matter has `marp: true`
- [ ] Slides are separated by `---`
- [ ] Each slide has a clear heading
- [ ] No single slide is overloaded (more than 7 bullets or very long paragraphs)

**Content:**
- [ ] Title slide is present
- [ ] Logical flow between slides
- [ ] Consistent terminology throughout
- [ ] No typos or obvious grammatical errors

**Marp Syntax:**
- [ ] Directives are correctly formatted (`<!-- directive: value -->`)
- [ ] Theme is specified
- [ ] Images use correct Marp syntax (see `references/marp-images.md`)
- [ ] No broken or missing image paths

**Readability:**
- [ ] Slide text is concise (not wall-of-text)
- [ ] Headings are meaningful
- [ ] Code blocks use proper fencing with language hints (` ```python `)

### Step 3: Provide Feedback

Structure feedback as:

```
## レビュー結果: <filename>

### 良い点
- ...

### 改善提案
1. [スライドX] 問題の説明 → 具体的な修正案
2. [スライドY] 問題の説明 → 具体的な修正案

### Marp構文の問題
- (あれば記載)

### 総評
(全体的な評価と優先度の高い修正点)
```

Ask the user if they want you to apply any of the suggested fixes directly.

---

## Troubleshooting

See `references/troubleshooting.md` for common issues including:
- Slides not rendering in Marp preview
- Theme not applying
- Images not displaying
- CLI errors
