# GitHub Reusable Workflows

This repository contains a collection of reusable GitHub Actions workflows that I use across my projects. These workflows are designed to be called from other repositories within my GitHub account.

## 🚀 Available Workflows

### 1. NPM Package Publish
**File:** `.github/workflows/npm-package-publish.yaml`

Automates the process of publishing NPM packages to the registry. Handles versioning, building, and publishing of Node.js packages.

#### Usage
```yaml
jobs:
  publish:
    uses: mtnvencenzo/workflows/.github/workflows/npm-package-publish.yaml@main
    with:
      # Input parameters
      node-version: '18'
      registry-url: 'https://registry.npmjs.org'
```

### 2. Terraform Plan and Apply
**File:** `.github/workflows/terraform-plan-and-apply.yaml`

Manages Terraform infrastructure deployments with plan and apply stages. Includes state management and workspace handling.

#### Usage
```yaml
jobs:
  terraform:
    uses: mtnvencenzo/workflows/.github/workflows/terraform-plan-and-apply.yaml@main
    with:
      # Input parameters
      terraform-version: '1.5.0'
      working-directory: './terraform'
```

### 3. Azure Blob Upload
**File:** `.github/workflows/azure-blob-upload.yaml`

Uploads files to Azure Blob Storage. Useful for deploying static assets or build artifacts.

#### Usage
```yaml
jobs:
  upload:
    uses: mtnvencenzo/workflows/.github/workflows/azure-blob-upload.yaml@main
    with:
      # Input parameters
      source-path: './dist'
      container-name: 'my-container'
```

### 4. UI Storybook Build and Deploy
**File:** `.github/workflows/ui-storybook-build-deploy.yaml`

Builds and deploys Storybook documentation for UI components. Includes caching and artifact handling.

#### Usage
```yaml
jobs:
  storybook:
    uses: mtnvencenzo/workflows/.github/workflows/ui-storybook-build-deploy.yaml@main
    with:
      # Input parameters
      node-version: '18'
      build-command: 'build-storybook'
```

### 5. Warmup Request
**File:** `.github/workflows/warmup-request.yaml`

Makes HTTP requests to keep applications warm and prevent cold starts. Useful for serverless applications.

#### Usage
```yaml
jobs:
  warmup:
    uses: mtnvencenzo/workflows/.github/workflows/warmup-request.yaml@main
    with:
      # Input parameters
      url: 'https://your-app.azurewebsites.net'
      interval: '15'
```

### 6. UI Build
**File:** `.github/workflows/ui-build.yaml`

Builds frontend applications with optimized caching and artifact handling.

#### Usage
```yaml
jobs:
  build:
    uses: mtnvencenzo/workflows/.github/workflows/ui-build.yaml@main
    with:
      # Input parameters
      node-version: '18'
      build-command: 'build'
```

### 7. Docker Build and Push
**File:** `.github/workflows/docker-build-and-push.yaml`

Builds Docker images and pushes them to a container registry. Supports multi-platform builds.

#### Usage
```yaml
jobs:
  docker:
    uses: mtnvencenzo/workflows/.github/workflows/docker-build-and-push.yaml@main
    with:
      # Input parameters
      image-name: 'my-app'
      registry: 'ghcr.io'
```

### 8. NuGet Pack and Push
**File:** `.github/workflows/nuget-pack-and-push.yaml`

Builds and publishes .NET packages to NuGet. Handles versioning and package signing.

#### Usage
```yaml
jobs:
  nuget:
    uses: mtnvencenzo/workflows/.github/workflows/nuget-pack-and-push.yaml@main
    with:
      # Input parameters
      project-path: './src/MyProject.csproj'
      nuget-source: 'https://api.nuget.org/v3/index.json'
```

### 9. API Build
**File:** `.github/workflows/api-build.yaml`

Builds and tests .NET API projects with comprehensive testing and artifact handling.

#### Usage
```yaml
jobs:
  api:
    uses: mtnvencenzo/workflows/.github/workflows/api-build.yaml@main
    with:
      # Input parameters
      solution-path: './MyApi.sln'
      test-path: './tests'
```

### 10. Cypress Runner
**File:** `.github/workflows/cypress-runner.yaml`

Runs Cypress end-to-end tests with parallel execution and video recording.

#### Usage
```yaml
jobs:
  cypress:
    uses: mtnvencenzo/workflows/.github/workflows/cypress-runner.yaml@main
    with:
      # Input parameters
      cypress-version: '12.0.0'
      parallel: 'true'
```

## 📝 How to Use

1. Reference the workflow in your repository's workflow file
2. Provide the required input parameters
3. The workflow will execute with the specified configuration

## 🔧 Requirements

- GitHub Actions enabled on your repository
- Required permissions and secrets configured
- Any other prerequisites

## 🤝 Contributing

While this repository is primarily for personal use, suggestions and improvements are welcome. Feel free to:
- Open an issue to discuss potential improvements
- Submit a pull request with enhancements
- Share your feedback on workflow efficiency

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👤 Author

- GitHub: [@mtnvencenzo](https://github.com/mtnvencenzo)

## ⭐ Show Your Support

If you find these workflows helpful, please consider giving this repository a star!
