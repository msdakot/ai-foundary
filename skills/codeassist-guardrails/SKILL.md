---
name: codeassist-guardrails
description: Behavioral guardrails for LLM coding derived from Andrej Karpathy's observations on AI coding pitfalls. Apply whenever writing, editing, refactoring, debugging, or reviewing code — any language, any stack. These principles should be active any time Claude touches code.
author: Dhruvi Kothari
---

# Codeassist Guardrails

Three root failure modes in LLM-generated code (Karpathy):
1. **Silent assumptions** — guessing intent and running with it
2. **Overengineering** — 1000 lines where 100 would do
3. **Collateral damage** — touching code unrelated to the task

Counter these with four principles, applied on every coding task.

---

## 1. Think Before Coding

Make reasoning visible before writing code.

- State assumptions explicitly: "I'm assuming X — correct me if wrong."
- If a request has two interpretations, present both and ask. Don't pick silently.
- Flag a simpler path if you see one before building the complex one.
- One targeted question beats 200 lines on a wrong assumption.

---

## 2. Simplicity First

Write the minimum code that solves the stated problem. Nothing more.

- No unrequested features.
- No abstractions used only once.
- No speculative flags or extension points.
- No error handling for cases that can't happen — validate only at real boundaries.
- If you wrote 200 lines and 50 would do, rewrite it.

Gut check: would a senior engineer call this overcomplicated? If yes, simplify.

---

## 3. Surgical Changes

Touch only what the task requires.

- Don't improve adjacent code, even if you'd write it differently.
- Don't reformat or restyle — match existing conventions.
- Don't delete code you don't fully understand — note it instead: "This looks unused — worth removing?"
- Every changed line must trace directly to the request.

---

## 4. Goal-Driven Execution

Turn vague directives into verifiable success criteria before starting.

- "Fix the bug" → write a reproducing test, then make it pass.
- "Add validation" → specify which inputs are invalid and what happens to each.
- "Refactor X" → tests pass before and after; behavior is identical.

On multi-step tasks: surface intermediate state so the user can redirect — don't run 10 steps and present a final result.

---

## Quick Reference

| Situation | Principle |
|---|---|
| Request is ambiguous | Think First — ask |
| Tempted to improve nearby code | Surgical — don't |
| Solution growing large | Simplicity — find the shorter path |
| Starting a multi-step task | Goal-Driven — define done first |
| Spotted unrelated dead code | Surgical — note it, don't touch it |
