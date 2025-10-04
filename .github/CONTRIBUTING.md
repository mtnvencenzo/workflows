# 🤝 Contributing to GitHub Reusable Workflows

Thanks for your interest in improving this collection of reusable GitHub Actions workflows! Contributions that make the workflows clearer, safer, and easier to consume are very welcome.

## 📋 Table of Contents

- [Getting Started](#getting-started)
- [Workflow Development](#workflow-development)
- [Testing Changes](#testing-changes)
- [Style Guidelines](#style-guidelines)
- [Submitting Your Contribution](#submitting-your-contribution)
- [Getting Help](#getting-help)

## 🚀 Getting Started

### 📦 Prerequisites

Please have the following installed locally:

- Git
- A recent version of Node.js (only if you intend to run tooling that depends on it)
- [`actionlint`](https://github.com/rhysd/actionlint) for validating workflow syntax
- Optional: [`yq`](https://mikefarah.gitbook.io/yq/) or similar tools for working with YAML

Clone your fork of the repository:

```bash
git clone https://github.com/<your-username>/workflows.git
cd workflows
```

Create a feature branch before making changes:

```bash
git checkout -b feature/update-workflow
```

## 🧭 Workflow Development

This repository is purely infrastructure-as-code for automation. When adding or modifying workflows:

- Prefer reusable workflows under `.github/workflows/` with descriptive file names.
- Keep composite actions in `.github/actions/` self-contained and shell-agnostic where possible.
- Document every user-facing input with a `description` and sensible defaults.
- Avoid hard-coding secrets. Reference them through `secrets.*` inputs and document requirements for callers.
- Use conditionals (`if:`) and matrix builds judiciously—aim for clarity.
- When deprecating a workflow, add a notice in the README and consider keeping a stub that fails fast with guidance.

## 🧪 Testing Changes

Because workflows execute remotely, validating them locally requires a little creativity:

1. **Static analysis** – Run `actionlint` from the repository root:
   ```bash
   actionlint
   ```

2. **Shell scripts** – For composite actions or inline scripts, extract the script into a local file or run it in a container to ensure syntax is correct.

3. **Dry runs** – Create a temporary repository or branch that calls your updated workflow via `uses: <your-account>/workflows@<branch>`. Inspect the run logs before opening a PR here.

4. **Documentation updates** – If you change required inputs, outputs, or behavior, update the README usage snippets accordingly.

## 🎨 Style Guidelines

- Follow the existing YAML layout (two-space indentation, lower-case keys).
- Group related steps logically and give them concise, action-oriented names.
- Prefer reusable actions (`uses:`) over lengthy shell scripts when a maintained option exists.
- Keep shell scripts POSIX-compatible unless a specific shell is required; declare the shell explicitly in `run:` blocks when deviating from Bash.
- Store helper scripts under `.github/scripts/` if they are reused.

## 📮 Submitting Your Contribution

1. **Commit** your work using [Conventional Commits](https://www.conventionalcommits.org/):
   ```bash
   git add .
   git commit -m "feat(ui-build): add version tagging support"
   ```
   
   Use [conventional commit format](https://www.conventionalcommits.org/):
   - `feat:` for new features
   - `fix:` for bug fixes
   - `docs:` for documentation changes
   - `style:` for formatting changes
   - `refactor:` for code refactoring
   - `test:` for adding tests
   - `chore:` for maintenance tasks

### 3. Submitting Changes

1. **Push your branch**
   ```bash
   git push origin feature/update-workflow
   ```

   In the PR, describe what changed, why it is needed, and how you validated the behavior. Please link to any consuming repositories or sample runs that demonstrate the change.

4. **Review feedback** – Be responsive to comments. We prefer incremental improvements over large rewrites, so don’t hesitate to split work into smaller PRs.

## 🆘 Getting Help

- Open a [GitHub Discussion](https://github.com/mtnvencenzo/workflows/discussions) for ideas or questions.
- Use [GitHub Issues](https://github.com/mtnvencenzo/workflows/issues) to report bugs or request new workflows.
- For sensitive topics (for example, suspected security issues), contact the maintainer privately [@mtnvencenzo](https://github.com/mtnvencenzo).

By contributing, you agree that your work will be released under the repository’s [MIT License](../LICENSE).

Thanks again for helping improve these reusable workflows!
