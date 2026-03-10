# Description Field Guide

The description is the most critical part of the frontmatter.
It determines whether Claude loads your skill. This is the first level of progressive disclosure.

## Structure

```
[What it does] + [When to use it] + [Key capabilities]
```

## Good Examples

```yaml
# Specific and actionable
description: Analyzes Figma design files and generates developer handoff documentation. Use when user uploads .fig files, asks for "design specs", "component documentation", or "design-to-code handoff".

# Includes trigger phrases
description: Manages Linear project workflows including sprint planning, task creation, and status tracking. Use when user mentions "sprint", "Linear tasks", "project planning", or asks to "create tickets".

# Clear value proposition
description: End-to-end customer onboarding workflow for PayFlow. Handles account creation, payment setup, and subscription management. Use when user says "onboard new customer", "set up subscription", or "create PayFlow account".
```

## Bad Examples

```yaml
# Too vague — no trigger info
description: Helps with projects.

# Missing triggers — no "when to use"
description: Creates sophisticated multi-page documentation systems.

# Too technical, no user triggers
description: Implements the Project entity model with hierarchical relationships.

# Too broad
description: Processes documents.
```

## Negative Triggers

When a skill triggers too often, add negative triggers:

```yaml
description: Advanced data analysis for CSV files. Use for statistical modeling, regression, clustering. Do NOT use for simple data exploration (use data-viz skill instead).
```

## Specificity Spectrum

```yaml
# Too broad
description: Processes documents

# Better
description: Processes PDF legal documents for contract review

# Best — includes scope boundary
description: PayFlow payment processing for e-commerce. Use specifically for online payment workflows, not for general financial queries.
```

## Debugging Trigger Issues

Ask Claude: "When would you use the [skill name] skill?"
Claude will quote the description back. Adjust based on what's missing.
