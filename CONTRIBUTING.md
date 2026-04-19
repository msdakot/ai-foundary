# Contributing to ai-foundry

## What can I contribute?

- **Skills** — behavioral instructions that change how Claude Code responds
- **Agents** — subagents for multi-step autonomous tasks
- **Plugins** — integrations with external tools/services
- **Contexts** — reference docs or domain knowledge loaded into context

## Adding a new component

### 1. Choose the right folder

```
skills/       ← behavioral instructions (SKILL.md)
agents/       ← subagent definitions
plugins/      ← external integrations
contexts/     ← reference/knowledge files
```

### 2. Structure

**Skills** must follow this layout:

```
skills/<your-skill-name>/
├── SKILL.md          ← required; name + description frontmatter
└── evals/
    └── evals.json    ← recommended for verifiable outputs
```

Minimal `SKILL.md`:

```markdown
---
name: your-skill-name
description: One sentence on what it does and when to use it.
---

# Your Skill

Instructions here.
```

**Agents**, **plugins**, and **contexts** follow the same pattern — a directory with a clear entry point and frontmatter describing what it does.

### 3. Quality bar

- Does one thing well.
- No speculative features or abstractions.
- Include at least 2 test cases in `evals/evals.json` if outputs are verifiable.
- Tested against at least one real prompt before submitting.

### 4. Register for npx

Add your component to `scripts/registry.json`:

```json
{
  "skills": {
    "your-skill-name": "skills/your-skill-name"
  }
}
```

### 5. Update the README

Add a row to the relevant table in `README.md`.

### 6. Open a PR

Title format: `add: <type>/<name>` — e.g., `add: skill/git-commit-helper`

---

## Improving an existing component

- Open an issue first for significant behavioral changes.
- Small fixes (wording, examples) — PR directly.
- Include before/after eval results if changing behavior.

---

## Code of conduct

Be helpful, be direct, no bloat.
