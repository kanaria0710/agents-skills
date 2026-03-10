# Complete Skill Examples

## Example 1: Document & Asset Creation Skill

```
frontend-design/
├── SKILL.md
├── references/
│   └── style-guide.md
└── assets/
    └── template.html
```

```yaml
---
name: frontend-design
description: Create distinctive, production-grade frontend interfaces with high design quality. Use when building web components, pages, artifacts, posters, or applications.
---
```

```markdown
# Frontend Design

## Instructions

### Step 1: Understand Requirements
- Clarify the type of interface (component, page, full app)
- Identify brand constraints from `references/style-guide.md`
- Determine responsive requirements

### Step 2: Design
- Start from `assets/template.html` if applicable
- Apply brand standards
- Focus on accessibility

### Step 3: Quality Check
- Verify responsive behavior
- Check accessibility (contrast, alt text, semantic HTML)
- Validate against style guide

### Examples

Example 1: Landing page
User says: "Create a landing page for our SaaS product"
Actions:
1. Load style guide
2. Create responsive HTML/CSS
3. Include hero, features, pricing, CTA sections
Result: Production-ready landing page HTML

### Troubleshooting
Error: Design doesn't match brand
Solution: Re-read `references/style-guide.md` and verify color/font usage
```

## Example 2: Workflow Automation Skill

```
sprint-planner/
├── SKILL.md
├── scripts/
│   └── validate_tasks.py
└── references/
    └── velocity-guide.md
```

```yaml
---
name: sprint-planner
description: Interactive sprint planning workflow for Linear. Walks through project status analysis, velocity calculation, task prioritization, and task creation. Use when user says "plan this sprint", "create sprint tasks", or "sprint planning".
metadata:
  mcp-server: linear
  version: 1.0.0
---
```

```markdown
# Sprint Planner

## Workflow

### Step 1: Fetch Current Status
Call MCP tool: `linear_get_projects`
- Get active project status
- Identify incomplete tasks from previous sprint

### Step 2: Analyze Capacity
- Consult `references/velocity-guide.md` for calculation method
- Calculate team velocity from last 3 sprints
- Determine available capacity

### Step 3: Prioritize Tasks
Present prioritized list to user:
- P0: Must complete this sprint
- P1: Should complete if capacity allows
- P2: Nice to have

### Step 4: Create Tasks
Run `python scripts/validate_tasks.py` before creation.
Call MCP tool: `linear_create_issue` for each validated task.

### Step 5: Summary
Present sprint plan with:
- Total story points
- Task breakdown by priority
- Capacity utilization percentage
```

## Example 3: MCP Enhancement Skill

```yaml
---
name: sentry-code-review
description: Automatically analyzes and fixes detected bugs in GitHub Pull Requests using Sentry error monitoring data. Use when user mentions "Sentry errors", "bug from Sentry", or "fix Sentry issue in PR".
metadata:
  mcp-server: sentry
  version: 1.0.0
---
```

## Skill File Structure Reference

```
skill-name/               # kebab-case folder
├── SKILL.md              # REQUIRED - main instructions (English)
├── scripts/              # OPTIONAL - executable code
│   ├── process.py
│   └── validate.sh
├── references/           # OPTIONAL - documentation for context
│   ├── api-guide.md
│   └── examples/
└── assets/               # OPTIONAL - templates, fonts, icons
    └── template.md
```

### scripts/
Executable code (Python, Bash, etc.) run directly to perform operations.
Scripts may be executed without loading into context but can be read for patching.

### references/
Documentation loaded into context to inform Claude's process and thinking.
Use for: API references, schemas, comprehensive guides, detailed workflow docs.

### assets/
Files NOT loaded into context but used within output Claude produces.
Use for: Templates, boilerplate, images, icons, fonts, document templates.
