# Day 6: Create a Cron Job 🕒🤖

## Business & Infrastructure Context
### Why this matters in real projects?
In a world of complex microservices and distributed systems, consistency is everything. You cannot rely on an engineer remembering to clear `/tmp` logs or rotate backup files every Sunday at 3 AM. **Cron** is the heartbeat of Linux automation, powering everything from database maintenance to background report generation.

### Where it lives:
- **Infra / OS**: Native to nearly every Linux distribution.
- **CI/CD**: Used for cleanup tasks on runners or periodically triggering scan jobs.

### Business Value:
- **Operational Efficiency**: Eliminates repetitive manual toil.
- **Reliability**: Guarantees that essential system maintenance happens on time, every time.
- **Data Safety**: Automated backups ensure you have a recovery point without depending on human schedules.

### Risks:
- **Silent Failures**: If a Cron job fails without proper logging or alerting, you might not realize it until you actually need that "automated" backup.

## Lab Breakdown (Step-by-Step)
### Phase 1: Understanding the Syntax
Cron uses a 5-star format: `* * * * * command`
(Minute, Hour, Day of Month, Month, Day of Week)

### Step 1
```bash
# Open the crontab editor for the current user
crontab -e
```
**Expected Result:** An editor (like Nano or Vim) opens with the user's cron schedule.

### Phase 2: Scheduling a Task
### Step 2
```bash
# Add this line to run a script every day at 02:00 AM
# Always use absolute paths to both the shell and the script!
00 02 * * * /bin/bash /home/user/days/day6/auto_backup.sh >> /home/user/logs/backup.log 2>&1
```
**Expected Result:** The line is saved in the crontab.

### Phase 3: Verification
### Step 3
```bash
# List all active cron jobs for the current user
crontab -l
```
**Expected Result:** Output showing the newly added schedule line.

## DevOps Context & Alternatives
### Cloud-native approach:
In **Kubernetes**, we use `CronJob` resources. They manage pods that run on a schedule, providing better observability, retries, and resource isolation than traditional OS-level cron.

### Alternatives:
- **Systemd Timers**: A more modern alternative to Cron in Linux. They offer better logging (integrated with journald) and dependencies.
- **Jenkins / GitLab CI**: For complex automation workflows that require UI visibility and artifact management.

## Junior Pitfalls (Common Mistakes ⚠️)
- **Relative Paths**: Cron runs in a very minimal environment. Always use `/usr/bin/python3` instead of `python3`, and absolute file paths.
- **Missing Newline**: Some old crontab implementations fail if the file doesn't end with a blank line.
- **No Error Logging**: Not redirecting `stderr` to a log file (`2>&1`), leaving you blind when things go wrong.

## Summary for Interview (Best Practices)
1. **Absolute Everything**: Path to the interpreter, path to the script, path to the logs.
2. **Standard Output**: Always redirect output to a log file for debugging (`>> /path/to/log 2>&1`).
3. **Environment**: Remember that Cron doesn't load your `~/.bashrc`. If you need specific environment variables, define them inside the script.
4. **White Hat Insight**: Cron jobs running as root are high-value targets. If an attacker can write to a script called by root's crontab, they gain full system control (Privilege Escalation).
5. **Observability**: In a professional setup, use a monitoring tool (like Healthchecks.io) to alert you if a cron job *stops* running.

---
**Previous Day:** [Day 5: SELinux Configuration](../day5)
