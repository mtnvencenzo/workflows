# 🔒 Security Policy

## Supported Versions

This repository publishes reusable GitHub Actions workflows and composite actions. The `main` branch is the actively maintained version. If a security issue is discovered, fixes will be applied to `main` and can be consumed by pinning to the latest commit SHA or tag.

## Reporting a Vulnerability

Please report security concerns privately. Do **not** open a public GitHub issue that exposes sensitive information.

- Use GitHub’s [private vulnerability reporting](https://github.com/mtnvencenzo/workflows/security/advisories/new) feature, **or**
- Contact the project maintainer [@mtnvencenzo](https://github.com/mtnvencenzo) with the details.

To help us triage quickly, include:

- The workflow or action file(s) involved and the branch/commit hash
- A clear description of the issue and potential impact (e.g., secret exposure, privilege escalation)
- Steps to reproduce or proof-of-concept logs, if available
- Any suggested remediation ideas or mitigations

We will acknowledge reports within **48 hours** and provide status updates at least once per week until the issue is resolved.

## Disclosure Policy

- We prefer coordinated disclosure. Please allow maintainers reasonable time to create and publish a fix.
- When the issue is resolved, we will publish a security advisory summarizing the impact, mitigation, and acknowledgements (unless you request anonymity).

## Hardening Guidance for Consumers

If you are consuming these workflows:

- Pin workflow references to a specific commit SHA rather than `main` to avoid unexpected changes.
- Review workflow permissions (`permissions:` block) and limit them when invoking the workflows.
- Supply required secrets and inputs through GitHub Actions secrets. Avoid placing secrets directly in workflow YAML.
- Audit workflow logs for unexpected behavior, especially after updates.

Thank you for helping keep this automation toolkit secure for everyone! 