# Tool Execution Rules
- CRITICAL: Always use the native `apply_patch` tool to modify or create source code and other text files.
- Binary and non-text files, such as images, screenshot baselines, and archives, are exempt from the `apply_patch` requirement. Use appropriate generation, copy, or conversion tools for these files without requesting an exception solely because they are binary or non-text.
- NEVER write, execute, or pipe Python terminal scripts (e.g., `python -c "..."`) or shell utilities (`sed`, `awk`, `cat`) to overwrite source code or other text files or perform string replacements in them.
- If an execution pattern or text match fails inside `apply_patch`, do not default to a terminal script fallback. Instead, adjust your context blocks, fix any whitespace discrepancies, and retry `apply_patch`.

# Validation Before Delivery
- Before changing code, inspect the repository's CI workflows and validation commands to identify the checks affected by the change.
- Before committing or pushing, run the applicable CI checks against the final changes, including formatting, lint, types, tests, and builds. Focused tests alone do not replace the relevant CI suites.
- For UI changes, run browser and visual regression tests. Inspect screenshot differences, update baselines only for intended visual changes, and rerun tests without updating snapshots to verify them. Preserve responsive behavior and check changed interactions in a real browser.
- If a required check cannot run, state which check is blocked and why. Never describe partial validation as complete or claim CI passes without evidence.
- After pushing, inspect the resulting CI run and fix failures caused by the changes before reporting completion.
