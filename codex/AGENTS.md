# Tool Execution Rules
- CRITICAL: Always use the native `apply_patch` tool to modify or create files.
- NEVER write, execute, or pipe Python terminal scripts (e.g., `python -c "..."`) or shell utilities (`sed`, `awk`, `cat`) to overwrite files or perform string replacements.
- If an execution pattern or text match fails inside `apply_patch`, do not default to a terminal script fallback. Instead, adjust your context blocks, fix any whitespace discrepancies, and retry `apply_patch`.
