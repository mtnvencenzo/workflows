# GitHub Reusable Workflows

This repository contains a collection of reusable GitHub Actions workflows that I use across my projects. These workflows are designed to be called from other repositories within my GitHub account.

## 🚀 Available Workflows

Here’s a snapshot of what’s included. Each workflow is versioned via this repo, so pin to a tag or commit SHA when consuming.

### 1. NPM Package Publish (`.github/workflows/npm-package-publish.yaml`)
Builds and publishes a user-scoped NPM package to GitHub Packages.

Usage
```yaml
jobs:
  publish:
    uses: mtnvencenzo/workflows/.github/workflows/npm-package-publish.yaml@main
    with:
      node_version: '23.5.x'
      artifact_name: 'ui-build-artifact'
      npm_scope: 'mtnvencenzo'
      package_name: 'your-package-name'
    secrets:
      github_packages_pat_token: ${{ secrets.GITHUB_TOKEN_OR_PAT }}
```

### 2. Terraform Plan and Apply (`.github/workflows/terraform-plan-and-apply.yaml`)
Manages Terraform deployments with plan/apply and workspace handling.

Usage
```yaml
jobs:
  terraform:
    uses: mtnvencenzo/workflows/.github/workflows/terraform-plan-and-apply.yaml@main
    with:
      terraform-version: '1.5.0'
      working-directory: './terraform'
```

### 3. Azure Blob Upload (`.github/workflows/azure-blob-upload.yaml`)
Uploads files to Azure Blob Storage.

Usage
```yaml
jobs:
  upload:
    uses: mtnvencenzo/workflows/.github/workflows/azure-blob-upload.yaml@main
    with:
      working_directory: '.'
      environment_name: 'prod'
      allow_deploy: true
      arm_client_id: ${{ vars.ARM_CLIENT_ID }}
      arm_subscription_id: ${{ vars.ARM_SUBSCRIPTION_ID }}
      arm_tenant_id: ${{ vars.ARM_TENANT_ID }}
      storage_account_name: 'mystorageacct'
      container_name: 'artifacts'
      source_directory: './dist'
      pattern: '*'
    secrets:
      arm_client_secret: ${{ secrets.ARM_CLIENT_SECRET }}
```

### 4. UI Storybook Build and Deploy (`.github/workflows/ui-storybook-build-deploy.yaml`)
Builds and deploys Storybook for UI components.

Usage
```yaml
jobs:
  storybook:
    uses: mtnvencenzo/workflows/.github/workflows/ui-storybook-build-deploy.yaml@main
    with:
      node-version: '18'
      build-command: 'build-storybook'
```

### 5. Warmup Request (`.github/workflows/warmup-request.yaml`)
Keeps endpoints warm by pinging them on demand or schedule.

Usage
```yaml
jobs:
  warmup:
    uses: mtnvencenzo/workflows/.github/workflows/warmup-request.yaml@main
    with:
      url: 'https://your-app.azurewebsites.net/health'
      interval: '15'
```

### 6. UI Build (`.github/workflows/ui-build.yaml`)
Builds frontend apps with lint, tests, and artifact packaging. Supports writing a JSON version file with optional tag (version+tag).

Usage
```yaml
jobs:
  build:
    uses: mtnvencenzo/workflows/.github/workflows/ui-build.yaml@main
    with:
      working_directory: './app'
      node_version: '23.5.x'
      upload_artifact: true
      artifact_name: 'ui-build-artifact'
      use_npm_auth: true
      version: '1.2.3'
      version_tag: 'build42'
      version_file_path: './app/src/version.json'
      setup_files: '["README.md","LICENSE"]'
    secrets:
      github_packages_pat_token: ${{ secrets.GH_PACKAGES_PAT }}
```

### 7. Docker Build and Push (`.github/workflows/docker-build-and-push.yaml`)
Builds Docker images and pushes them to a registry.

Usage
```yaml
jobs:
  docker:
    uses: mtnvencenzo/workflows/.github/workflows/docker-build-and-push.yaml@main
    with:
      image-name: 'my-app'
      registry: 'ghcr.io'
```

### 8. NuGet Pack and Push (`.github/workflows/nuget-pack-and-push.yaml`)
Packs and pushes .NET NuGet packages.

Usage
```yaml
jobs:
  nuget:
    uses: mtnvencenzo/workflows/.github/workflows/nuget-pack-and-push.yaml@main
    with:
      project-path: './src/MyProject.csproj'
      nuget-source: 'https://api.nuget.org/v3/index.json'
```

### 9. API Build (`.github/workflows/api-build.yaml`)
Builds and tests .NET API projects with coverage and packaged artifacts.

