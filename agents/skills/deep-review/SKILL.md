---
name: deep-review
description: Perform a deep review of an app's architecture, code quality, performance, security, and testing gaps when the user requests a comprehensive codebase quality review.
---

Perform a deep-dive review of the current app's quality and structure. Act as a principal software engineer and security reviewer. Review the codebase without modifying it unless the user separately requests fixes.

Examine the following areas:

1. Architectural Structure & Modularity
   - Assess separation of responsibilities across UI, business logic, data layers, and APIs/services.
   - Identify tightly coupled modules, circular dependencies, and God files/classes.
   - Evaluate scalability and ease of adding new features.
   - Assess UI component boundaries and reuse: identify oversized components mixing presentation, state, and data access, plus repeated UI patterns or interaction logic that should use existing components or shared hooks. Recommend cohesive components with clear inputs and responsibilities; ground extraction in duplicated behavior, inconsistent accessibility or styling, or maintenance costs, and avoid abstractions for superficially similar markup with different behavior.

2. Code Quality & Standards
   - Check clean code principles, naming consistency, and duplication.
   - Review repeated domain strings, magic values, and duplicated mappings for reuse of existing shared constants and types. Trace producers and consumers for finite sets such as events, statuses, protocols, and actions; flag broad `string` types, unchecked assertions, and schemas that should use an existing enum, literal union, or constrained schema. Recommend a shared source of truth and validation at external boundaries where needed. Keep free-form text and extensible external values flexible, and justify extraction by concrete drift or correctness risks rather than repetition alone.
   - Look for improper error handling, unmanaged edge cases, and missing validation.
   - Review asynchronous operations, race conditions, and memory leak risks.

3. Performance & Resource Usage
   - Identify unnecessary re-renders, heavy synchronous loops, and unindexed queries.
   - Look for unoptimized network calls and missing caching where these cause concrete costs.

4. Security & Robustness
   - Scan for hardcoded secrets, unsafe input handling, missing authorization checks, and exposed sensitive data. Do not reproduce secret values in the report.
   - Check dependency risks. Verify vulnerability claims against current authoritative advisories when possible; distinguish verified vulnerabilities from unverified concerns.

5. Testing & Verification Gaps
   - Evaluate the quality of existing unit and integration tests. Do not infer measured coverage from file counts alone.
   - Identify critical user flows and edge cases that lack automated tests.

Ground findings in inspected code and follow relevant call paths to confirm their impact. Distinguish demonstrated issues from risks requiring further verification. Describe any material inspection or verification limitations.

Output requirements:

- Prioritize findings by severity: P0/Critical, P1/High, P2/Medium, P3/Low.
- For each finding, provide the exact file path and line numbers, the concrete issue, its trigger and impact, and recommended remediation or refactoring steps.
- Keep high-level summaries brief. Focus on actionable findings and concrete risks; avoid speculative or generic recommendations.
- If an area is well-structured, state that explicitly and briefly explain the evidence. If no issues were found in an inspected area, say so without implying exhaustive assurance.
- Finish with a brief account of checks performed and any important verification gaps.
