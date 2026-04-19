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

---

## Available agents

_None yet — [contribute one](#contributing)_

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
           └── codeassist-guardrails/
               └── SKILL.md
   ```

2. Register it in `.claude/settings.json`:
   ```json
   {
     "skills": [
       ".claude/.agents/skills/codeassist-guardrails"
     ]
   }
   ```

---

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md).

---

## License

[MIT](./LICENSE)
