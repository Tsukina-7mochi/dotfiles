---
name: deno-testing
description: Write or fix tests in a Deno project. Use this when asked to "write tests," "add tests," or "fix tests" and the target is a Deno project.
allowed-tools: WebFetch(domain:docs.deno.com)
---

The Deno testing API updates rapidly, and when writing code based only on training data, people tend to use outdated syntax or reinvent the wheel with custom implementations or external libraries without knowing about built-in features (such as hooks, mocks, FakeTime, and sanitizers). Before writing, you must check the documentation to see what is provided.

## Pricipale

- Read https://docs.deno.com/runtime/test/index.md
- Read subpages relates to what you going to write: `https://docs.deno.com/runtime/test/<name>.md` (e.g. `mocking.md`)
- Match the existing test style of the project. If there is none, use `Deno.test`, `@std/assert`, or similar.
