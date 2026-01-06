Infrastructure as Code with Security Policies (Azure-Focused)

Overview

This project demonstrates a secure, version-controlled Infrastructure as Code (IaC) setup for Azure using Terraform. It enforces security policies with Open Policy Agent (OPA) to ensure compliance with standards like CIS (Center for Internet Security) benchmarks, focusing on mandatory encryption, access controls, and Role-Based Access Control (RBAC) with least privilege. Automated tests via Terratest validate configurations, integrating security into the development lifecycle to prevent misconfigurations, data breaches, and unauthorized access.

Key goals:

Security-First IaC: Embed policies (e.g., encryption on Storage Accounts and VMs, no public access) directly into code changes.
Azure-Specific: Provisions resources like Resource Groups, VNets, Storage Accounts, VMs, and RBAC assignments.
Automation: CI/CD pipelines run OPA checks and tests on every pull request, blocking insecure deployments.
Compliance: Aligns with CIS benchmarks for encryption, access controls, and RBAC.
This project promotes "shift-left" security, where issues are caught early in version control rather than post-deployment.

Features

Terraform Provisioning: Multi-environment Azure infrastructure (e.g., dev/prod) with reusable modules.
OPA Policy Enforcement: Rego-based rules deny non-compliant resources (e.g., unencrypted Storage Accounts or VMs without RBAC).
Automated Testing: Terratest validates CIS benchmarks (e.g., encryption enabled, access restricted) using Azure APIs.
RBAC and Least Privilege: Assigns minimal roles (e.g., Reader, Contributor) via azurerm_role_assignment.
CI/CD Integration: GitHub Actions automate validation on pushes/PRs.
Security Enhancements: Includes network isolation, monitoring, secrets management, and compliance automation.
Version Control: Git tracks all changes for auditability and rollbacks.
Prerequisites

Azure Account: Active subscription with Contributor or Owner role. Use Azure CLI (az login) for authentication.
Tools:
Terraform v1.0+ (install from terraform.io).
OPA/Conftest (install via brew install opa or opa.openpolicyagent.org).
Go 1.18+ (for Terratest: go get github.com/gruntwork-io/terratest).
Git and a code editor (e.g., VS Code with Terraform extension).
Knowledge: Basic Terraform, Azure concepts (e.g., Resource Groups, RBAC), and Rego (OPA's policy language).
Azure-Specific Setup:
Create a Service Principal for Terraform: az ad sp create-for-rbac --name "terraform-sp" --role Contributor --scopes /subscriptions/<subscription-id>.
Store credentials securely (e.g., in environment variables or Azure Key Vault).
Ensure SSH keys exist for VM access (ssh-keygen if needed).


Project Structure



infra-security-azure/
├── terraform/
│   ├── modules/          # Reusable Terraform modules (e.g., for VNets, VMs)
│   ├── environments/     # Per-environment configs
│   │   └── azure/
│   │       ├── main.tf   # Core Azure infrastructure and RBAC
│   │       └── variables.tf  # Input variables
│   └── outputs.tf        # Outputs (e.g., resource IDs)
├── policies/             # OPA Rego policies
│   ├── encryption.rego   # Enforces encryption on Storage/VMs
│   └── access_control.rego  # Enforces access controls and RBAC
├── tests/                # Terratest Go files
│   └── azure_test.go     # CIS benchmark validations
├── .github/workflows/    # CI/CD pipelines
│   └── ci.yml            # GitHub Actions for OPA and tests
├── conftest.toml         # Conftest configuration
├── .gitignore            # Excludes .tfstate, secrets
└── README.md             # This file


Installation and Setup

Clone the Repository:

git clone <your-repo-url>
cd infra-security-azure


Install Dependencies:

Terraform: terraform --version (should show v1.0+).
OPA: opa version.
Go: go version.
Azure CLI: az --version.
Configure Azure Credentials:

Set environment variables or use az login:

export ARM_CLIENT_ID="<sp-client-id>"
export ARM_CLIENT_SECRET="<sp-secret>"
export ARM_SUBSCRIPTION_ID="<subscription-id>"
export ARM_TENANT_ID="<tenant-id>"


Initialize Terraform:


cd terraform/environments/azure
terraform init


Customize Values:

Edit main.tf for unique names (e.g., storage account must be globally unique).
Update principal IDs in RBAC assignments (e.g., az ad user show --id user@example.com --query id -o tsv).
Usage


Provision Infrastructure

Validate and Plan:

terraform validate
terraform plan -out=plan.json


Enforce Policies with OPA:


conftest test plan.json --policy ../../policies/
This checks for encryption, access controls, and RBAC. Fix any denials before proceeding.


Apply Changes:

terraform apply plan.json
Deploys to Azure. Monitor costs and use terraform destroy to clean up.


Run Automated Tests

Execute Terratest:

cd tests
go test -v ./...
Validates CIS compliance (e.g., encryption on Storage Accounts). Requires Azure credentials.


CI/CD Pipeline

On push/PR, GitHub Actions runs:
Terraform validation.
OPA policy checks.
Terratest.
Configure secrets in GitHub (e.g., AZURE_CREDENTIALS as JSON).
Security Enhancements

Beyond basics, the project includes:

Encryption: HTTPS-only on Storage, host/disk encryption on VMs.
Access Controls: No public blob access, SSH key-only auth on VMs.
RBAC/Least Privilege: Assigns minimal roles (e.g., Reader on RG, Contributor on Storage).
Network Isolation: VNets, subnets, and NSGs restrict traffic.
Monitoring: Integrate Azure Monitor for logs/alerts (add azurerm_monitor_diagnostic_setting).
Secrets Management: Use Azure Key Vault for SSH keys/secrets.
Compliance Automation: OPA denies non-compliant resources; extend for MFA/patching.
Vulnerability Scanning: Add Azure Security Center for scans.
Backup/DR: Include Azure Backup for resilience.
Zero-Trust: Enforce conditional access and micro-segmentation.
To improve further:

Add custom roles via azurerm_role_definition.
Schedule audits with Azure Advisor.
Use Sentinel for advanced Terraform policies.
Testing and Validation

OPA: Tests policies against plans (e.g., denies unencrypted resources).
Terratest: End-to-end checks (e.g., queries Azure APIs for encryption status).
Manual: Use Azure Portal to verify RBAC assignments and resource states.
CIS Benchmarks: Ensures alignment (e.g., 3.1 - Ensure Storage Accounts enforce HTTPS).
