# Day 5: SELinux Installation and Configuration 🛡️⚙️

## Business & Infrastructure Context
### Why this matters in real projects?
Standard Linux permissions (DAC) are often not enough. If a web server process is compromised, DAC might allow it to read any file owned by the `www-data` user. **SELinux (Mandatory Access Control)** adds a second layer of defense: even a root process can be blocked if its "Type" doesn't have explicit permission to access a specific "Target Type".

### Where it lives:
- **Infra / Prod**: A standard in high-security environments (RHEL, Fedora, CentOS, Amazon Linux).
- **Security / Compliance**: Mandatory for many government and financial industry standards (e.g., STIGs).

### Business Value:
- **Zero Trust**: Implements "least privilege" at the kernel level.
- **Blast Radius Reduction**: Prevents a single service exploit from becoming a full-system compromise.

### Risks:
- **Operational Downtime**: Misconfigured SELinux policies can block legitimate application traffic (e.g., Nginx not being able to read its own config).

## Lab Breakdown (Step-by-Step)
### Phase 1: Status Discovery
### Step 1
```bash
# Check if SELinux is enabled and what mode it's in
sestatus
```
**Expected Result:** A report showing `SELinux status: enabled` and the current mode (Enforcing/Permissive).

### Phase 2: Mode Management
### Step 2
```bash
# Temporarily switch to Permissive mode for troubleshooting
# Permissive = Log violations but don't block them
sudo setenforce 0
# Switch back to Enforcing
sudo setenforce 1
```
**Expected Result:** `getenforce` returns `Permissive` and then `Enforcing`.

### Phase 3: Working with Labels (Contexts)
### Step 3
```bash
# View security labels on the filesystem
ls -Z /var/www/html
```
**Expected Result:** Output like `unconfined_u:object_r:httpd_sys_content_t:s0`.

### Step 4
```bash
# Fix incorrect labels after moving files
# -v: verbose output
sudo restorecon -v /var/www/html/index.html
```
**Expected Result:** Information about updated labels if they were incorrect.

## DevOps Context & Alternatives
### Cloud-native approach:
In **Kubernetes**, we use `securityContext` in Pod manifests to define SELinux options (`seLinuxOptions`), ensuring that containers run with restricted kernel-level privileges.

### Alternatives:
- **AppArmor**: Used by default in Ubuntu/Debian. It is path-based and generally considered easier to manage but less "fine-grained" than SELinux.
- **GRSEC/PaX**: Even more restrictive kernel patches for extreme hardening.

## Junior Pitfalls (Common Mistakes ⚠️)
- **"The setenforce 0 Fix"**: Disabling SELinux permanently because it's "blocking something." This is like removing the brakes because they squeak.
- **Ignoring Audit Logs**: Failing to check `/var/log/audit/audit.log` when an application fails. SELinux gives you the exact reason for the block in the logs.
- **Relabeling Issues**: Successfully fixing a problem with `chmod` but forgetting that SELinux labels might still block access.

## Summary for Interview (Best Practices)
1. **Three Modes**: Enforcing (Blocking), Permissive (Logging), Disabled (Off).
2. **Mandatory Access Control (MAC)**: The kernel enforces the policy, not the user.
3. **Labels are Key**: Everything in SELinux is about the `User:Role:Type:Level` label.
4. **White Hat Insight**: Attackers hate SELinux because it prevents "lateral movement" even after a successful code execution exploit.
5. **Tools to Move**: Always know `semanage` (for persistent rules) and `restorecon` (for applying them).

---
**Previous Day:** [Day 4: Script Execution Permissions](../day4)
