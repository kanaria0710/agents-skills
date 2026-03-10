---
name: gas-modular-method-files
description: Google Apps Script (GAS) implementation and operations with clasp using a modular layout where each top-level method is split into its own .gs file instead of a single Code.js. Use when creating new Spreadsheet-bound projects, attaching to existing Spreadsheets, cloning existing scripts, pulling/pushing updates, checking logs, and refactoring GAS into per-method files. If requirements are ambiguous or incomplete, use $gas-script-requirements-ja first to produce an implementation-ready requirements spec before applying this skill.
---

# GAS Modular Method Files

Build and operate GAS projects with one top-level function per file. Avoid monolithic `Code.js` and keep a `clasp`-friendly layout across create/clone/pull/push/log workflows.

## Quick Start

Before implementing methods, if requirements are ambiguous, run `$gas-script-requirements-ja` first and finalize a requirements spec.

1. Choose project lifecycle path:
   - New Spreadsheet-bound project
   - Existing Spreadsheet-bound project
   - Clone existing script project
2. Ensure clasp is installed, then check version against npm latest.
3. Ensure source uses split files (`methods/`, `services/`, `utils/`).
4. Sync with `clasp pull` before major edits.
5. Push with `clasp push` after duplicate-function and manifest checks.

Suggested structure:

```text
src/
  appsscript.json
  methods/
    do-get.gs
    do-post.gs
    on-open.gs
  services/
    sheet-service.gs
  utils/
    date-utils.gs
```

## Clasp Lifecycle Workflow

### 1) New Spreadsheet-bound project

Run:

```bash
clasp create --type sheets --title "<project-title>" --rootDir src
```

Then implement methods in split files under `src/`.

### 2) Check clasp version

Run:

```bash
./scripts/clasp_project_ops.sh check-version
```

Install automatically when missing:

```bash
./scripts/clasp_project_ops.sh check-version --install-if-missing
```

Use `--strict` when you want CI/automation to fail if latest cannot be verified or update is needed.

### 3) Existing Spreadsheet-bound project

Run:

```bash
clasp create --type sheets --title "<project-title>" --parentId "<spreadsheet-id>" --rootDir src
```

Use this when attaching script to an already existing Spreadsheet.

### 4) Clone existing script project

Run:

```bash
clasp clone "<script-id>" --rootDir src
```

After clone, refactor to per-method files if needed.

### 5) Pull, Push, Logs

- Pull latest remote:

```bash
clasp pull
```

- Push local changes:

```bash
clasp push
```

- Force push when manifest conflicts must be intentionally overwritten:

```bash
clasp push --force
```

- Check logs:

```bash
clasp logs --watch --simplified
```

### 6) Useful status commands

- List push targets:

```bash
clasp status
```

- List scripts:

```bash
clasp list
```

## File Split Workflow

### 1) Plan the file map

- List required methods from the task.
- Decide folder placement:
  - `methods/`: entry points and externally invoked functions
  - `services/`: domain logic (Sheets, Drive, Gmail, etc.)
  - `utils/`: pure helper functions and formatting helpers
- Keep global function names unique across all `.gs` files.

### 2) Implement per-method files

- Put exactly one public top-level function in each entry-point file.
- Allow private helpers in the same file only when tightly coupled.
- Move reused logic to `services/` or `utils/`.
- Prefer explicit dependency flow (`methods -> services -> utils`).

### 3) Keep manifest aligned

- Update `appsscript.json` scopes and runtime settings when APIs change.
- Preserve existing deployment settings unless explicitly asked to change them.

### 4) Validate before push

- Check for duplicate function names.
- Ensure no accidental `Code.js` catch-all file is introduced.
- Run `clasp status` before `clasp push`.

## Conventions

- Naming:
  - Function: `camelCase` (GAS standard)
  - File: `kebab-case.gs` derived from function name
- Entry-point signatures:
  - Web app handlers: `function doGet(e) {}` / `function doPost(e) {}`
  - Trigger handlers: `function onOpen(e) {}` etc.
- Design rules:
  - Keep side effects near service layer.
  - Keep utility layer side-effect free.
  - Keep each file short and single-purpose.

## Use Bundled Resources

- Use `scripts/new_method_file.sh` to scaffold a new method file quickly.
- Use `$gas-script-requirements-ja` to clarify script requirements before scaffolding when requirements are incomplete or ambiguous.
- Use `scripts/clasp_project_ops.sh` for repeatable clasp lifecycle operations.
- Read `references/gas-modular-layout.md` for layout and split-pattern examples.
- Read `references/clasp-lifecycle.md` for create/clone/pull/push/log operation recipes.

Scaffold example:

```bash
./scripts/new_method_file.sh doGet --dir src/methods
./scripts/new_method_file.sh createReport --dir src/methods
```

Clasp ops example:

```bash
./scripts/clasp_project_ops.sh create-new-sheets --title "Sales Tool" --root-dir src --print-only
./scripts/clasp_project_ops.sh create-existing-sheets --title "Sales Tool" --parent-id "SPREADSHEET_ID" --root-dir src --print-only
./scripts/clasp_project_ops.sh clone --script-id "SCRIPT_ID" --root-dir src --print-only
./scripts/clasp_project_ops.sh install-clasp --print-only
./scripts/clasp_project_ops.sh check-version --print-only
./scripts/clasp_project_ops.sh check-version --install-if-missing --print-only
./scripts/clasp_project_ops.sh pull --print-only
./scripts/clasp_project_ops.sh push --watch --print-only
./scripts/clasp_project_ops.sh logs --watch --simplified --print-only
```
