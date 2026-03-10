---
name: gas-script-requirements-ja
description: Clarify and finalize detailed requirements for Google Apps Script implementation requests before coding. Use when users provide ambiguous or incomplete requests for GAS scripts, triggers, Spreadsheet automation, data handling, or operation rules, and a concrete implementation-ready specification is needed.
---

# GAS Script Requirements JA

Define implementation-ready requirements for GAS tasks before writing code.
Focus on removing ambiguity, identifying constraints, and producing a structured handoff for implementation skills.

## Workflow

### 1) Confirm Request Scope

Identify target and intent:
- New script or modification of existing script
- Trigger type (manual, onOpen, onEdit, time-driven, web app)
- Target services (Spreadsheet, Drive, Gmail, Calendar, etc.)

### 2) Ask Focused Clarification Questions

Ask only blocker questions. Keep questions short and concrete.

Required coverage:
- Objective and expected business outcome
- Inputs, outputs, and data format
- Execution timing and trigger conditions
- Error handling and retry policy
- Permission/scopes and security constraints
- Non-functional constraints (performance, quota, maintainability)

### 3) Build Requirements Spec

Produce a concise spec containing:
1. Goal and scope
2. Method/function list with responsibilities
3. Input/output contract per method
4. Data source and update rules
5. Error cases and handling policy
6. Required scopes and external dependencies
7. Test scenarios and acceptance criteria

### 4) Validate Completeness

Check each required field. If any critical field is missing, ask follow-up questions before handoff.

### 5) Handoff to Implementation Skill

When requirements are fixed, hand off to `$gas-modular-method-files` with:
- confirmed requirements spec
- file split plan (`methods/`, `services/`, `utils/`)
- function naming and trigger mapping

## Output Format

Use this format for handoff:

```markdown
# GAS Requirements Spec

## Goal
- ...

## Scope
- ...

## Function Plan
- doGet(e): ...
- onOpen(e): ...

## Input/Output Contracts
- ...

## Data Rules
- ...

## Error Handling
- ...

## Required Scopes
- ...

## Test Scenarios
- ...

## Acceptance Criteria
- ...
```

## Bundled Resources

- Read `references/hearing-checklist-ja.md` for interview checkpoints.
- Read `references/requirements-template-ja.md` for reusable output template.
