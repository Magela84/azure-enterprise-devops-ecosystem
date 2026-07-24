# azure-enterprise-devops-ecosystem# Enterprise Azure DevOps Ecosystem: Multi-Environment IaC, CI/CD, & Automated Monitoring

A production-ready, secure, and fully automated Azure infrastructure ecosystem spanning Development, Staging, and Production environments. This project eliminates configuration drift, enforces rigorous compliance gates, and replaces manual infrastructure oversight with 24/7 proactive monitoring and alerting.

## 1. Executive Summary & Business Value

### The Business Challenge
Manual infrastructure modifications introduce human error, cause costly environment drift, and lack a reliable audit trail. Additionally, relying on engineering teams to manually watch dashboards around the clock leads to operational fatigue, delayed incident responses, and unnecessary overhead costs.

### The Solution
This project establishes a unified **Three-Tier DevOps Portfolio** that automates the entire lifecycle of cloud infrastructure for enterprise applications (e.g., a Digital Patient Check-In System):
*   **Consistency:** Infrastructure is defined completely as code (IaC) via Terraform, ensuring identical setups across Dev, Staging, and Prod.
*   **Compliance & Governance:** A robust CI/CD pipeline enforces automated validation, automated syntax checks, and mandatory human approval gates before changes hit production.
*   **Self-Watching Operations:** Continuous automated telemetry scanning monitors system health 24/7, alerting engineers via automated chat/email integrations only when a threshold is breached.
*   **Zero-Trust Isolation:** Deploys a fully hidden Ubuntu Linux Virtual Machine with zero public IP addresses, linked directly to an encrypted Azure Storage Account with public internet access completely disabled.

---

## 2. Technical Architecture & Specifications

### Architecture Diagram
```text
[Developer Git Push] ➔ [GitHub Actions Pipeline] ➔ [Terraform Validation] ➔ [Approval Gate]
                                                                                │
                                                            [Azure Cloud Architecture Base]
                                                            ├── VNet & Secure Subnet (East US)
                                                            ├── Network Security Group (NSG Firewall)
                                                            ├── Isolated Ubuntu Linux VM (Compute Layer)
                                                            └── Encrypted Storage Account (Data Layer)
                                                                                │
                                                                 [Azure Monitor & Log Analytics]
                                                                                │
                                                                 [KQL Queries ➔ Logic App Alert]
```

### Technology Stack
*   **Cloud Platform:** Microsoft Azure (Virtual Networks, Network Security Groups, Linux Virtual Machines, Storage Accounts)
*   **Infrastructure as Code:** Terraform (Remote State Backend, State Locking via Azure Blob Storage)
*   **CI/CD Automation:** GitHub Actions (Branch Protection, Secrets Management, Pull Request Gates)
*   **Observability & Operations:** Azure Monitor, Log Analytics Workspace, Kusto Query Language (KQL), Azure Logic Apps

### Repository Structure
```text
├── .github/workflows/      # CI/CD pipeline definitions (terraform-validate.yml)
├── terraform/
│   ├── main.tf             # Core configuration, network boundaries, compute, and data layers
│   ├── variables.tf        # Generic definition and blueprint placeholders
│   ├── Backend.tf          # Remote state file configuration and locking
│   └── environments/
│       ├── dev.tfvars      # Development sandbox environment configuration parameters
│       └── prod.tfvars     # High-performance Production environment parameters
└── monitoring/             # Telemetry configurations
    ├── cpu-alert.kql       # Custom KQL log analytics monitoring query
    └── alert-payload.json  # Structured Logic App alerting webhook schema
```

---

## 3. Production-Grade Design Decisions

During the architecture phase, specific engineering decisions were made to address enterprise scaling realities:

*   **Remote State File Locking:** Implemented a remote backend using Azure Blob Storage. This guarantees a single source of truth for the cloud state and enforces native state locking. It prevents concurrent pipeline runs from corrupting infrastructure configurations when multiple developers commit changes simultaneously.
*   **Dynamic Parameter Separation:** Used `.tfvars` files to cleanly separate environmental values from the core template logic. This enables the team to spin up micro-sized resources for testing (`dev.tfvars`) to manage company budgets while deploying heavy, high-performance nodes for the user baseline (`prod.tfvars`) using the exact same master files.
*   **Strict Security Isolation via NSGs:** Implemented network isolation by associating specific Network Security Groups (NSGs) with every subnet. All inbound public internet traffic is blocked by default, allowing only explicit administrative access via securely configured pathways.
*   **Noise-Reduced Alerting via KQL:** Instead of basic metric alerts that cause "alert fatigue," custom Kusto Query Language (KQL) scripts pull records directly from the Log Analytics Workspace. Alerts only fire if anomalous behavior persists across multiple evaluation windows, keeping engineer notifications highly actionable.