Usage
```yaml
jobs:
  api:
    uses: mtnvencenzo/workflows/.github/workflows/api-build.yaml@main
    with:
      working_directory: './src'
      dotnet_version: '9.x'
      project_path: './MyApi/MyApi.csproj'
      test_project_path: './MyApi.Tests/MyApi.Tests.csproj'
      publish_project_path: './MyApi/MyApi.csproj'
      artifact_name: 'dotnet-build-artifact'
      publish_directory_name: 'dist'
      version: '1.0.0'
      setup_files: '["appsettings.json"]'
    secrets:
      azure_artifacts_base64_pat_token: ${{ secrets.AZURE_ARTIFACTS_PAT_B64 }}
      github_packages_pat_token: ${{ secrets.GH_PACKAGES_PAT }}
```

### 10. Cypress Runner (`.github/workflows/cypress-runner.yaml`)
Runs Cypress E2E tests.

Usage
```yaml
jobs:
  cypress:
    uses: mtnvencenzo/workflows/.github/workflows/cypress-runner.yaml@main
    with:
      cypress-version: '12.0.0'
      parallel: 'true'
```

### 11. API Call (`.github/workflows/api-call.yaml`)
Generic API call with retry and status code validation—handy for health checks or readiness gates.

Usage
```yaml
jobs:
  call:
    uses: mtnvencenzo/workflows/.github/workflows/api-call.yaml@main
    with:
      url: 'https://service/health'
      statusCode: '200'
      enabled: true
      method: 'GET'
      authHeader: 'Authorization' # optional
    secrets:
      authValue: ${{ secrets.SERVICE_TOKEN }} # optional
```

### 12. Go Build (`.github/workflows/go-build.yaml`)
Builds Go applications with linting, tests, coverage export, and artifact packaging.

Usage
```yaml
jobs:
  go:
    uses: mtnvencenzo/workflows/.github/workflows/go-build.yaml@main
    with:
      go_version: '1.24.2'
      go_mod_directory: './cmd/app'
      go_main_directory: '.'
      go_output_directory: 'linux-amd64'
      go_executable_name: 'app'
      artifact_name: 'go-build-artifact'
      setup_files: '["README.md"]'
      version: '1.0.0'
```

### 13. Python Build (`.github/workflows/python-build.yaml`)
Builds Python applications with ruff linting, pytest testing, coverage reporting, and artifact packaging.

Usage
```yaml
jobs:
  python:
    uses: mtnvencenzo/workflows/.github/workflows/python-build.yaml@main
    with:
      python_version: '3.12'
      working_directory: './data-extraction-agent'
      requirements_file: 'requirements.txt'
      ruff_config: '.ruff.toml'
      pytest_args: '-v'
      upload_artifact: true
      artifact_name: 'python-build-artifact'
      setup_files: '["README.md","LICENSE"]'
      version: '1.0.0'
```

## 🧩 Composite Actions

These are step-level actions you can compose inside your own workflows.

### api-call (`.github/actions/api-call`)
Makes an API call with retry logic and verifies the expected status code.

```yaml
- name: Call API
  uses: mtnvencenzo/workflows/.github/actions/api-call@main
  with:
    url: 'https://service/health'
    statusCode: '200'
    enabled: true
    method: 'GET'
    authHeader: 'Authorization' # optional
  env:
    AUTH_VALUE: ${{ secrets.SERVICE_TOKEN }} # optional
```

### check-release-version (`.github/actions/check-release-version`)
Polls an endpoint until the version property matches `expected_release_version+expected_tag` or times out.

```yaml
- name: Verify deployed version
  uses: mtnvencenzo/workflows/.github/actions/check-release-version@main
  with:
    expected_release_version: '1.2.3'
    expected_tag: 'build42'
    url: 'https://service/version.json'
    property_name: 'version'
    auth_header: 'Authorization' # optional
    timeout_seconds: '300'        # optional
  env:
    AUTH_VALUE: ${{ secrets.SERVICE_TOKEN }} # optional
```

### create-release (`.github/actions/create-release`)
Creates a GitHub release with the provided tag/name.

```yaml
- name: Create release
  uses: mtnvencenzo/workflows/.github/actions/create-release@main
  with:
    version: 'v1.2.3'
```

## 📝 How to Use

1. Reference a workflow using `uses: mtnvencenzo/workflows/<path>@<tag-or-sha>`
2. Provide required inputs and any needed secrets
3. Pin to a tag or commit SHA for reproducible builds

## 🔐 Permissions and Secrets

- Some workflows require repository or environment secrets (noted in examples).
- Prefer least-privilege permissions and pass only the secrets required.

## 🔧 Requirements

- GitHub Actions enabled on your repository
- Required permissions and secrets configured

## 🌐 Community & Support

- 🤝 **Contributing Guide** – review expectations and workflow in [CONTRIBUTING.md](./.github/CONTRIBUTING.md)  
- 🤗 **Code of Conduct** – help us keep the community welcoming by reading [CODE_OF_CONDUCT.md](./.github/CODE_OF_CONDUCT.md)  
- 🆘 **Support Guide** – find help channels in [SUPPORT.md](./.github/SUPPORT.md)  
- 🔒 **Security Policy** – report vulnerabilities responsibly via [SECURITY.md](./.github/SECURITY.md) 

## 📄 License

This project is proprietary software. All rights reserved. See the full license in [LICENSE](./LICENSE).