# ⚠️ Golden Vulnerability Test Repository

> **WARNING**: This repository is **intentionally vulnerable**. It exists solely for testing Microsoft Defender for DevOps security scanners. **DO NOT** use any code, configuration, or dependency versions from this repo in production.

## Purpose

This repo is designed to trigger findings from **all 6 agentless security scanners** used by Microsoft Defender for DevOps, enabling end-to-end testing of detection, alerting, and cleanup workflows.

## Scanner Coverage Map

| File | Scanner | Category | What It Triggers |
|------|---------|----------|------------------|
| `main.tf` | **Checkov** | IaC | S3 public bucket, open security group, unencrypted RDS, no monitoring |
| `insecure.bicep` | **Template Analyzer** | IaC | HTTP-only storage, no SQL auditing, no Key Vault soft delete, no HTTPS |
| `src/app.js` | **ESLint** | Code Quality | `eval()`, `with`, `var`, loose equality, unused vars, `console.log` |
| `src/script.py` | **Bandit** | Code Quality | `exec()`, hardcoded passwords, `shell=True`, MD5/SHA1, pickle, SQLi |
| `package.json` | **Trivy** | Dependencies | lodash, minimist, express, axios, jsonwebtoken — all with known CVEs |
| `requirements.txt` | **Trivy** | Dependencies | Django, Flask, requests, Jinja2, cryptography, Pillow — known CVEs |
| `config/settings.json` | **Secrets Scanner** | Secrets | Fake AWS keys, GitHub tokens, Azure connection strings, API keys |
| `.env.example` | **Secrets Scanner** | Secrets | Fake credentials in env file format (AWS, Azure, DB, JWT, SSH) |

## Category Summary

| Category | Scanners | Files |
|----------|----------|-------|
| **Infrastructure as Code** | Checkov, Template Analyzer | `main.tf`, `insecure.bicep` |
| **Code Quality / Security** | ESLint, Bandit | `src/app.js`, `src/script.py` |
| **Dependency Vulnerabilities** | Trivy | `package.json`, `requirements.txt` |
| **Secrets Detection** | Secrets Scanner | `config/settings.json`, `.env.example` |

## Setup Instructions

```bash
cd C:\dev\golden-test-repo
git init
git add .
git commit -m "Initial commit: golden vulnerability test repository"
git branch -M main
git remote add origin https://github.com/DimaBir/golden-vuln-test.git
git push -u origin main
```

## Important Notes

- **All secrets are FAKE** — no real credentials are exposed in this repository.
- **All vulnerable versions are intentional** — do not run `npm audit fix` or update dependencies.
- **All misconfigurations are deliberate** — do not apply security fixes to the IaC templates.
- This repo should be **deleted or made private** after testing is complete.
