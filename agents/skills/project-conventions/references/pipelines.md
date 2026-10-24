# Pipeline conventions

Use this reference for CI, release notes, dependency updates, and Pages. Substitute
the repository's actual default branch, owner, project name, and package paths.
This describes behavior; use existing workflows rather than introducing duplicate
jobs or hardcoding a particular application's stack.

## Change selection

Define separate outputs when the checks and published artifacts have different
inputs. Avoid using one broad `app` flag for every kind of change.

| Change | Application checks | Browser checks | Docs build | Publish runtime artifacts on default-branch push |
| --- | --- | --- | --- | --- |
| Backend or frontend source | Yes | Yes when behavior or UI can change | If docs import affected assets | Yes |
| `docs/` source or package tooling | No | No | Yes | No |
| README or other user documentation | No | No | Yes if used by the docs site | No |
| `e2e/` specs, harness, or runner | Affected checks | Yes | No | No, unless shipped runtime files also change |
| Root `screenshots/` | No | Yes | Yes | No |
| Shared build/configuration/CI files | Select all affected jobs | As affected | As affected | Only when distribution inputs change |
| Version tag | Yes | Yes | Yes | Publish tagged images and release assets after validation |
| Manual validation | As requested, normally all | As requested | As requested | Never publish implicitly |

Some established projects deliberately run app checks for screenshot changes;
preserve that coverage while separating it from artifact publishing if adopting
the stricter selection above. Do not silently remove test coverage to reduce jobs.

Use a path-filter implementation that handles deletions and renamed files.
Be careful with excluded paths combined with positive glob matches: verify
whether the filter combines rules with OR or AND. For `dorny/paths-filter`,
`predicate-quantifier: every` supports a catch-all with exclusions; keep
independent positive selections for docs and screenshots.

Changes to workflow definitions, package manifests and lockfiles, test harnesses,
shared assets, and build scripts must select their consumers. Do not assume
that all Markdown files are unshipped: embedded content or build inputs may
need application validation too.

## Job graph

Use standard actions and workflow configuration first. Put small pieces of
project-specific glue directly in readable `run` steps. Do not create helper
programs, wrapper layers, custom expression evaluators, or supporting dependency
sets solely to implement or test workflow selection and release tags. A separate
script needs a concrete maintenance or reuse benefit, not hypothetical flexibility.

1. A change-detection job produces the selected check/publishing outputs.
2. Application, browser, and docs jobs run independently when selected.
3. A final `ci-result` job runs with `always()`. It depends on detection and every
   validation job, fails for failures/cancellations, and accepts intentional skips.
4. Application publishing depends on successful validation and actual artifact
   changes on a default-branch push. A release tag independently selects full
   validation and publishing. Pull requests only validate.
5. Docs deploy after their successful build on a relevant default-branch push.
   An explicitly requested manual docs deployment can deploy the default branch.
   A version tag validates docs without overwriting the live site.

Keep reusable Pages and packaging workflows separate where useful. Give the
calling job and reusable workflow the permissions actually needed. Use read-only
defaults, with `packages: write`, `contents: write`, or Pages OIDC permissions
limited to the relevant publishing jobs.

Use per-ref concurrency and avoid cancelling a tag's release run because a
new default-branch commit arrived. Do not use `continue-on-error` to make a
required check appear successful.

## Publishing strategy

Use these tags for the application's published container image:

| Trigger | Image tags | GitHub release |
| --- | --- | --- |
| Default-branch push affecting application artifacts | `dev` | None |
| Stable release `v1.2.3` | `v1.2.3`, `v1.2`, `v1`, `latest` | Stable release with git-cliff notes and release assets |
| Prerelease `v1.3.0-rc.1` | `v1.3.0-rc.1` only | Prerelease; never mark as latest |
| Pull request, docs-only change, or ordinary manual validation | None | None |

Publish only after all required checks for the selected changes pass. Do not
publish application artifacts merely because docs validation or deployment ran.
Manual publishing requires an explicitly requested publishing workflow, not a
side effect of a validation dispatch.

Build supported architectures separately, then publish their combined manifest
under the public tags only when every architecture succeeds. Do not race
architecture jobs to overwrite the same tag with single-platform images.
Use the release version consistently in image metadata, binaries, archives,
and git-cliff notes. Attach versioned binaries and SHA-256 checksums when the
project distributes binaries.

Keep exact version tags tied to their release artifacts. Moving aliases need
version-aware behavior: a backport such as `v1.2.4` must not replace `latest`
or `v1` if `v1.3.0` is already stable. It may advance `v1.2` when it is the newest
stable patch in that minor series. Likewise, an older-major release must not
replace aliases for a newer major. For validated stable `vMAJOR.MINOR.PATCH`
tags, use Git's version ordering (`--sort=-version:refname`), excluding prerelease
tags, and pass the eligibility flags to Docker's metadata action and the GitHub
release action. This does not require a standalone SemVer implementation. Keep
GitHub's latest stable release consistent with the image's `latest` policy.

