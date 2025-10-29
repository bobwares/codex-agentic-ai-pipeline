<!--
PR TITLE (agent must set the GitHub PR title field to the following exact value):
Turn {{TURN_ID}} – {{DATE}} – {{TIME_OF_EXECUTION}}
-->

## Turn Durations

**Worked for:**  < Display worked for >.

## Turn Summary

< 3–5 sentences summarizing the overall result of this turn. >

## Input Prompt

<Summarize the input prompt / schema name that initiated this turn.>

## Application Implementation Pattern 

**Name**: ${ACTIVE_PATTERN_NAME} 

**Path**: ${{ACTIVE_PATTERN_PATH}


## Tasks Executed

< Each row is populated with the Task name listed in the ${EXECUTION_PLAN}. Maintain the order defined in the ${EXECUTION_PLAN}. The column "Tools / Agents Executed" should include external tools called during the execution of the task.  It should include shell statements.  MCP calls.>


| Task Name | Tools / Agents Executed |
|-----------|-------------------------|
|           |                         |
|           |                         |

## Turn Files Added (under /ai only)

| File | Path |
|------|------|
|      |      |
|      |      |

## Files Added (exclude /ai)

| File | Path | Description                         | Task Name |
|------|------|-------------------------------------|-----------|
|      |      | <Description from metadata header.> |           |
|      |      |                                     |           |

## Files Updated (exclude /ai)

| File | Path | Description                         | Task Name |
|------|------|-------------------------------------|-----------|
|      |      | <Description from metadata header.> |           |
|      |      |                                     |           |

## Checklist

- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Linter passes
- [ ] Documentation updated

## Codex Task Link
<leave blank>
