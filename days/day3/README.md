# Day 3: Secure Root SSH Access 🔐

## Business & Infrastructure Context
### Why this matters in real projects?
Publicly accessible servers are under constant attack from bots scanning for open SSH ports. The `root` user is the most common target because its name is universal.

### Where it lives:
- **Infra / Security**: A mandatory baseline for server hardening (Golden Images/AMIs).
- **CI/CD**: Automated via cloud-init or configuration management tools (Ansible/Terraform).

### Business Value:
- **Security Posture**: Dramatically reduces the success rate of automated brute-force attacks.
- **Auditability**: Forcing users to log in as themselves before elevating privileges ensures all administrative actions are logged to a specific identity.

### Risks:
- **Lockout**: If no other user has SSH access and `sudo` privileges, you can permanently lock yourself out of a remote server.

## Lab Breakdown (Step-by-Step)
### Phase 1: Preparation
### Step 1
```bash
# Ensure you have a standard user with sudo access
# Never disable root SSH until you've verified your personal access!
sudo -v
```
**Expected Result:** Prompt for password, confirming you have `sudo` rights.

### Phase 2: Configuration
### Step 2
```bash
# Backup the original configuration
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
```
**Expected Result:** A backup file is created in `/etc/ssh/`.

### Step 3
```bash
# Edit the configuration to disable root login
sudo sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
```
**Expected Result:** The `PermitRootLogin` parameter is set to `no`.

### Phase 3: Verification
### Step 4
```bash
# Test the configuration for syntax errors before restarting
sudo sshd -t
```
**Expected Result:** No output (indicates success).

### Step 5
```bash
# Reload the service
sudo systemctl reload ssh
```
**Expected Result:** SSH service reloads settings without dropping current connections.

## DevOps Context & Alternatives
### Cloud-native approach:
In **AWS/GCP/Azure**, standard images usually come with root login disabled by default, favoring SSH keys for a specifically created `ec2-user` or `ubuntu` user.

### Alternatives:
- **SSH Key-Only Authentication**: Set `PasswordAuthentication no` to further harden the service.
- **Fail2Ban**: Automatically block IPs after multiple failed login attempts.
- **Ansible**: `lineinfile` module is perfect for managing these config lines across thousands of nodes.

## Junior Pitfalls (Common Mistakes ⚠️)
- **Direct Restart**: Using `systemctl restart` instead of `reload` can potentially drop your current session if there's a config error.
- **No Alternative User**: Disabling root without having another user with SSH keys and `sudo` access.
- **Forgetting SSH Keys**: Disabling passwords but not setting up `~/.ssh/authorized_keys` for the standard user.

## Summary for Interview (Best Practices)
1. **Never use Root**: Use `sudo` for administrative tasks to maintain an audit trail.
2. **Standard Port**: Move SSH from port 22 to a non-standard port to reduce bot noise.
3. **White Hat Insight**: Disabling root login is the first thing a penetration tester checks. It's the "low hanging fruit" of security.
4. **Key-Based Auth**: SSH keys are significantly more secure than passwords.
5. **Bastion Hosts**: In production, never expose SSH directly to the internet; use a VPN or a Bastion host (Jump server).

---
**Previous Day:** [Day 2: Temporary User Setup](../day2)
