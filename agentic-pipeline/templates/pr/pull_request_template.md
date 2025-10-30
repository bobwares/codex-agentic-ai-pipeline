< Agent must set the GitHub PR title field to the following exact value): Turn {{TURN_ID}} – {{DATE}} – {{TIME_OF_EXECUTION}} >

## Turn Summary

< 3–5 Bullet points summarizing the overall result of this turn. >

## Turn Durations

**Worked for:**  ${TURN_ELAPSED_TIME}

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
|      |   < The path only>  |
|      |      |

## Files Added (exclude /ai)

| File | Path             | Description                         | Task Name |
|------|------------------|-------------------------------------|-----------|
|      | < The path only> | <Description from metadata header.> |           |
|      |                  |                                     |           |

## Files Updated (exclude /ai)

| File | Path             | Description                         | Task Name |
|------|------------------|-------------------------------------|-----------|
|      | < The path only> | <Description from metadata header.> |           |
|      |                  |                                     |           |

## Checklist

- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Linter passes
- [ ] Documentation updated

## Codex Task Link
<leave blank>
