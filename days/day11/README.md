# Day 11: Install and Configure Tomcat Server 🐯🛳️

> **Hook:** Масштабуйте Java-додатки як профі — від інсталяції до кастомних портів! 🚀
>
> **Problem-Solution-Value:** Багато корпоративних додатків все ще покладаються на Java та Tomcat. Стандартні налаштування часто конфліктують з іншими сервісами. Сьогодні я автоматизував процес встановлення Tomcat, змінив дефолтний порт на 8081 та розгорнув `ROOT.war`, забезпечивши повну працездатність веб-сервера.
>
> **Call to Action:** Час опанувати розгортання Java-стеку — повний гайд та скрипт автоматизації вже в репо! 👇

## Business & Infrastructure Context
### Why it matters:
Apache Tomcat is one of the most widely used open-source web servers and servlet containers. In enterprise environments, hosting legacy and modern Java Spring Boot applications often requires a fine-tuned Tomcat setup. Automating this process reduces **MTTR** and ensures consistency across Dev, Staging, and Prod environments.

### Operational Domain:
- **Environment:** Cloud (Compute instances), On-premise.
- **Layer:** Application Layer (Middleware).
- **Stage:** Deploy & Run.

### The Risk:
Using default ports (8080) can lead to port conflicts and makes the server an easy target for automated scanners. Manual configuration of `server.xml` is error-prone and can lead to service downtime due to syntax errors.

## Lab Breakdown (Step-by-Step)
### Phase 1: Installation & Environment
### Step 1
```bash
# Install the runtime environment and the server
sudo apt update && sudo apt install -y openjdk-11-jdk tomcat9
```
**Expected Result:** Tomcat service is installed and running on the default port 8080.

### Phase 2: Configuration (Port Tuning)
### Step 2
```bash
# Edit the server.xml to change the connector port
# Find: <Connector port="8080" protocol="HTTP/1.1"
# Change to: <Connector port="8081" protocol="HTTP/1.1"
sudo nano /etc/tomcat9/server.xml
```
**Expected Result:** Service now listens on port 8081 after a restart.

### Phase 3: Deployment (WAR handling)
### Step 3
```bash
# Deploy the application archive
# ROOT.war will be served at the root context (/)
sudo cp /tmp/ROOT.war /var/lib/tomcat9/webapps/
```
**Expected Result:** Tomcat automatically unpacks the WAR and starts the application.

### Phase 4: Verification
### Step 4
```bash
# Verify the service is up and serving content
curl -I http://App-Server:8081
```
**Expected Result:** HTTP/1.1 200 OK.

## DevOps Context & Alternatives
### Cloud-native approach:
In **Containerized environments (Docker)**, we use the official `tomcat` image and pass configuration via environment variables or volume-mounted `server.xml`. In **Kubernetes**, we use `Services` to map ports, allowing the internal container to remain on 8080 while the external world sees it on port 80/443.

### Alternatives:
- **Spring Boot**: Often used with an "embedded" Tomcat, where no separate server installation is needed.
- **Jetty**: A lightweight alternative to Tomcat, often used in microservices.
- **WildFly (JBoss)**: A full-blown Java EE application server for more complex requirements.

## Junior Pitfalls (Common Mistakes ⚠️)
- **Java Dependency**: Forgetting to install the JDK/JRE before installing Tomcat.
- **Permission Denied**: Not giving the `tomcat` user enough permissions to read the `webapps` directory.
- **Zombie Processes**: Not checking if a previous instance of Tomcat is still holding the port before restarting.

## Summary for Interview (Best Practices)
1. **Separation of Concerns**: Use `$CATALINA_HOME` for binaries and `$CATALINA_BASE` for configuration/webapps.
2. **Security Hardening**: Always remove the default `webapps/examples` and `webapps/docs` to reduce the attack surface.
3. **Connectors**: Understand the difference between the **HTTP Connector** (standard web) and the **AJP Connector** (for proxying behind Nginx/Apache).
4. **White Hat Insight**: Attackers often look for the Tomcat Manager Dashboard (`/manager/html`). Ensure it is either disabled or protected by strong credentials and IP-restricted.
5. **JVM Tuning**: For production, always tune the heap size (`-Xmx`, `-Xms`) in `setenv.sh` to prevent OutOfMemory errors.

---
**Previous Day:** [Day 10: Website Backup Script](../day10)
