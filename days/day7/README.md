# Day 7: Linux SSH Authentication 🔑🔐

> **Hook:** Пароль — це вразливість, ключ — це стандарт професіоналів! 🛡️
>
> **Problem-Solution-Value:** Використання паролів для SSH робить ваші сервери легкою здобиччю для brute-force атак. Сьогодні ми переходимо на SSH-ключі (Ed25519). Це не просто зручно (login without password), а й критично важливо для безпеки інфраструктури та автоматизації (CI/CD).
>
> **Call to Action:** Відмовтеся від паролів сьогодні — покроковий гайд та скрипт вже чекають у репозиторії! 👇

## Business & Infrastructure Context
### Why it matters:
Password-based authentication is the "low hanging fruit" for attackers. In a modern DevOps environment, manual password entry is an anti-pattern that blocks CI/CD automation and increases MTTR (Mean Time To Recovery).

### Operational Domain:
- **Environment:** Cloud (AWS/GCP/Azure), On-premise Data Centers.
- **Layer:** OS (Access Control).
- **Stage:** Run (Maintenance), Deploy (Automation).

### The Risk:
Compromising a single administrative password can lead to a full-scale ransomware attack. Furthermore, SSH keys are mandatory for automated deployment tools like Ansible and Terraform to manage infrastructure securely.

## Lab Breakdown (Step-by-Step)
### Phase 1: Key Generation
### Step 1
```bash
# Generate a modern Ed25519 key pair
# Ed25519 is more secure and performant than traditional RSA
ssh-keygen -t ed25519 -C "admin@infrastructure"
```
**Expected Result:** Files `id_ed25519` (private) and `id_ed25519.pub` (public) created in `~/.ssh/`.

### Phase 2: Permission Hardening
### Step 2
```bash
# SSH will fail if permissions are too loose
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_ed25519
```
**Expected Result:** Permissions updated to `-rwx------` for the directory and `-rw-------` for the private key.

### Phase 3: Public Key Distribution
### Step 3
```bash
# Copy the public key to the remote server
ssh-copy-id -i ~/.ssh/id_ed25519.pub user@remote-ip
```
**Expected Result:** The public key is added to the `authorized_keys` file on the target machine.

## DevOps Context & Alternatives
### Cloud-native approach:
In **AWS EC2**, you provide an SSH Public Key during instance creation via **Key Pairs**. For enterprise-scale management, tools like **HashiCorp Vault** generate dynamic, short-lived SSH certificates, eliminating the risk of lost permanent keys.

### Alternatives:
- **SSH Certificates**: Provides centralized control and expiration for keys.
- **SSSD/LDAP**: Centralized authentication against Active Directory or FreeIPA.

## Junior Pitfalls (Common Mistakes ⚠️)
- **Leaking Private Keys**: Never, ever commit your private key (`id_ed25519`) to Git! Always check your `.gitignore`.
- **Recursive Perms**: Running `chmod 777 -R ~/.ssh` will cause the SSH service to reject all connections for security reasons.
- **Wrong User**: Generating keys as `root` when you plan to log in as a standard user.

## Summary for Interview (Best Practices)
1. **Prefer Ed25519**: It's the current industry standard for security and speed.
2. **Use Passphrases**: Even if you have the private key, a passphrase adds a second factor of local protection.
3. **Disable Password Auth**: Once keys are set, set `PasswordAuthentication no` in `sshd_config`.
4. **White Hat Insight**: An attacker with read access to your `~/.ssh` directory can steal your identity. Always monitor access to this folder.
5. **Key Rotation**: Treat SSH keys like passwords—rotate them periodically and revoke keys for offboarded employees immediately.

---
**Previous Day:** [Day 6: Cron Job Automation](../day6)
