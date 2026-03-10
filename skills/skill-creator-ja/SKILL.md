---
name: skill-creator-ja
description: Create or improve Codex skills with a practical workflow for Japanese users. Use when users ask to design, scaffold, update, or review skills, especially when ambiguity must be clarified through user questions, a Japanese README.md is required, and final confirmation to move the completed skill into ~/.agents/skills/ is needed.
---

# Skill Creator JA

Create and refine skills efficiently with clear confirmation gates.
Handle ambiguity first, then implement quickly and validate before handoff.

## Mandatory Rules

1. Ask the user when requirements are ambiguous.
2. Write `README.md` in Japanese for every created/updated skill.
3. After implementation is complete, ask:
   `作成したスキルを ~/.agents/skills/ に移動して問題ないですか？`

## Workflow

### 1) Clarify Scope

- Extract unknowns from user request:
  - Skill name
  - New skill or update existing skill
  - Required resources (`scripts/`, `references/`, `assets/`)
  - Behavior constraints and completion criteria
- If unknowns remain, ask 1-3 focused questions before implementation.
- Prioritize blocker questions. Do not ask low-impact questions first.

### 2) Initialize or Load the Skill

- For a new skill, prefer:
  `scripts/init_skill.py <skill-name> --path <output-directory> [--resources ...]`
- For an existing skill, read current `SKILL.md` and `agents/openai.yaml` first.
- Keep folder name equal to the normalized skill name.

### 3) Implement Core Files

- Update `SKILL.md` frontmatter:
  - `name`
  - `description` with explicit trigger conditions
- Keep procedural body concise and actionable.
- Reference optional files only when necessary.

### 4) Write Japanese README.md

Create `README.md` in Japanese and include:

1. 目的
2. トリガー条件
3. 実行フロー
4. 必須ルール
5. 出力物
6. 制約と注意点

If `SKILL.md` and `README.md` conflict, align both before finishing.

### 5) Validate

Run:
`scripts/quick_validate.py <path/to/skill-folder>`

If validation fails, fix and re-run until successful.

### 6) Finish with Move Confirmation

Before ending the task, always ask:
`作成したスキルを ~/.agents/skills/ に移動して問題ないですか？`

## Clarification Question Template

Use this when key requirements are missing:

1. `このスキルは新規作成ですか、それとも既存スキルの改修ですか？`
2. `スキル名と保存先ディレクトリを指定してください。`
3. `必須のリソース（scripts/references/assets）があれば指定してください。`

Keep questions short and only ask what blocks implementation.

## Bundled Resources

Read `references/clarification-checklist-ja.md` when deciding what to ask.

Use resource directories only if they provide repeatable value.
