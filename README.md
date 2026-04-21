# ai-foundry

The open registry of production-ready **skills**, **agents**, **plugins**, and **contexts** for AI coding assistants.

Drop-in components built and refined by the community. No bloat. No boilerplate.

---

## What's inside

| Type | What it does |
|---|---|
| **Skills** | Behavioral instructions loaded into Claude on demand |
| **Agents** | Autonomous subagents for multi-step tasks |
| **Plugins** | Integrations with external tools and services |
| **Contexts** | Background knowledge files (reference docs, domain guides) |

---

## Quick install

**Install the whole registry** (recommended):

```bash
/plugin marketplace add msdakot/ai-foundary
```

**Manual clone:**

```bash
git clone https://github.com/msdakot/ai-foundary.git ~/.claude/plugins/ai-foundary
```

**One-liner:**

```bash
curl -fsSL https://raw.githubusercontent.com/msdakot/ai-foundary/main/scripts/install.sh | bash
```

---

**Install a single component via npx:**

```bash
npx ai-foundry add <type> <name>
```

```bash
# Install a skill
npx ai-foundry add skill <listed-skill>

# List everything available
npx ai-foundry list
```

This copies the component into your project's `.claude/` directory and registers it in `settings.json`.

---

## Available skills

| Name | Description |
|---|---|
| [codeassist-guardrails](./skills/codeassist-guardrails/) | Behavioral guardrails for LLM coding — prevents silent assumptions, overengineering, and collateral damage |
| [skill-observer](./skills/skill-observer/) | Background observer that watches conversation patterns, detects repeated corrections, and suggests new skills or CLAUDE.md rules for human approval |
| [content-curator-research](./skills/social-media/content-curator-research/) | Autonomous 3x/day AI intel sweep across HackerNews, GitHub Trending, ArXiv, Google AI Blog, and X — appends structured daily reports to a GitHub repo |
| [content-curator](./skills/social-media/content-curator/) | Drafts LinkedIn posts and newsletter sections grounded in real signals from the latest intel report, with hook library and reverse-engineer mode |

---

## Available agents

| Agent | Description | Sub-agents |
|---|---|---|
| ai-team | Specialist sub-agents for end-to-end AI/ML work spanning research, data, modeling, and deployment | [deepresearch](./agents/ai-team/deepresearch/), [autoresearch](./agents/ai-team/autoresearch/), [ai-scientist](./agents/ai-team/ai-scientist/), [data-scientist](./agents/ai-team/data-scientist/), [ml-engineer](./agents/ai-team/ml-engineer/), [data-engineer](./agents/ai-team/data-engineer/), [mlops-engineer](./agents/ai-team/mlops-engineer/), [llm-architect](./agents/ai-team/llm-architect/), [prompt-optimization](./agents/ai-team/prompt-optimization/), [nlp-engineer](./agents/ai-team/nlp-engineer/), [computer-vision-engineer](./agents/ai-team/computer-vision-engineer/), [recommendation-engine](./agents/ai-team/recommendation-engine/), [vector-database-engineer](./agents/ai-team/vector-database-engineer/), [data-visualization](./agents/ai-team/data-visualization/) |
| devops-agent | Specialist sub-agents for the full software development lifecycle — from idea to deployed, reviewed code | [feature-brainstorm](./agents/devops-agent/feature-brainstorm/), [spec-writer](./agents/devops-agent/spec-writer/), [architect](./agents/devops-agent/architect/), [diagram-definition](./agents/devops-agent/diagram-definition/), [task-planner](./agents/devops-agent/task-planner/), [developer](./agents/devops-agent/developer/), [language-expert](./agents/devops-agent/language-expert/), [code-reviewer](./agents/devops-agent/code-reviewer/), [mcp-developer](./agents/devops-agent/mcp-developer/), [devops-infra](./agents/devops-agent/devops-infra/) |

---

## Available plugins

_None yet — [contribute one](#contributing)_

---

## Available contexts

_None yet — [contribute one](#contributing)_

---

## Manual install

1. Copy the component folder into your project:
   ```
   .claude/
   └── .agents/
       └── skills/
           └── <skill-name>/
               └── SKILL.md
   ```

2. Register it in `.claude/settings.json`:
   ```json
   {
     "skills": [
       ".claude/.agents/skills/<skill-name>"
     ]
   }
   ```

3. **Skills with hooks** (e.g. `skill-observer`) also require copying the hook scripts to `~/.claude/hooks/` and registering them in `~/.claude/settings.json`:
   ```bash
   cp .claude/.agents/skills/<skill-name>/hooks/*.sh ~/.claude/hooks/
   chmod +x ~/.claude/hooks/*.sh
   ```
   Then add to `~/.claude/settings.json`:
   ```json
   {
     "hooks": {
       "Stop": [{ "hooks": [{ "type": "command", "command": "bash ~/.claude/hooks/<skill-name>-stop.sh", "timeout": 10 }] }]
     }
   }
   ```
   The `npx ai-foundry add` command handles all of this automatically.

---

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md).

---

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=msdakot/ai-foundary&type=Date)](https://star-history.com/#msdakot/ai-foundary&Date)

---

## License

[MIT](./LICENSE)
