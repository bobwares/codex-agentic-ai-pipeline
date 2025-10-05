# Open AI Codex

Codex is an AI coding agent that runs a “plan → act → observe → iterate” loop against a real repository. It can read files, edit code, run commands/tests, and propose PRs, either on your machine (CLI/IDE) or in an isolated cloud environment tied to ChatGPT. ([OpenAI][1])

# What Codex is

Codex is OpenAI’s software-engineering agent. Starting from a prompt/spec, it navigates your repo, edits files, runs builds/tests, and helps ship features or fixes. You can pair with it locally via a CLI/IDE extension or delegate work to “Codex cloud,” which executes tasks in sandboxed containers and can open PRs. ([OpenAI][1])

# How the loop works (conceptual)

1. Input: you state a task (“add a registration wizard; validate with tests”).
2. Plan: the LLM (GPT-5-Codex) decomposes the task and picks steps.
3. Act: it uses tools—file read/write, shell commands, test runners, git—to apply changes.
4. Observe: it reads logs/diffs/test output.
5. Iterate: it adjusts the plan until the objective passes.
6. Deliver: it shows diffs and (in cloud) can open a PR or (locally) leave changes staged/committed.
   This is exactly the “agentic coding” workflow described across the CLI, cloud quickstart, and changelog docs. ([OpenAI Developers][2])

# Where it runs

* Local (CLI/IDE): open-source CLI in your terminal; can read/modify/run code in a chosen directory. Approval prompts and modes govern edits/exec. IDE extension mirrors this and can hand jobs off to the cloud. ([OpenAI Developers][2])
* Cloud (ChatGPT): tasks run in ephemeral containers preloaded with your repo; you configure images, setup scripts, env vars/secrets, and internet policy. You review results and open PRs from the UI. ([OpenAI Developers][3])

# Safety & network model (cloud)

During environment setup, full internet is allowed to install deps; after setup, the agent phase defaults to internet-off (you can enable limited or full access). Cloud tasks run in isolated OpenAI-managed containers; access is explicitly scoped. ([OpenAI Developers][4])

# The model behind it

GPT-5-Codex is a GPT-5 variant tuned for agentic coding and powers the CLI/IDE, cloud agent, and GitHub code review surface. ([OpenAI Developers][5])

# GitHub code review

You can enable “Code Review” so Codex reviews PRs directly in GitHub (e.g., after you connect a repo in Codex cloud). ([OpenAI Developers][6])

# Pricing at a glance

Codex is included with ChatGPT Plus/Pro/Team/Edu/Enterprise; each plan has different local vs. cloud usage limits. Details live on the pricing page. ([OpenAI Developers][7])

# Mental model (one screen)

Prompt → Plan (LLM) → Choose tools (edit files, run tests, git) → Observe output/diffs → Iterate until criteria pass → Deliver (PR or local changes). That’s Codex in a nutshell. ([OpenAI Developers][2])


[1]: https://openai.com/codex/?utm_source=chatgpt.com "Codex"
[2]: https://developers.openai.com/codex/cli/?utm_source=chatgpt.com "Codex CLI"
[3]: https://developers.openai.com/codex/cloud/environments/?utm_source=chatgpt.com "Cloud environments"
[4]: https://developers.openai.com/codex/cloud/internet-access/?utm_source=chatgpt.com "Agent internet access"
[5]: https://developers.openai.com/codex/changelog/?utm_source=chatgpt.com "Codex changelog"
[6]: https://developers.openai.com/codex/cloud/code-review/?utm_source=chatgpt.com "Code Review"
[7]: https://developers.openai.com/codex/pricing/?utm_source=chatgpt.com "Codex Pricing"
