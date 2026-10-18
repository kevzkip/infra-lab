<div align="center">
  <a href="https://github.com/kevzkip/infra-lab/actions/workflows/deploy.yml">
    <img src="https://github.com/kevzkip/infra-lab/actions/workflows/deploy.yml/badge.svg" alt="CI/CD Status">
  </a>
  <img src="https://img.shields.io/badge/MkDocs-9.7.0-blue?logo=mkdocs&logoColor=white" alt="MkDocs">
  <img src="https://img.shields.io/badge/Docker-Ready-2496ED?logo=docker&logoColor=white" alt="Docker">
  <img src="https://img.shields.io/badge/OS-Linux-FCC624?logo=linux&logoColor=black" alt="Linux">
  <img src="https://img.shields.io/badge/Deployed_on-GitHub_Pages-222222?logo=github-pages&logoColor=white" alt="GitHub Pages">
</div>

# 🏗️ Infra Lab

Welcome to the engineering log and artifact repository for **Infra Lab**. 

This site documents hands-on work in Linux, containers, observability, and CI/CD. It is a working lab—a place where systems are built, broken, and documented.

## 🎯 Focus Areas

- **Linux Systems:** Native Linux administration, shell scripting, and filesystem architecture.
- **Containers & Orchestration:** Docker, Docker Compose, and eventually Kubernetes.
- **Observability:** Metrics, logging, and tracing (Prometheus, Grafana).
- **Automation:** CI/CD pipelines, infrastructure as code, and reliable deployments.

## 📂 How this site is organized

- **[Environment Setup](01-environment-setup.md):** How to provision the Linux development environment and run this site locally using Docker.
- **[Documentation as Code](02-documentation-as-code.md):** The architecture and engineering principles behind this static site pipeline.
- **[Blog](blog/index.md):** Post-mortems, deep dives, and notes on specific technical problems and solutions.

## 🛠️ The Stack

This site is built as a static site using **MkDocs Material**, containerized with **Docker**, and deployed automatically to **GitHub Pages** via **GitHub Actions**. 

To run the site locally, see the [Environment Setup](01-environment-setup.md) guide.