Preserve release identity when rerunning failed publishing jobs. Do not move an
existing release tag or silently rebuild it from a different commit. Keep
default-branch `dev` publishing separate from versioned release publishing.

## git-cliff

Require SemVer release tags with a lowercase `v` prefix: `vMAJOR.MINOR.PATCH`,
for example `v0.1.0`. Permit valid prereleases such as `v0.2.0-rc.1`; do not publish
them as the stable `latest` release. Validate the full tag, including SemVer's
numeric identifier rules. Workflow globs such as `v*` and git-cliff's tag pattern
select candidates but do not replace release-tag validation.

Copy [the config template](../assets/cliff.toml) to root `cliff.toml` and replace
`PROJECT_OWNER` and `PROJECT_REPOSITORY`. The config groups user-facing changes,
keeps dependency updates, recognizes useful legacy commit subjects, and omits
merge commits and conventional internal-only changes.

In the tag release job, use the same pattern as the established projects:

```yaml
steps:
  - uses: actions/checkout@v7
    with:
      fetch-depth: 0
  - uses: orhun/git-cliff-action@v4
    id: cliff
    with:
      config: cliff.toml
      args: --current --strip header
  - uses: softprops/action-gh-release@v3
    with:
      body: ${{ steps.cliff.outputs.content }}
```

Check that action versions remain supported before adopting this example. Keep
the project's artifact download, attachment, checksum, tag, and prerelease steps.
Replace `generate_release_notes: true`; do not generate two competing bodies.
The checkout needs full history and tags for the release's commit range.

Validate with git-cliff against a real tag or a disposable local repository.
Do not tag production history just to test the template. Changes committed after
a release tag cannot alter that tag's workflow; a separately authorized release
body update is different from rebuilding or moving the tag.

## GitHub Pages

Use the docs package's pinned package-manager version and a compatible Node
version, frozen installation, `astro check`, and `astro build`.

For a repository site, configure:

```js
site: "https://OWNER.github.io",
base: "/REPOSITORY",
```

Upload only the built docs directory using `actions/upload-pages-artifact`, then
deploy it with `actions/deploy-pages` in the `github-pages` environment. Give
deployment `pages: write` and `id-token: write`. Configure Pages to use Actions
within an authorized deployment task; do not claim the site is live merely
because that setting or the workflow exists.

Keep doc validation independent of the production build. Use standard framework
commands and components; add custom scripts or overrides only for a concrete
requirement, such as the established branded hero layout.

## Repository metadata

As part of an authorized GitHub project setup, review its About section:

- **Description:** a short statement of what users can do with the project,
  consistent with the README and implemented features.
- **Topics:** relevant domain and technology keywords, such as `self-hosted`,
  `homelab`, or the specific services the project manages. Select them for the
  actual project; do not copy another repository's list or confuse topics with
  release tags.
- **Website:** the published documentation URL, including the correct repository
  base path or custom domain. Set GitHub's homepage/website field so the link
  appears in About; enabling Pages alone is not sufficient verification.
- **Funding:** for dougmaitelli's projects, create `.github/FUNDING.yml` with
  these GitHub Sponsors and thanks.dev accounts:

  ```yaml
  github: dougmaitelli
  thanks_dev: dougmaitelli
  ```

  Apply these established defaults during project setup without asking for the
  accounts again. Preserve explicit project-specific overrides.

Inspect current values before changing them. Preserve intentional existing topics
and URLs unless the user asked to replace them. Verify the saved description,
topics, website link, and Pages deployment independently. Report any metadata
left unset rather than claiming that workflow files configure these settings.

For projects owned by someone else, use their funding configuration rather than
these personal defaults.

## Dependabot coverage

Inspect every manifest and Dockerfile before writing the configuration. Typical
entries for a Go/React project are:

| Ecosystem | Directories |
| --- | --- |
| npm | `/web`, `/docs`, `/e2e`, plus a root package if present |
| gomod | `/backend` or each actual Go module |
| docker | `/` and `/e2e` when each has a Dockerfile |
| github-actions | `/` |

For a TypeScript server project, its main package can be `/` instead of separate
Go and frontend entries. Use a weekly cadence by default, reasonable PR limits,
and groups that reflect compatibility boundaries. Coupled dependencies must
update together in the same PR, including React/React DOM and their types,
Vite and its plugins, ESLint and its shared tooling, and Astro/Starlight.
Keep Playwright package and
browser-image versions synchronized, preferably deriving the image version from
the package rather than maintaining duplicate pins.

Do not add automatic merge behavior, dependency exclusions, or privileged bot
workflows unless separately requested. Review existing update policies rather
than copying an incomplete list from a sibling repository.
