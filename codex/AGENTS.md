# Tool Execution Rules
- CRITICAL: Always use the native `apply_patch` tool to modify or create source code and other text files.
- Binary and non-text files, such as images, screenshot baselines, and archives, are exempt from the `apply_patch` requirement. Use appropriate generation, copy, or conversion tools for these files without requesting an exception solely because they are binary or non-text.
- NEVER write, execute, or pipe Python terminal scripts (e.g., `python -c "..."`) or shell utilities (`sed`, `awk`, `cat`) to overwrite source code or other text files or perform string replacements in them.
- If an execution pattern or text match fails inside `apply_patch`, do not default to a terminal script fallback. Instead, adjust your context blocks, fix any whitespace discrepancies, and retry `apply_patch`.
