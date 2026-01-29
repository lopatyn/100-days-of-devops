# Day 10: Linux Bash Scripts 📜💾

> **Hook:** Один скрипт — і ваші дані в безпеці на двох серверах одночасно! 🛡️
>
> **Problem-Solution-Value:** Зберігати бекапи лише на тому самому сервері, де працює сайт — це великий ризик. Якщо "впаде" залізо, ви втратите все. Сьогодні я створив автоматизований скрипт, який не тільки архівує блог локально, а й безпечно переносить його на віддалений NB Server без зайвих запитів пароля.
>
> **Call to Action:** Автоматизуйте свій Disaster Recovery план вже зараз — професійний скрипт бекапу чекає на вас! 👇

## Business & Infrastructure Context
### Why it matters:
Data loss is one of the most expensive incidents a business can face. Automated, off-site backups are the foundation of any **Disaster Recovery (DR)** strategy. By automating the transfer to a remote "NB Server", we ensure data durability even if the primary application server fails completely.

### Operational Domain:
- **Environment:** On-premise Data Centers / Hybrid setups.
- **Layer:** OS & Data (Storage Layer).
- **Stage:** Run (Operations & Maintenance).

### The Risk:
Relying on local-only backups is a single point of failure. Manual transfers are often forgotten, leading to out-of-date recovery points. Hardcoding passwords in scripts for transfer creates a massive security vulnerability.

## Lab Breakdown (Step-by-Step)
### Phase 1: Local Archiving
### Step 1
```bash
# Create a zip archive of the website directory
zip -r /backup/xfusioncorp_blog.zip /var/www/html/blog
```
**Expected Result:** A zip file `xfusioncorp_blog.zip` appears in the `/backup/` directory.

### Phase 2: Remote Synchronization
### Step 2
```bash
# Securely copy the archive to the backup server
# Assumes SSH key-based authentication is configured
scp /backup/xfusioncorp_blog.zip tony@nb_server:/backup/location
```
**Expected Result:** The file is available on the NB Server without a password prompt.

### Phase 3: Access Control
### Step 3
```bash
# Ensure the service user can execute the automation
chmod +x /scripts/blog_backup.sh
chown tony:tony /scripts/blog_backup.sh
```
**Expected Result:** User `tony` can run the script manually or via cron.

## DevOps Context & Alternatives
### Cloud-native approach:
In **AWS**, we often use **S3** for backups due to its 99.999999999% durability. Scripts would use `aws s3 cp` or `sync`. For databases, we rely on **Automated Snapshots** and **Multi-AZ** replication.

### Alternatives:
- **rsync**: More efficient than `scp` as it only transfers changes (deltas).
- **rclone**: The "Swiss army knife" for syncing data to cloud storage (S3, Drive, etc.).
- **BorgBackup**: Deduplicated and encrypted backup solution.

## Junior Pitfalls (Common Mistakes ⚠️)
- **Hardcoded Passwords**: Using `sshpass` or clear-text passwords in scripts. Always use SSH Keys.
- **Full Disk**: Forgetting to check if there's enough space in `/backup` before creating the zip.
- **Missing Paths**: Not using absolute paths in the script, causing it to fail when run via Cron.

## Summary for Interview (Best Practices)
1. **Automation is Key**: Backups that aren't automated eventually stop happening.
2. **3-2-1 Rule**: 3 copies of data, 2 different media, 1 off-site. This script fulfills the "off-site" (remote) part.
3. **Idempotency/Logging**: A good script should log its progress and handle existing files gracefully.
4. **White Hat Insight**: Backup servers are high-value targets. Ensure the `authorized_keys` on NB Server is restricted to specific commands if possible (Command restriction).
5. **Validation**: A backup is only as good as its last successful restore. Periodically test the zip files!

---
**Previous Day:** [Day 9: MariaDB Troubleshooting](../day9)
