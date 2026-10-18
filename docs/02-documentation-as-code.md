# Documentation-as-Code & Static Site Generation

## 1. Objective

Transition from manual note-taking to a professional Docs-as-Code pipeline. This module establishes an automated, version-controlled documentation site using MkDocs and the Material for MkDocs theme, containerized for consistent local development and deployed via GitHub Actions.

---

## 2. Engineering Principles & Decisions

*   **Docs-as-Code Paradigm:** Documentation is treated with the same rigor as application code—stored in Git, version-controlled, and automatically compiled and deployed on every push.
*   **Environment Isolation (Docker):** Instead of relying on the host OS to have the correct Python and MkDocs versions installed, the local development environment is entirely containerized using Docker. This ensures that any engineer can clone the repo and run the site without modifying their host system.
*   **Deterministic Navigation:** MkDocs maps URLs directly to filenames. By using `index.md` for the root, we ensure the site loads cleanly at `/infra-lab/`. Navigation order is strictly controlled via the `nav:` block in `mkdocs.yml`, not by filename prefixes.

---

## 3. Implementation Workflow

### Step 1: Containerizing the Environment
To run MkDocs without installing Python on the host machine, we define a `Dockerfile` using a `slim` Python base image. Because the RSS plugin requires Git to read commit history, we install `git` inside the container.

```dockerfile
FROM python:3.12-slim
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 8000
CMD ["mkdocs", "serve", "--dev-addr=0.0.0.0:8000"]
```

### Step 2: Orchestration with Docker Compose
A `compose.yaml` file handles the container lifecycle and mounts the local directory into the container. This bind mount ensures that when a Markdown file is edited locally, the container detects the change and triggers MkDocs' live-reload.

```yaml
services:
  docs:
    build: .
    ports:
      - "8000:8000"
    volumes:
      - .:/app
```

### Step 3: Configuring the Engine (`mkdocs.yml`)
The configuration file dictates the visual schema, feature enhancements, and navigation mapping. It enforces `strict: true`, which fails the build if any broken internal links or missing navigation entries are found.

```yaml
site_name: Infra Lab
site_url: https://kevzkip.github.io/infra-lab/
theme:
  name: material
  palette:
    - scheme: slate
  features:
    - navigation.instant
    - content.code.copy
```

### Step 4: Local Preview Loop
To test modifications live before pushing to remote repositories:

```bash
docker compose up
```

This spins up a local development web server with hot-reloading active on `http://localhost:8000/infra-lab/`.

---

## 4. Repository Hygiene & Git Configuration

To maintain a clean state, build artifacts and local runtimes (`venv/`, `site/`, `__pycache__/`) are excluded from Git via `.gitignore`. 

Additionally, a `.dockerignore` file prevents local build artifacts and Git history from being sent to the Docker daemon, drastically speeding up the image build context.