# YAML Frontmatter Specification

## Minimal Required Format

```yaml
---
name: skill-name-in-kebab-case
description: What it does and when to use it. Include specific trigger phrases.
---
```

## Required Fields

### name
- kebab-case only (e.g., `my-cool-skill`)
- No spaces, underscores, or capitals
- Should match folder name
- Must NOT contain "claude" or "anthropic" (reserved)

### description
- MUST include BOTH:
  - What the skill does
  - When to use it (trigger conditions)
- Under 1024 characters
- No XML tags (< or >)
- Include specific tasks users might say
- Mention file types if relevant

## Optional Fields

### license
- Use if making skill open source
- Common values: MIT, Apache-2.0

### allowed-tools
- Restrict tool access
- Example: `"Bash(python:*) Bash(npm:*) WebFetch"`

### compatibility
- 1-500 characters
- Indicates environment requirements (intended product, required system packages, network access needs)

### metadata
- Any custom key-value pairs
- Suggested fields: author, version, mcp-server, category, tags, documentation, support
- Example:
```yaml
metadata:
  author: Company Name
  version: 1.0.0
  mcp-server: server-name
  category: productivity
  tags: [project-management, automation]
```

## Security Restrictions

### Forbidden in frontmatter:
- XML angle brackets (< >) — frontmatter appears in Claude's system prompt; malicious content could inject instructions
- Skills named with "claude" or "anthropic" prefix (reserved)
- Code execution in YAML (uses safe YAML parsing)

### Allowed:
- Any standard YAML types (strings, numbers, booleans, lists, objects)
- Custom metadata fields
- Long descriptions (up to 1024 characters)

## Common Mistakes

```yaml
# WRONG - missing delimiters
name: my-skill
description: Does things

# WRONG - unclosed quotes
---
name: my-skill
description: "Does things
---

# WRONG - spaces in name
---
name: My Cool Skill
description: Does things.
---

# CORRECT
---
name: my-cool-skill
description: Does things. Use when user asks to do specific tasks like X, Y, or Z.
---
```
