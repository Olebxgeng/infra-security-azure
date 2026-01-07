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


OPA: Tests policies against plans (e.g., denies unencrypted resources).
Terratest: End-to-end checks (e.g., queries Azure APIs for encryption status).
Manual: Use Azure Portal to verify RBAC assignments and resource states.
CIS Benchmarks: Ensures alignment (e.g., 3.1 - Ensure Storage Accounts enforce HTTPS).
