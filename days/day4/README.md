# Day 4: Script Execution Permissions 🛡️📝

## Business & Infrastructure Context
### Why this matters in real projects?
In a CI/CD pipeline, scripts are the "glue" that holds your infrastructure together. These scripts often interact with secrets, databases, and cloud APIs. If a script's permissions are loose, any compromised user on the build server can read sensitive logic or modify it to inject malicious code (supply chain attack).

### Where it lives:
- **CI/CD / Automation**: Essential for Jenkins, GitLab Runners, or GitHub Action self-hosted runners.
- **Security / Compliance**: A core component of "Access Control" audits.

### Business Value:
- **Intellectual Property Protection**: Prevents unauthorized viewing of internal automation logic.
- **Integrity**: Ensures that only authorized systems/users can modify operational scripts.

### Risks:
- **Privilege Escalation**: A world-writable script that is executed by a high-privilege user (like root) is a classic path to full system compromise.

## Lab Breakdown (Step-by-Step)
### Phase 1: Identifying the Risk
### Step 1
```bash
# Create a script and view default permissions
touch script.sh
ls -l script.sh
```
**Expected Result:** A file with default permissions, usually `-rw-r--r--` (644).

### Phase 2: Granting Execution
### Step 2
```bash
# Make the script executable for the owner only
# chmod 7xx: 7=read+write+execute
chmod 700 script.sh
```
**Expected Result:** Permissions change to `-rwx------`.

### Phase 3: Ownership Control
### Step 3
```bash
# In production, we often need to change the owner to a service account
# Replace 'jenkins' with your service user
sudo chown jenkins:jenkins script.sh
```
**Expected Result:** The file owner and group change to `jenkins`.

## DevOps Context & Alternatives
### Cloud-native approach:
In **Containerized environments (Docker)**, we use the `USER` instruction to ensure processes don't run as root, and we set permissions during the build phase to keep the image immutable and secure.

### Alternatives:
- **ACLs (Access Control Lists)**: For more granular control where multiple users need different levels of access.
- **File Integrity Monitoring (FIM)**: Tools like Osquery or Tripwire can alert you if an executable script is modified.

## Junior Pitfalls (Common Mistakes ⚠️)
- **The "chmod 777" Shortcut**: Using 777 to "fix" permission issues is like leaving your front door wide open because the key was hard to turn.
- **Wrong Shebang**: Forgetting `#! /bin/bash` at the top. Permissions won't help if the system doesn't know how to execute the file.
- **Git Permissions**: Forgetting that Git tracks execution bits. Use `git update-index --chmod=+x script.sh` to ensure it remains executable across different environments.

## Summary for Interview (Best Practices)
1. **Principle of Least Privilege**: A script should only have the minimum permissions required to perform its task.
2. **Standardize on 700/750**: Most automation scripts should be 700 (owner only) or 750 (owner + group).
3. **White Hat Insight**: Attackers always look for world-writable scripts in `/tmp` or home directories. It's the easiest way to achieve persistence or escalation.
4. **Ownership Matters**: Permissions are meaningless if the file is owned by the wrong user. Always verify `chown`.
5. **Automation**: Use configuration management (Ansible/Chef) to enforce permission baselines across your fleet.

---
**Previous Day:** [Day 3: Secure Root SSH Access](../day3)
