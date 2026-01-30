# Day 12: Linux Network Services 🌐🛠️

> **Hook:** Один порт, два сервіси та фаєрвол — як не заплутатися в мережевих хащах! 🕵️‍♂️
>
> **Problem-Solution-Value:** Служба Apache не запускалася через конфлікт за порт 6400, який підступно зайняв `sendmail`. Сьогодні ми пройшли повний цикл дебаггінгу: від пошуку "самозванця" за допомогою `netstat` до налаштування пріоритетних правил в `iptables`. Тепер сервіс доступний з Jump Host, а структура мережі стала прозорою та захищеною.
>
> **Call to Action:** Станьте майстром мережевого траблшутингу — детальний розбір та команди вже у звіті! 👇

## Business & Infrastructure Context
### Why it matters:
In complex cloud environments, network connectivity issues are one of the most common causes of service degradation. Quick diagnosis of port conflicts and firewall blocks directly impacts a company's **MTTR** (Mean Time to Recovery) and overall infrastructure availability.

### Operational Domain:
- **Environment:** Hybrid Cloud, On-premise, Edge Computing.
- **Layer:** Network Layer (L4 - Transport).
- **Stage:** Run (Operations, Support, Security Auditing).

### The Risk:
Misconfigured firewalls can either block legitimate traffic, causing service outages, or leave dangerous ports open to the public internet. Understanding rule priority (First Match wins) in `iptables` is critical to avoid "shadowing" rules that compromise security.

## Lab Breakdown (Step-by-Step)
### Phase 1: Identifying the Conflict
### Step 1
```bash
# Diagnostic command to find who is listening on port 6400
sudo netstat -tunlp | grep :6400
```
**Expected Result:** Finding that `sendmail` is listening on `127.0.0.1:6400`, preventing Apache from binding.

### Phase 2: Clearing the Path
### Step 2
```bash
# Stop and disable the conflicting service
sudo systemctl stop sendmail
sudo systemctl disable sendmail
# Start the primary web service
sudo systemctl start httpd
```
**Expected Result:** Apache successfully starts and listens on `0.0.0.0:6400`.

### Phase 3: Firewall Hardening
### Step 3
```bash
# Insert a priority rule at the top of the INPUT chain
sudo iptables -I INPUT 1 -p tcp --dport 6400 -j ACCEPT
```
**Expected Result:** Packet filtering allows incoming requests to port 6400 BEFORE any global `DROP` or `REJECT` rules.

### Phase 4: Remote Verification
### Step 4
```bash
# Test connectivity from the Jump Host
curl http://ApacheServer:6400
```
**Expected Result:** Successful HTTP response (200 OK or site content).

## DevOps Context & Alternatives
### Cloud-native approach:
In **AWS/GCP**, we primarily use **Security Groups** (Stateful Firewalls) or **Network ACLs** (Stateless). Instead of managing `iptables` inside every VM, we define these rules at the infrastructure-as-code level (Terraform/CloudFormation) to ensure a globally consistent security posture.

### Alternatives:
- **firewalld / ufw**: High-level wrappers for `nftables`/`iptables` that simplify rule management.
- **Nginx Proxy**: Instead of opening multiple ports, use a reverse proxy to route different domains to different internal services.
- **Service Mesh (Istio/Linkerd)**: Handles intra-service security (mTLS) without relying on traditional OS firewalls.

## Junior Pitfalls (Common Mistakes ⚠️)
- **Rule Order Ignorance**: Adding a rule with `-A` (Append) at the end of a long list after a "Drop All" rule. The packet will never reach your new rule.
- **Loopback Binding**: Setting a service to listen on `127.0.0.1` and wondering why external hosts can't reach it.
- **Temp Fixes**: Forgetting to make `iptables` rules persistent (they vanish after reboot unless saved with `iptables-save`).

## Summary for Interview (Best Practices)
1. **SS over Netstat**: `ss` is the modern, faster alternative to the legacy `netstat` tool.
2. **First Match Wins**: In firewall chains, the first rule that matches a packet is executed. Order is everything.
3. **Least Privilege**: Only open necessary ports and restrict by source IP (Source CIDR) whenever possible.
4. **White Hat Insight**: Port 6400 is "non-standard". While this hides the service from casual scanners (Security by Obscurity), it is not a replacement for proper authentication and firewalling.
5. **Observability**: Use tools like `tcpdump` or `wireshark` to see if packets are even reaching your server when `curl` fails.

---
**Previous Day:** [Day 11: Install and Configure Tomcat Server](../day11)
