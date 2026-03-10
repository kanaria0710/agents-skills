# GAS Modular Layout Reference

## Purpose

Use this reference when implementing Google Apps Script with split files instead of a single `Code.js`.

## Recommended Directory Layout

```text
src/
  appsscript.json
  methods/
    do-get.gs
    do-post.gs
    on-open.gs
    create-report.gs
  services/
    spreadsheet-service.gs
    mail-service.gs
  utils/
    date-utils.gs
    validation-utils.gs
```

## Layer Responsibilities

- `methods/`: Contain entry points and orchestration only.
- `services/`: Contain API calls and side-effect-heavy logic.
- `utils/`: Contain pure functions and formatters.

## Split Patterns

### Web App Pattern

- `methods/do-get.gs` -> parse query and call service.
- `methods/do-post.gs` -> parse body and call service.
- `services/*` -> business logic and Google service operations.

### Spreadsheet Trigger Pattern

- `methods/on-open.gs` -> add menu, call builder helpers.
- `methods/on-edit.gs` -> route based on edited range.
- `services/sheet-*.gs` -> read/write spreadsheet data.

### Batch Job Pattern

- `methods/run-daily-job.gs` -> job entry point.
- `services/job-*.gs` -> each step of workflow.
- `utils/*` -> shared formatting and validation.

## Refactor Checklist (Monolith -> Split)

1. Identify all top-level functions in old `Code.js`.
2. Create one file per top-level function in `methods/`.
3. Extract duplicated logic into `services/` or `utils/`.
4. Rename files to kebab-case, keep function names unchanged.
5. Confirm no duplicate function names remain.
6. Run `clasp status`, then `clasp push`.
