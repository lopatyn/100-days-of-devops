# Day 8: Install Ansible 🛠️🤖

> **Hook:** Забудьте про ручне налаштування 100 серверів. Один Playbook — і ваша інфраструктура готова! 🚀
>
> **Problem-Solution-Value:** Ручне конфігурування серверів — це повільно, ризиковано та не масштабовано. Сьогодні ми встановлюємо Ansible глобально через `pip3`. Це дає кожному користувачу системи інструмент для перетворення інфраструктури в код (IaC), забезпечуючи ідемпотентність та швидкість розгортання.
>
> **Call to Action:** Почніть свій шлях до автоматизації — інструкція та скрипт вже чекають! 👇

## Business & Infrastructure Context
### Why it matters:
Configuration drift is a major cause of production outages. Ansible solves this by enforcing a "Desired State". For business, this means faster **MTTR**, reduced operational costs, and 100% predictable environments.

### Operational Domain:
- **Environment:** Cloud, On-premise, Hybrid.
- **Layer:** OS & App (Configuration Management).
- **Stage:** Deploy & Run (Continuous Configuration).

### The Risk:
Without automation tools like Ansible, scaling becomes an exponential burden. Inconsistent server settings lead to "it works on my machine" bugs in production and failed security audits.

## Lab Breakdown (Step-by-Step)
### Phase 1: Environment Setup
### Step 1
```bash
# Ensure Python3 and Pip are ready
sudo apt update && sudo apt install -y python3-pip
```
**Expected Result:** `pip3` is installed and ready for use.

### Phase 2: Global Installation
### Step 2
```bash
# Global install via pip3 to make it available for all users
# Binaries will typically land in /usr/local/bin
sudo pip3 install ansible
```
**Expected Result:** Ansible and its dependencies are downloaded and installed.

### Phase 3: Verification
### Step 3
```bash
# Check if the binary is accessible globally
which ansible
ansible --version
```
**Expected Result:** Output shows the path to the ansible binary and the version information.

## DevOps Context & Alternatives
### Cloud-native approach:
In **Cloud** environments, Ansible is often used in combination with **Terraform**. While Terraform provisions the hardware (VMs, Networks), Ansible configures the software inside those VMs.

### Alternatives:
- **Terraform**: Best for provisioning (Infrastructure creation).
- **Bash Scripts**: Hard to maintain, lacks idempotency.
- **Chef/Puppet**: Requires an "Agent" on every server. Ansible is **Agentless** (SSH-only).

## Junior Pitfalls (Common Mistakes ⚠️)
- **Local vs Global**: Running `pip3 install --user ansible` makes it available only for *your* user. Use `sudo` for global system-wide access.
- **PATH Issues**: If `/usr/local/bin` is not in your `$PATH`, the command `ansible` won't be found.
- **Incompatible Python**: Installing Ansible on a system with multiple Python versions without specifying the correct `pip`.

## Summary for Interview (Best Practices)
1. **Agentless Architecture**: No need to install software on target nodes; only SSH is required.
2. **Idempotency**: Running a playbook 10 times results in the same state as running it once.
3. **YAML-based**: Human-readable configuration that acts as documentation.
4. **White Hat Insight**: Ansible can be used to scan and fix security vulnerabilities across thousands of servers simultaneously (Patch Management).
5. **Control Node**: Always keep your Ansible Control Node secure and backup your inventory/playbooks in Git.

---
**Previous Day:** [Day 7: Linux SSH Authentication](../day7)
