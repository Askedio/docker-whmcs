# GitHub Actions Workflows

## Docker Build Workflow

The `docker-build.yml` workflow automatically builds and pushes Docker images to Docker Hub when:
- Code is pushed to `main` or `master` branch
- Changes are made to files in the `web/` directory
- Manually triggered via `workflow_dispatch`

### Setup

To enable automatic Docker Hub pushes, add these secrets to your GitHub repository:

1. Go to Settings → Secrets and variables → Actions
2. Add the following secrets:
   - `DOCKER_USERNAME`: Your Docker Hub username
   - `DOCKER_PASSWORD`: Your Docker Hub access token (not your password!)

### Getting a Docker Hub Access Token

1. Go to https://hub.docker.com/settings/security
2. Click "New Access Token"
3. Give it a name (e.g., "GitHub Actions")
4. Copy the token and add it as `DOCKER_PASSWORD` secret

### Image Tags

The workflow creates the following tags:
- `latest` - always points to the latest build from default branch
- `main` or `master` - branch name tag
- Semantic version tags (if you tag releases)
- PR number tags for pull requests

