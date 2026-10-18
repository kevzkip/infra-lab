# 🏗️ Infra Lab

A systems engineering lab: Linux, Go, containers, observability, and the CI/CD
that ties them together.

This repo holds the tooling, configuration, and documentation behind my work in
systems and infrastructure engineering.

## 🧰 Stack

| Layer             | Tool                         |
| ----------------- | ---------------------------- |
| Docs framework    | MkDocs Material 9.7.0        |
| Language (docs)   | Python 3.12                  |
| Containerization  | Docker & Docker Compose      |
| CI/CD             | GitHub Actions               |
| Hosting           | GitHub Pages                 |
| Environment       | Native Linux (Ubuntu)        |

## 📁 Repository layout

```text
.
├── .github/
│   └── workflows/
│       └── deploy.yml              # CI/CD — build and deploy the docs site
├── docs/                           # Markdown source for the published site
│   ├── blog/                       # Blog posts and RSS configuration
│   ├── stylesheets/                # Custom CSS for the UI
│   ├── index.md                    # Home page
│   ├── 01-environment-setup.md
│   └── 02-documentation-as-code.md
├── Dockerfile                      # Container definition for local dev
├── compose.yaml                    # Docker Compose orchestration
├── mkdocs.yml                      # MkDocs configuration
├── requirements.txt                # Pinned Python dependencies
└── README.md
```

## 💻 Local development

Requires Docker and Docker Compose. Tested on Ubuntu Linux.

To run the site locally with live reload:

```bash
docker compose up
```

The site is available at `http://localhost:8000/infra-lab/`. Edits to files in `docs/` or `mkdocs.yml` trigger an automatic rebuild.

To stop the container:

```bash
docker compose down
```

## 🚀 Deployment

Deployment is handled by GitHub Actions on every push to `main`.

Pipeline stages:

1. Checkout the repo, set up Python 3.12 with pip caching.
2. Install dependencies from `requirements.txt`.
3. Run `mkdocs build --strict`.
4. Upload `site/` as a Pages artifact.
5. Publish the artifact to GitHub Pages.

The build and deploy steps run as separate jobs — deploy only proceeds if build
succeeds. A failed build does not touch the live site.

Live site: <https://kevzkip.github.io/infra-lab/>

## 📌 Versioning policy

Top-level dependencies are pinned exactly (e.g. `mkdocs-material==9.7.0`).
Transitive dependencies are not pinned. If a transitive package ever breaks a
build, it gets pinned with an inline comment explaining why.