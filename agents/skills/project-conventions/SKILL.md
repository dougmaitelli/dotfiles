---
name: project-conventions
description: Set up or audit repository layout, formatting, scoped CI, releases, dependency updates, GitHub Pages docs, and browser screenshots using the shared project conventions. Use for new project foundations or an explicit conventions review, not ordinary feature edits.
---

# Project conventions

Use these defaults to establish consistent project tooling without turning every
project into the same application. Discover the actual language, package boundaries,
default branch, repository coordinates, and supported deployment platforms first.
Respect explicit user choices and explain necessary deviations from these defaults.

## Choose the scope

- **Set up or align:** implement the requested conventions, preserving existing
  behavior and legitimate project-specific tooling.
- **Audit:** inspect and report concrete gaps with file references. Do not change
  files unless the user asked for fixes.
- **Focused request:** read and apply only the relevant parts of this skill.

Read [the pipeline reference](references/pipelines.md) when changing CI, release,
Pages, or Dependabot configuration. Use [the cliff template](assets/cliff.toml)
when adding release notes, replacing its GitHub owner and repository fields.

Existing sibling repositories can supply examples, but do not copy their stale
dependency versions, application names, historical limitations, or missing checks.
Prefer the repository's existing supported toolchain and official tools.

## Repository boundaries

Use a layout that reflects the actual application:

```text
backend/                  Backend module, when separate from the frontend
web/                      Production frontend
docs/                     Self-contained Astro/Starlight documentation package
e2e/                      Self-contained Playwright package and browser specs
screenshots/              Single documentation and visual regression image set
scripts/                  Shared development, build, and packaging tooling
.github/workflows/        Scoped CI and publishing
.github/dependabot.yml    Updates for every relevant package boundary
cliff.toml                Release-note configuration
```

Do not create empty directories or introduce a separate backend package into a
project that does not need one. Native unit tests can remain beside production
code where the language expects them. Keep E2E-specific Playwright configuration,
test dependencies, browser-test Dockerfiles, runner scripts, and generated test
reports inside `e2e/`, rather than `web/` or root. Application dependencies,
production Dockerfiles, and general development tooling stay with their owning
application or package.
A backend browser-test harness may live in its language module when required to
use private packages; exclude it from production builds.

Keep each independent JavaScript package's manifest and lockfile together.
Reuse an established workspace when it provides those boundaries already.
Ignore generated dependencies, caches, reports, and build output specifically;
do not ignore the entire docs or test source directory.

## Formatting and lint

- Provide explicit format, format-check, lint, type-check, test, and build commands
  appropriate to the stack, with discoverable Make targets or package scripts.
- Use Prettier for supported frontend/tooling formats and ESLint for JavaScript
  and TypeScript. Use the project's native backend tools; for Go, use gofmt,
  goimports, go vet, and a pinned golangci-lint with the agreed rules.
- CI checks formatting without rewriting source. Local format commands may write.
  Include test and tooling sources, but exclude generated output and lockfiles
  owned by package managers. Use an official formatter plugin only when needed.
- Match tool versions across local commands and CI, and verify native linters as
  well as the formatter. Passing gofmt does not imply passing Go whitespace lint.

## CI and releases

Prefer established GitHub Actions, their configuration, and short inline workflow
steps over new helper scripts. Keep release tagging and path selection in the
workflow when existing actions and basic Git/shell commands are sufficient.
Do not introduce a general-purpose version parser, workflow-expression evaluator,
custom validator, or new dependencies just to support a small workflow change.
Extract a helper only when concrete reuse or substantial logic makes it easier
to maintain than the inline alternative. Existing build, packaging, and E2E
runners can still be appropriate; this is not a blanket ban on scripts.

Separate change detection, application validation, browser tests, docs validation,
and publishing. Keep a stable final required-check job that accounts for
intentionally skipped jobs and fails on selected-job failures or cancellations.
Gate application publishing on change detection and the applicable application,
browser, and shared-tooling checks directly. Do not make it depend on docs checks,
Pages deployment, or an aggregate `ci-result` that includes docs. Documentation
failures still fail the overall CI result, but must not block application images
or releases when their own checks pass.

Classify source, browser, docs, screenshots, and shared configuration independently.
Docs-only changes must not publish an application image. Screenshot-only changes
must still run visual regression; do not exclude them from every test filter.
Prefer keeping that classification separate from runtime artifact publishing.
Version tags run full validation even when the tagged commit changes only docs.

Use git-cliff for release notes, following the pipeline reference. Preserve the
existing artifact, prerelease, and checksum behavior when integrating it.
Require release tags in `vMAJOR.MINOR.PATCH` format, such as `v0.1.0`, with
optional SemVer prerelease suffixes such as `v0.2.0-rc.1`. Validate the full tag
before publishing; a broad `v*` workflow trigger alone is not validation.
Default-branch application changes publish `:dev`. Stable releases publish their
exact version, major/minor aliases, and `:latest`; prereleases publish only their
exact tag and never update stable aliases or GitHub's latest release. Publish
after the required application checks pass, assembling architecture images into
a multi-platform manifest before assigning public tags. See the pipeline reference for examples
and protections against older releases replacing newer aliases.
Do not create tags, push, publish, or change repository settings merely because
the skill is active; perform those actions only within the user's authorized task.
Never move an already-published release tag to retrofit new tooling.

