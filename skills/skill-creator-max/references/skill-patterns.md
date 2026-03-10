# Skill Patterns Reference

## Three Skill Categories

### Category 1: Document & Asset Creation
Creates consistent, high-quality output (documents, presentations, apps, designs, code).

Key techniques:
- Embedded style guides and brand standards
- Template structures for consistent output
- Quality checklists before finalizing
- No external tools required — uses Claude's built-in capabilities

### Category 2: Workflow Automation
Multi-step processes with consistent methodology, possibly coordinating multiple MCP servers.

Key techniques:
- Step-by-step workflow with validation gates
- Templates for common structures
- Built-in review and improvement suggestions
- Iterative refinement loops

### Category 3: MCP Enhancement
Workflow guidance layered on top of MCP server tool access.

Key techniques:
- Coordinates multiple MCP calls in sequence
- Embeds domain expertise
- Provides context users would otherwise need to specify
- Error handling for common MCP issues

## Five Implementation Patterns

### Pattern 1: Sequential Workflow Orchestration
**Use when**: Users need multi-step processes in a specific order.

Key techniques:
- Explicit step ordering
- Dependencies between steps
- Validation at each stage
- Rollback instructions for failures

Example structure:
```markdown
## Workflow: [Process Name]

### Step 1: [First Action]
Call MCP tool: `tool_name`
Parameters: param1, param2

### Step 2: [Second Action]
Call MCP tool: `another_tool`
Wait for: previous step completion

### Step 3: [Third Action]
...
```

### Pattern 2: Multi-MCP Coordination
**Use when**: Workflows span multiple services.

Key techniques:
- Clear phase separation
- Data passing between MCPs
- Validation before moving to next phase
- Centralized error handling

Example structure:
```markdown
### Phase 1: [Service A] (MCP A)
1. Action 1
2. Action 2

### Phase 2: [Service B] (MCP B)
1. Use output from Phase 1
2. Action 3

### Phase 3: [Service C] (MCP C)
1. Aggregate results
```

### Pattern 3: Iterative Refinement
**Use when**: Output quality improves with iteration.

Key techniques:
- Explicit quality criteria
- Iterative improvement loops
- Validation scripts
- Know when to stop iterating

Example structure:
```markdown
### Initial Draft
1. Fetch data
2. Generate first draft

### Quality Check
1. Run validation script
2. Identify issues

### Refinement Loop
1. Address each issue
2. Regenerate affected sections
3. Re-validate
4. Repeat until quality threshold met
```

### Pattern 4: Context-Aware Tool Selection
**Use when**: Same outcome, different tools depending on context.

Key techniques:
- Clear decision criteria
- Fallback options
- Transparency about choices

Example structure:
```markdown
### Decision Tree
1. Check context (file type, size, etc.)
2. Determine best approach:
   - Condition A: Use tool X
   - Condition B: Use tool Y
   - Fallback: Use tool Z

### Execute
Based on decision, call appropriate tool.
```

### Pattern 5: Domain-Specific Intelligence
**Use when**: Skill adds specialized knowledge beyond tool access.

Key techniques:
- Domain expertise embedded in logic
- Compliance/validation before action
- Comprehensive audit trail
- Clear governance

Example structure:
```markdown
### Pre-Processing (Domain Check)
1. Fetch details
2. Apply domain rules
3. Document decision

### Processing
IF checks passed: proceed
ELSE: flag for review

### Audit Trail
- Log all checks
- Record decisions
```

## Choosing Your Approach

**Problem-first**: "I need to set up a project workspace" -> Skill orchestrates the right calls.
Users describe outcomes; the skill handles the tools.

**Tool-first**: "I have Notion MCP connected" -> Skill teaches Claude optimal workflows.
Users have access; the skill provides expertise.
