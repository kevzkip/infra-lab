# Environment Setup

This guide covers how to set up a fresh Linux environment to develop and run this documentation site. The setup assumes a Debian-based distribution (like Ubuntu) and uses Docker to ensure the environment is identical across all machines.

## 1. Prerequisites

You need a native Linux environment. If you are on a server or a Linux desktop, you are ready. Ensure your system is up to date:

```bash
sudo apt update && sudo apt upgrade -y
```

## 2. Install Git

Git is required to clone the repository and manage version control.

```bash
sudo apt install git -y
```

Verify the installation:

```bash
git --version
```

Configure your identity so your commits are attributed correctly:

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

## 3. Install Docker Engine

We use Docker to isolate the documentation dependencies and ensure the site builds exactly the same way in production (CI/CD) as it does locally.

First, install the required prerequisites:

```bash
sudo apt install ca-certificates curl gnupg -y
```

Add Docker's official GPG key and repository:

```bash
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

Update the package index and install Docker:

```bash
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
```

Allow your user to run Docker without `sudo` (you will need to log out and back in, or run `newgrp docker`):

```bash
sudo usermod -aG docker $USER
```

Verify Docker is running:

```bash
docker run hello-world
```

## 4. Clone the Repository

Create a workspace directory and clone the project:

```bash
mkdir -p ~/projects
cd ~/projects
git clone git@github.com:kevzkip/infra-lab.git
cd infra-lab
```

## 5. Start the Development Server

The project includes a `compose.yaml` file which defines the local development environment. It uses a bind mount to sync your local files into the container, so live-reload works perfectly.

Start the server:

```bash
docker compose up
```

The site is available at `http://localhost:8000/infra-lab/`. 

To stop the server, press `Ctrl+C` in the terminal, then run:

```bash
docker compose down
```

## 6. Editor Configuration (Optional)

For the best development experience, use an editor that supports language servers and integrated terminals. Visual Studio Code is recommended. 

Because the code is on the native Linux filesystem, you can simply open the folder from the terminal:

```bash
code .
```