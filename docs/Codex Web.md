Codex Web is the browser-based, cloud version of OpenAI’s Codex coding agent. You use it at chatgpt.com/codex to ask questions about a repo, delegate coding tasks, run commands/tests in an isolated environment, and have Codex draft pull requests—directly from the web UI. It’s currently offered as a research preview and available on ChatGPT Plus, Pro, Business, Edu, and Enterprise plans. ([ChatGPT][1])

Operationally, Codex Web spins up a containerized “cloud environment” for each task with your repository (branch/SHA) mounted. It can read/edit files and execute commands (linters, unit tests, type checks). Internet access is off by default but can be selectively enabled per environment. ([OpenAI][2])

How it fits with the rest of Codex:

* Same agent, different fronts: you can work in the web app, IDE extension, or CLI and move work between local and cloud under your ChatGPT account. ([OpenAI Developers][3])
* Web vs. local config: Codex Web does not read your local `~/.codex/config.toml`. Cloud behavior (e.g., network policy, setup scripts) is configured in the Codex Cloud Environments settings, not via your local file. ([OpenAI Developers][4])

Model note: OpenAI exposes a Codex-optimized model variant (“gpt-5-codex”) for this experience; you’ll see it referenced in the Codex docs. ([OpenAI Developers][3])

If you want, I can map your repo into a sample Codex Web environment and outline a minimal “run tests → fix failures → open PR” flow with the exact settings to toggle.

[1]: https://chatgpt.com/codex?utm_source=chatgpt.com "Codex"
[2]: https://openai.com/index/introducing-codex/?utm_source=chatgpt.com "Introducing Codex"
[3]: https://developers.openai.com/codex/?utm_source=chatgpt.com "Codex"
[4]: https://developers.openai.com/codex/cloud/?utm_source=chatgpt.com "Codex cloud"
