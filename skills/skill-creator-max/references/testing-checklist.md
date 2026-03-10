# Testing and Validation Checklist

## Pre-Upload Structural Checks

- [ ] Folder named in kebab-case
- [ ] SKILL.md file exists (exact spelling, case-sensitive)
- [ ] YAML frontmatter has `---` delimiters (opening and closing)
- [ ] `name` field: kebab-case, no spaces, no capitals
- [ ] `description` includes WHAT and WHEN
- [ ] No XML tags (< >) anywhere in frontmatter
- [ ] Instructions are clear and actionable
- [ ] Error handling included
- [ ] Examples provided
- [ ] References clearly linked
- [ ] No README.md inside skill folder (README is for repo-level distribution only)

## Triggering Tests

Goal: Ensure skill loads at the right times.

### Should trigger (test with 3+ variations):
- Obvious task request
- Paraphrased request
- Request with different wording but same intent

### Should NOT trigger (test with 3+ variations):
- Completely unrelated topics
- Similar but out-of-scope requests
- Requests that belong to other skills

## Functional Tests

Goal: Verify correct outputs.

- [ ] Valid outputs generated
- [ ] API/MCP calls succeed (if applicable)
- [ ] Error handling works for common failures
- [ ] Edge cases covered

## Performance Comparison (Success Criteria)

### Quantitative metrics (aspirational targets):
- Skill triggers on 90% of relevant queries
- Completes workflow in fewer tool calls than without skill
- 0 failed API calls per workflow

### Qualitative metrics:
- Users don't need to prompt Claude about next steps
- Workflows complete without user correction
- Consistent results across sessions
- New user can accomplish task on first try

## Post-Upload Checks

- [ ] Test in real conversations
- [ ] Monitor for under/over-triggering
- [ ] Collect user feedback
- [ ] Iterate on description and instructions
- [ ] Update version in metadata

## Common Validation Failures

### SKILL.md not found
- File not named exactly SKILL.md (case-sensitive)
- Fix: `ls -la` to verify exact filename

### Invalid frontmatter
- Missing `---` delimiters
- Unclosed quotes
- Invalid YAML syntax

### Invalid skill name
- Spaces or capitals in name field
- Fix: use kebab-case only

### Skill too large
- SKILL.md over 5,000 words
- Fix: Move detailed docs to references/
