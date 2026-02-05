# 🔐 Infra Security on Azure (IaC)

![License](https://img.shields.io/badge/License-MIT-green)
![Terraform](https://img.shields.io/badge/IaC-Terraform-blue)
![Azure](https://img.shields.io/badge/Cloud-Azure-0078D4)
![OPA](https://img.shields.io/badge/Policy-OPA-orange)
![Status](https://img.shields.io/badge/Project-Active-success)

> Secure Infrastructure as Code (IaC) implementation for Microsoft Azure using **Terraform**, **Open Policy Agent (OPA)**, and **automated testing** to enforce security controls and compliance.

---

## 📌 Table of Contents

- [Overview](#-overview)
- [Objectives](#-objectives)
- [Features](#-features)
- [Architecture](#-architecture)
- [Repository Structure](#-repository-structure)
- [Tech Stack](#-tech-stack)
- [Getting Started](#-getting-started)
- [Security Controls](#-security-controls)
- [Testing](#-testing)
- [CI/CD Pipeline](#-cicd-pipeline)
- [Author](#-Authot)

---

## 🚀 Overview

This project demonstrates a **security-first Infrastructure as Code (IaC)** approach for deploying and managing Azure cloud resources.

Security policies are embedded directly into the deployment pipeline to ensure:
- Misconfigurations are blocked early  
- Compliance is continuously enforced  
- Infrastructure changes remain auditable and repeatable  

---

## 🎯 Objectives

- Apply **shift-left security** in cloud infrastructure  
- Enforce **least privilege and secure defaults**  
- Integrate **policy-as-code** into Terraform workflows  

---

## 🧱 Features

### 🔐 Security & Compliance
- OPA policy enforcement using Rego  
- Encryption, networking and RBAC policies  
- Centralised policy library  

### 🏗️ Infrastructure as Code
- Modular Terraform structure  
- Environment separation (dev / prod)  
- Azure-native best practices  

### 🤖 Automation
- GitHub Actions CI/CD  
- Automated security checks  
- Infrastructure validation before apply  

---

## 🗺️ Architecture

```text
Developer → GitHub → GitHub Actions
                  ↓
           Terraform Plan
                  ↓
             OPA Policies
                  ↓
          Secure Azure Infra
```
---

## 📁 Repository Structure

.github/
└── workflows/         # CI/CD pipelines

policies/
└── *.rego             # OPA security policies

terraform/
└── environments/
    └── azure/         # Azure Terraform code

tests/
└── *.go               # Terratest test cases

---

## 🧰 Tech Stack

| Tool              | Purpose                     |
| ----------------- | --------------------------- |
| Terraform         | Infrastructure provisioning |
| Azure Provider    | Azure resource management   |
| Open Policy Agent | Policy-as-Code              |
| Rego              | Policy language             |
| Terratest         | Security testing            |
| GitHub Actions    | CI/CD pipeline              |
| Azure CLI         | Authentication & management |

---

## 🛠️ Getting Started

Prerequisites
- Terraform CLI
- Azure CLI
- Go (for Terratest)
- GitHub account

Setup
git clone https://github.com/Olebxgeng/infra-security-azure.git
cd infra-security-azure
az login
terraform init
terraform plan

---

## 🔒 Security Controls

This project enforces:
- Mandatory encryption
- Secure networking rules
- RBAC least privilege
- No public exposure by default
- Policy-based deployment blocking

---

## 🧪 Testing

Run infrastructure security tests:
go test ./tests/ -v

Tests validate:
- Policy enforcement
- Resource configuration
- Compliance alignment

---

## 🔄 CI/CD Pipeline

Every push triggers:
- Terraform validation
- OPA policy checks
- Security test execution
- Merge blocked if violations exist

---

## 👤 Author
Olebogeng Sebogodi
Security Engineering
GitHub: https://github.com/Olebxgeng








