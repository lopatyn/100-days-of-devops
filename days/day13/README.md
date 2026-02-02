# Day 13: IPtables Installation and Configuration 🛡️🕸️

> **Hook:** Один невірно налаштований порт — і ваш сервер стає частиною ботнету. Як захистити інфраструктуру за допомогою "старого доброго" IPtables? 🕵️‍♂️
>
> **Problem-Solution-Value:** Служби Apache на порту 8089 були відкриті для всього світу через відсутність брандмауера. Ми впровадили багаторівневу стратегію захисту: від блокування несанкціонованого доступу до налаштування постійних правил, що дозволяють трафік лише від перевіреного Load Balancer. Тепер ваша "поверхня атаки" мінімізована, а доступ адміна через SSH — у безпеці.
>
> **Call to Action:** Не чекайте на злам — налаштуйте свій перший Firewall вже сьогодні! Повний гайд та коментарі експерта нижче. 👇

## Business & Infrastructure Context
### Why it matters:
In a production environment, securing service ports is a fundamental requirement of the **Defense in Depth** strategy. Restricting access to sensitive ports (like internal application APIs) directly reduces the risk of unauthorized data access and DDoS attacks, contributing to overall system **Availability** and **Confidentiality**.

### Operational Domain:
- **Environment:** Hybrid Cloud / On-premise.
- **Layer:** Network Layer (L4 - Transport).
- **Stage:** Run (Hardening & Security Operations).

### The Risk:
Leaving high-numbered ports (like 8089) open to `0.0.0.0/0` invites automated scanners and brute-force attempts. Without a host-based firewall, a single misconfiguration in the application could lead to full system compromise.

## Lab Breakdown (Step-by-Step)

### Phase 1: Environment Preparation
### Step 1: Install IPtables Services
```bash
# Install the persistent service to ensure rules survive a reboot (RHEL/CentOS)
sudo yum install -y iptables-services
# Enable and start the service
sudo systemctl enable --now iptables
```
**Expected Result:** The `iptables` service is active and running.

### Phase 2: Rule Configuration
### Step 2: Clean Slate and Loopback Security
```bash
# Flush all existing rules to avoid conflicts
sudo iptables -F
# Allow local loopback traffic (Essential for many internal Linux services)
sudo iptables -A INPUT -i lo -j ACCEPT
# Maintain existing connections (Prevents dropping your current SSH session)
sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
```
**Expected Result:** Rules are added to the INPUT chain; current SSH connection remains stable.

### Step 3: Authorizing Critical Traffic
```bash
# Explicitly allow SSH (Port 22) from anywhere (or specific management range)
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
# Allow HTTP traffic on port 8089 ONLY from the Load Balancer IP
sudo iptables -A INPUT -p tcp -s 172.16.238.14 --dport 8089 -j ACCEPT
```
**Expected Result:** Port 22 remains open for admin; Port 8089 is open ONLY for `172.16.238.14`.

### Phase 3: Hardening and Persistence
### Step 4: Dropping Unauthorized Traffic
```bash
# Deny all other incoming traffic on the application port
sudo iptables -A INPUT -p tcp --dport 8089 -j DROP
# Save rules to the configuration file so they persist after reboot
sudo service iptables save
```
**Expected Result:** Any host other than the LBR fails to connect to port 8089. Rules are saved to `/etc/sysconfig/iptables`.

## DevOps Context & Alternatives
- **In Kubernetes:** We rarely manage `iptables` manually. We use **Network Policies** (implemented by CNIs like Calico or Cilium) to define pod-to-pod communication rules in a declarative YAML format.
- **Cloud Firewalls:** AWS Security Groups or Azure NSGs handle this at the infrastructure level, which is more scalable than managing rules on every individual VM.
- **Ansible Automation:** For large-scale deployments, the `ansible.builtin.iptables` module is used to ensure idempotency and consistency across the fleet.

## Junior Pitfalls (Common Mistakes ⚠️)
- **SSH Lockout:** Running `iptables -P INPUT DROP` before allowing port 22. This is the fastest way to lose access to a remote server.
- **Rule Order Errors:** Adding a "Drop All" rule with `-A` at the beginning of the chain or misplaced relative to "Accept" rules. Remember: **First Match Wins**.
- **Ephemeral Rule Loss:** Forgetting to run `iptables-save` or use `persistent` services, leading to rules disappearing after a routine kernel update or reboot.

## Summary for Interview (Best Practices)
1. **Least Privilege:** Only open ports that are absolutely necessary for the application to function.
2. **Stateful Inspection:** Always use `-m state --state ESTABLISHED,RELATED` to allow return traffic for connections you initiated.
3. **Loopback is Vital:** Never block the `lo` interface, as many internal processes (like logging and monitoring) rely on it.
4. **Non-Standard Ports:** Using port 8089 is "obscurity," not security. It must be paired with explicit firewall rules.
5. **Persistence is Key:** A firewall rule that doesn't survive a reboot isn't a rule—it's a temporary fix.
6. **White Hat Insight:** If an attacker is already "inside" the machine, they can often bypass `iptables` by targeting the `lo` interface. Hardening service bindings (Binding to a specific IP instead of `0.0.0.0`) is the next layer of defense.

---
**Previous Day:** [Day 12: Linux Network Services](../day12)
