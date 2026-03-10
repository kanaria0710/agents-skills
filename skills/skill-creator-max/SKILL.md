---
name: skill-creator-max
description: Comprehensive skill builder that covers the full lifecycle from planning to validation using the official Anthropic skill-building guide. Use when users ask to create, design, scaffold, review, or improve Claude skills with production-quality structure, proper frontmatter, progressive disclosure, testing criteria, and pattern selection. Triggers on requests like "create a skill", "build a new skill", "scaffold a skill", "review my skill", "improve this skill".
metadata:
  author: kanaria
  version: 1.0.0
  category: skill-development
---

# Skill Creator Max

Build production-quality Claude skills using the complete Anthropic skill-building guide.
This skill covers the full lifecycle: planning, design, implementation, testing, and iteration.

## Mandatory Rules

1. Communicate with the user in Japanese.
2. All generated SKILL.md files must be written in English.
3. All generated README.md files must be written in Japanese.
4. Two confirmation gates are required:
   - **Gate 1**: After drafting frontmatter, present it to the user for approval before proceeding.
   - **Gate 2**: After implementation is complete, present a review summary for user approval.
5. Never include README.md inside the skill folder itself. README.md is for the repo level only if distributing via GitHub.
6. SKILL.md must be exactly `SKILL.md` (case-sensitive). No variations.
7. Folder names must be kebab-case. No spaces, underscores, or capitals.
8. Never use XML angle brackets (< >) in YAML frontmatter.
9. Never use "claude" or "anthropic" in skill names.

## Workflow

### Phase 1: Requirements Gathering

Extract from user request:
- Skill purpose and target use cases (identify 2-3 concrete use cases)
- Skill category (see `references/skill-patterns.md` for the 3 categories)
- Required resources (scripts/, references/, assets/)
- MCP dependencies (if any)
- Behavior constraints and completion criteria

If unknowns remain, ask 1-3 focused questions. Prioritize blocker questions only.

Determine skill pattern by asking:
- Is this a sequential workflow? -> Pattern 1
- Does it span multiple services? -> Pattern 2
- Does output improve with iteration? -> Pattern 3
- Does the same outcome need different tools by context? -> Pattern 4
- Does it embed specialized domain knowledge? -> Pattern 5

Consult `references/skill-patterns.md` for pattern details.

### Phase 2: Frontmatter Design (Gate 1)

Draft the YAML frontmatter following the spec in `references/frontmatter-spec.md`.

Critical checklist for description field (see `references/description-guide.md`):
- Includes WHAT the skill does
- Includes WHEN to use it (trigger conditions with specific phrases users would say)
- Under 1024 characters
- No XML tags
- Specific and actionable, not vague

Present the drafted frontmatter to the user:
```
以下のfrontmatterで進めてよいですか？修正点があれば指示してください。
```

Do NOT proceed until user approves.

### Phase 3: Structure Selection

Choose the SKILL.md body structure based on the skill's purpose:

1. **Workflow-Based**: Sequential processes with clear steps
   - Structure: Overview -> Workflow Decision Tree -> Step 1 -> Step 2...
2. **Task-Based**: Multiple operations/capabilities
   - Structure: Overview -> Quick Start -> Task Category 1 -> Task Category 2...
3. **Reference/Guidelines**: Standards or specifications
   - Structure: Overview -> Guidelines -> Specifications -> Usage...
4. **Capabilities-Based**: Integrated systems with interrelated features
   - Structure: Overview -> Core Capabilities -> Feature 1 -> Feature 2...

Patterns can be mixed. Choose what fits best.

### Phase 4: Implementation

Write the SKILL.md body with these principles:

1. **Progressive Disclosure** (three levels):
   - Level 1 (frontmatter): Always loaded. Minimal trigger info.
   - Level 2 (SKILL.md body): Loaded when relevant. Full instructions.
   - Level 3 (references/): Loaded on demand. Deep documentation.

2. **Instructions must be**:
   - Specific and actionable (not "validate things properly" but explicit checks)
   - Concise with bullet points and numbered lists
   - Critical instructions at the top
   - Error handling included
   - Examples provided with realistic user requests

3. **For critical validations**: Consider bundling a script rather than relying on language instructions. Code is deterministic; language interpretation is not.

4. **Keep SKILL.md under 5,000 words**. Move detailed docs to references/.

5. **Composability**: The skill should work well alongside other skills.

6. **Portability**: Works across Claude.ai, Claude Code, and API without modification.

If the skill needs scripts, write them in `scripts/`.
If the skill needs reference docs, write them in `references/`.
If the skill needs templates or assets, place them in `assets/`.

### Phase 5: Review (Gate 2)

Present a review summary to the user:

```
実装レビューサマリー:
- スキル名: [name]
- カテゴリ: [category]
- パターン: [pattern used]
- ファイル構成: [list of files created]
- トリガー条件: [summary of when it triggers]
- 主要フロー: [summary of workflow]

上記内容で問題ないですか？修正点があれば指示してください。
```

Do NOT finalize until user approves.

### Phase 6: Validation

After user approval, validate the skill against `references/testing-checklist.md`:

1. **Triggering tests**:
   - Would it trigger on obvious tasks?
   - Would it trigger on paraphrased requests?
   - Would it NOT trigger on unrelated topics?

2. **Structural checks**:
   - SKILL.md exists with exact naming
   - YAML frontmatter has --- delimiters
   - name field is kebab-case
   - description includes WHAT and WHEN
   - No XML tags anywhere
   - Folder is kebab-case

3. **Quality checks**:
   - Instructions are clear and actionable
   - Error handling included
   - Examples provided
   - References clearly linked
   - SKILL.md under 5,000 words

If issues found, fix and re-validate.

### Phase 7: Write Japanese README.md

Create README.md in Japanese with:
1. Overview (purpose)
2. Trigger conditions
3. Execution flow
4. Required rules
5. Output artifacts
6. File structure
7. Constraints and notes

## Troubleshooting Reference

When debugging skills, consult `references/troubleshooting.md` for common issues:
- Skill won't upload (SKILL.md naming, frontmatter format, name format)
- Skill doesn't trigger (description too vague, missing trigger phrases)
- Skill triggers too often (add negative triggers, be more specific)
- Instructions not followed (too verbose, buried, ambiguous)
- MCP connection issues (authentication, tool names)
- Large context issues (optimize size, use progressive disclosure)

## Performance Notes for Generated Skills

When generating skills that may suffer from model laziness, suggest adding to the skill:
```
## Performance Notes
- Take your time to do this thoroughly
- Quality is more important than speed
- Do not skip validation steps
```

Note: This is more effective in user prompts than in SKILL.md.
