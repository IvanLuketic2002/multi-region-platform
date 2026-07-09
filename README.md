# Multi-Region Enterprise Platform

Production-grade high-availability and fault-tolerant infrastructure deployed across multiple AWS regions. Simulates real enterprise DevOps workflow — GitHub Actions automatically builds, pushes, and deploys the containerized application to all geographic regions simultaneously on every push, with automated health monitoring.

## Architecture

```
               GitHub Push
                    │
                    ▼
          GitHub Actions CI/CD
         ┌──────────┴──────────┐
         ▼                     ▼
    AWS Region 1          AWS Region 2
   (eu-central-1)         (eu-west-3)
  Frankfurt EC2          Paris EC2
         │                     │
         ├─────────────────────┤
         ▼                     ▼
     Docker Container      Docker Container
      (:8000 Public)        (:8000 Public)
         ▲                     ▲
         └──────────┬──────────┘
                    │
         AWS Route 53 Health Checks
         (30s Interval / 3x Threshold)
```

## Features

- **Multi-Region Deployment** — Active-Active/Passive infrastructure distributed across Frankfurt (eu-central-1) and Paris (eu-west-3) for global low-latency.
- **Automated Self-Healing & Disaster Recovery** — Proven resiliency against regional failure; infrastructure survives container/regional crashes with automatic recovery.
- **AWS Route 53 Health Checks** — Continuous background monitoring (30s intervals) to track system health and signal failover.
- **Smart CI/CD Pipeline** — GitHub Actions with parallel deployment matrix and race-condition handlers for cloud daemon orchestration.
- **Infrastructure as Code (IaC)** — Fully provisioned and destroyed via Terraform (VPCs, Security Groups, Internet Gateways, and EC2).
- **Dockerized Backend** — Lightweight containerized microservice exposed on public ports.

## Tech Stack

- **Docker** - Containerization & isolation
- **Docker Hub** - Image registry
- **Terraform** - Infrastructure as Code (IaC)
- **GitHub Actions** - CI/CD pipeline automation
- **AWS EC2 (Ubuntu 22.04 LTS)** - Multi-region cloud hosting
- **AWS VPC & Networking** - Isolated regional virtual networks
- **AWS Route 53** - Global health checking & DNS routing

## Repository Structure

| File / Folder | Description |
|---------------|-------------|
| terraform/main.tf | Infrastructure definition (VPCs, Instances, Route 53 Health Checks) |
| terraform/variables.tf | Environment configuration and regional variables |
| .github/workflows/deploy.yml | GitHub Actions pipeline utilizing multi-region deploy matrix |
| platform.sh | Custom CLI utility wrapper for local pipeline and git automation |
| src/ | Backend application source code and Dockerfile |

## CI/CD Pipeline

Every push to `main` branch:

1. Triggers parallel GitHub Actions matrix runners for both AWS regions.
2. Builds production-ready Docker image and pushes it to Docker Hub.
3. Securely connects to target EC2 instances via SSH keys.
4. Implements intelligent wait checks for the host's Docker daemon initialization.
5. Executes zero-downtime deployment by rolling out the newest container with `--restart always`.

## Quick Start

```bash
# Clone the repository
git clone https://github.com/IvanLuketic2002/multi-region-platform.git
cd multi-region-platform

# Provision infrastructure through IaC
cd terraform
terraform init
terraform apply -auto-approve

# Trigger automated multi-region deployment
cd ..
./platform.sh push "Deploying enterprise stack to Frankfurt and Paris"

# Test availability
curl http://<FRANKFURT_IP>:8000/
curl http://<PARIS_IP>:8000/
```

## GitHub Secrets Required

| Secret | Description |
|--------|-------------|
| DOCKERHUB_USERNAME | Docker Hub profile identity |
| DOCKERHUB_TOKEN | Docker Hub secure access token |
| SSH_PRIVATE_KEY | Private EC2 Key Pair (multi-region-key) for secure server configuration |

## Cost Optimization

```bash
cd terraform
terraform destroy -auto-approve
```

> **Cost Warning:** ~$0.03/hour for running multiple cross-region EC2 t3.micro/t3.small workloads and monitoring health checks. Always run `terraform destroy` after demonstration to completely clean up the 12 cloud resources and prevent charges.