## Dependabot

Cover every independent package: frontend, docs, browser tests, backend modules,
Dockerfiles, and GitHub Actions. Group coupled dependencies so compatible versions
update in the same PR: React/React DOM and their types, Vite/plugins, ESLint
tooling, Astro/Starlight, and Playwright packages. Keep browser-image versions
synchronized with Playwright, preferably deriving them from its pinned package
version. Adapt groups to the actual dependency relationships rather than grouping
all updates together.
Do not copy only the production frontend entry and omit docs or `e2e/`.
Updates must trigger the checks for the package they affect.

## Documentation and Pages

- Use Astro with Starlight as a self-contained `docs/` package, with its own
  manifest, lockfile, configuration, styling, and local dev/check/build/preview
  commands. Use standard `astro check` and `astro build`; do not add custom
  validators or build wrappers without a demonstrated requirement.
- Configure the actual GitHub Pages origin and repository base path. Verify
  screenshot URLs, navigation, search, and mobile layout in the built site.
- Reference root `screenshots/` directly. Reuse branding without copying the
  application's entire public directory into the docs output.
- Keep the README user-facing: purpose, features, a focused screenshot gallery,
  concise quick start, and links to detailed guides. Put development and browser
  testing mechanics in their own guides. Do not discuss visual baselines in the
  user-facing README or create a second oversized install manual.
- Publish current user documentation, not implementation plans, old assessments,
  speculative roadmaps, or historical mockups. Never invent a license, security
  policy, deployment URL, or feature claim to fill out a template.

## GitHub repository metadata

Set a concise, user-facing repository description and relevant GitHub topics
that reflect the project's actual purpose and supported technologies. Topics
are discovery metadata, separate from versioned release tags.

Set the repository's About website link to its published documentation URL so
the Pages site is visible from the repository landing page. Preserve existing
intentional metadata and apply repository-setting changes only within the
authorized task. See the pipeline reference for verification details.

For dougmaitelli's projects, configure `.github/FUNDING.yml` with
`github: dougmaitelli` and `thanks_dev: dougmaitelli`. These are
the established defaults; do not wait for funding details to be supplied again.
See the pipeline reference for the exact file. For a different owner, use that
owner's funding configuration instead.

## Browser tests and screenshots

- Run Playwright against the real built application and API where feasible.
  Simulate external infrastructure at its boundary, using isolated disposable
  data. Keep any reset mechanism restricted to the test harness.
- Share core fixture definitions with development mock mode. Tests may fix the
  clock and isolate state; do not maintain divergent copies of the same users,
  servers, notifications, roles, files, or backups.
- Use shared screen helpers and UI states for browser assertions and screenshot
  capture. Browser specs should test meaningful flows beyond taking pictures.
- Keep a single root `screenshots/` set for docs and visual baselines. Normal
  tests compare and fail on missing or changed images; an explicit regeneration
  command updates those same images through the specs. No parallel export-only
  image set or documentation screenshot runner.
- Pin Playwright and match the Docker browser image to that exact version. Use
  Docker as the canonical renderer, with explicit viewport, locale, time zone,
  theme, reduced motion, stable fixtures, and readiness for fonts and images.
- Seed populated, representative screens, including notifications and custom
  roles where present. Check important resource tabs, empty/error states, and
  permissions according to the application rather than a fixed screenshot list.
- Keep failure screenshots, traces, videos, and HTML reports in ignored test
  output directories; upload them as CI failure artifacts.

## Deployment and packaging

Release archives must deliberately include only distribution files. Installing
docs or test dependencies locally must not cause recursive packaging of
`node_modules`, `.astro`, `dist`, caches, reports, or secrets. Match image and
binary versions and ship checksums when distributing binaries.

## Finish with evidence

Run the checks relevant to the adopted conventions. For CI filters, reason through
docs-only, app-only, browser-only, screenshot-only, shared-tooling, version-tag,
and manual-run cases using the table in the pipeline reference. Verify that all
independent package lockfiles and Dependabot entries are covered.
Also verify that an application push can publish when its checks pass and docs
fail, while an application or browser failure or cancellation still blocks it.

Verification does not automatically require new committed test scripts or a test
framework. Use existing checks and temporary fixtures for small workflow changes.
If an edge case requires disproportionate machinery, explain the tradeoff and
keep the implementation within the requested scope.

Report what changed, which checks passed, deliberate exceptions, and remaining
external setup. Distinguish a successful local build, configured Pages settings,
a pushed workflow, and a completed deployment; they are different outcomes.
