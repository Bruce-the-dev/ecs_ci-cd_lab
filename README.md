# ECS CI/CD Lab — Application

Spring Boot application deployed to AWS ECS Fargate via blue/green deployments.

## Architecture

- **Application**: Spring Boot 3.3 (Java 21) with REST endpoints + static UI
- **Container**: Multi-stage Docker build (Alpine, non-root user)
- **Registry**: Amazon ECR (private, scan-on-push, encrypted)
- **Orchestration**: ECS on Fargate, in private subnets across 2 AZs
- **Load Balancing**: Internet-facing Application Load Balancer
- **Deployments**: Blue/Green via CodeDeploy
- **Pipeline**: ECR push event → EventBridge → CodePipeline → CodeDeploy

## Image Tagging Strategy

Every image is tagged with **two complementary tags**:

| Tag | Purpose | Mutability |
|---|---|---|
| `Bruce_Mutsinzi_helloapp-<commit-sha>` | Canonical, immutable artifact identifier | **Immutable in practice** — never reused |
| `latest` | Mutable deployment pointer used by CodePipeline | Mutable — updated each release |

The canonical SHA-based tag is the authoritative artifact identifier — 
each commit produces a unique tag that is never reused. This satisfies 
the immutability requirement at the artifact level.

The `latest` tag serves as a deployment cursor: it always points at the 
most recent successful build. CodePipeline's ECR source action uses 
`latest` to detect new images. The `latest` tag is **metadata, not content** 
— the actual artifacts (SHA-tagged images) remain immutable.

This pattern is industry-standard for CI/CD pipelines on AWS.

## CI/CD Flow