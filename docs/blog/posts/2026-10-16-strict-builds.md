---
date: 2026-10-16 08:30:00 +03:00
categories:
  - ci-cd
tags:
  - docker
  - github-actions
  - mkdocs
---

# Containerizing MkDocs and wiring strict CI/CD

The docs site was already deploying. The problem was *how* it was deploying.

## The old pipeline

The original workflow ran `mkdocs gh-deploy --force` with `contents: write` on
the workflow token. That works. It also does three things I didn't want:

1. Pushes the built site as commits to a `gh-pages` branch, polluting the
   repo's commit history with bot commits.
2. Grants the workflow write access to the repo, which it doesn't need.
3. Depends on an unpinned `mkdocs-material`, so a bad upstream release breaks
   the build with no local change to explain it.

## The new pipeline

Two jobs, `build` and `deploy`. Build produces a Pages artifact; deploy
publishes it. Build uses `mkdocs build --strict`, which fails on any warning —
broken links, missing nav entries, unknown anchors. Nothing reaches the live
site unless it builds clean.

Permissions are scoped to what each job needs: `contents: read` for checkout,
`pages: write` and `id-token: write` for the deploy. No write access to the
repo. No `gh-pages` branch.

Dependencies are pinned in `requirements.txt`. `pip install -r
requirements.txt` installs the same versions on every machine, every run.

## Containerizing the dev environment

To ensure the site runs identically on any machine, I containerized the local
development environment using Docker. 

Building the Docker image initially hit a snag: I used the `python:3.12-slim`
base image, which is great for keeping the image small, but it strips out
non-essential tools — including `git`. Because the RSS plugin relies on
`GitPython`, the build crashed. The fix was adding `RUN apt-get install -y git`
to the Dockerfile.

By using Docker Compose with bind mounts, live-reload works perfectly. You edit
a Markdown file on the host machine, and the container sees the change
instantly, triggering a rebuild without ever installing Python on the host.

## What broke along the way

The home page was named `00-index.md`. MkDocs maps filenames to URLs almost
literally, so that became `/infra-lab/00-index/` instead of `/infra-lab/`.
Renaming it to `index.md` fixed the root URL. The `00-` prefix was a leftover
from an ordering trick that MkDocs doesn't actually need — nav order comes
from the `nav:` list, not the filename.

## Why this matters beyond one repo

The pipeline is small, but the shape is the one that scales: build once,
publish the artifact, keep permissions minimal, pin what you depend on, fail
loudly on warnings. The same pattern shows up in every serious CI/CD setup,
whether it's a docs site or a fleet of services.