# Day 2: Temporary User Setup with Expiry ⏳

## Business & Infrastructure Context
### Why this matters in real projects?
In enterprise environments, access management is a high-stakes game. Managing short-term access for third-party vendors, auditors, or temporary contractors is a common requirement.

### Where it lives:
- **Infra / Security**: Part of the Onboarding/Offboarding automation.
- **CI/CD**: Temporary accounts might be created for specific deployment tasks or security scans.

### Business Value:
- **Compliance**: Standards like SOC2, ISO 27001, and PCI-DSS strictly require that access is granted for the minimum period necessary.
- **Cost Reduction**: Automating the "expiry" reduces manual overhead and the risk of forgotten accounts.

### Risks:
- **"Zombie" Accounts**: Stale accounts with active access are one of the most common vectors for lateral movement after an initial compromise.

## Lab Breakdown (Step-by-Step)
### Phase 1: Environment Preparation
### Step 1
```bash
# Verify the current date to plan the expiry
date
```
**Expected Result:** Current system date and time displayed.

### Phase 2: User Creation
### Step 1
```bash
# Create a user that expires on a specific date
# -e YYYY-MM-DD: set the date the account is disabled
sudo useradd -e 2026-12-31 -c "Temporary External Consultant" temp_consultant
```
**Expected Result:** User `temp_consultant` created without errors.

### Phase 3: Verification
### Step 1
```bash
# Use 'chage' to inspect the account aging metadata
sudo chage -l temp_consultant
```
**Expected Result:** A report showing `Account expires: Dec 31, 2026`.

## DevOps Context & Alternatives
### Cloud-native approach:
In **AWS**, we use **IAM Temporary Security Credentials** via STS (Security Token Service). In **Kubernetes**, we use **Service Accounts** with tokens that have a specific TTL (Time To Live).

### Alternatives:
- **Ansible**: Using the `user` module with the `expires` parameter.
- **Vault (HashiCorp)**: Dynamic SSH secrets that generate credentials valid for minutes or hours.

## Junior Pitfalls (Common Mistakes ⚠️)
- **Timezone Mismatch**: Setting an expiry date without checking the server's UTC/Local time conversion.
- **Manual Cleanup**: Thinking that the user is *deleted* on expiry. Expiry only disables the account; the data and ID remain.
- **Security Audit Failure**: Forgetting to set a password or SSH keys, leaving the account "active" but potentially vulnerable to other access methods if the system is misconfigured.

## Summary for Interview (Best Practices)
1. **Principle of Least Time**: Always grant access for the shortest duration necessary.
2. **Account Hardening**: Combine expiry with `nologin` shells or restricted `sudo` access.
3. **White Hat Insight**: Auditors look for accounts that haven't logged in for 90 days. Auto-expiry prevents these from accumulating.
4. **Command to Know**: `chage` is the primary tool for managing account lifecycle policies in Linux.
5. **Automation**: Always prefer Identity Providers (IdP) like Okta or Azure AD linked via LDAP/SSSD for centralized control.

---
**Previous Day:** [Day 1: Non-Interactive User Setup](../day1)
