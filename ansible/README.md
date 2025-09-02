# 🛠️ Ansible Deployment Guide

This folder contains Ansible playbooks and roles used to configure and deploy the multi-stack microservices voting application on AWS.

---

## 🚀 How to Run the Playbooks

1. **SSH into the Bastion Host** (if using a private subnet setup):
   ```bash
   ssh -i ~/.ssh/your-key.pem ubuntu@<bastion-public-ip>
2. Run the main playbook:
   ```bash
   ansible-playbook playbooks/site.yml -i inventory/inventory.ini

3. Run specific roles using tags:
   ```bash
   ansible-playbook playbooks/site.yml -i inventory/inventory.ini --tags "docker"

---

🧱 Role Overview
Role	Description
common	Adds Redis and Postgres hostnames to /etc/hosts for internal DNS mapping
docker	Installs Docker and ensures the service is running
redis	Deploys Redis container in a private subnet
postgres	Deploys PostgreSQL container in a private subnet
worker	Deploys .NET Worker container that connects to Redis and Postgres
vote	Deploys Python/Flask frontend container that connects to Redis
result	Deploys Node.js/Express frontend container that connects to Postgres

---

🔐 Prerequisites

✅ AWS infrastructure provisioned via Terraform

✅ SSH access to EC2 instances (via Bastion or direct)

✅ Docker installed on EC2 instances (handled by Ansible)

✅ Docker images published to DockerHub

✅ Ansible installed on your local machine or Bastion host

---

📁 Inventory Structure
Your inventory.ini should define groups like:
   ```ini
[bastion]
bastion ansible_host=<bastion-ip>

[frontend]
vote ansible_host=<vote-instance-private-ip>
result ansible_host=<result-instance-private-ip>

[backend]
worker ansible_host=<worker-instance-private-ip>
redis ansible_host=<redis-instance-private-ip>

[postgres]
postgres ansible_host=<postgres-instance-private-ip>
```

---

🧪 Testing & Troubleshooting
Use ```docker logs <container-name>``` to inspect container behavior

Use ```telnet <host> <port>``` to test connectivity between services

Use ```docker exec -it <container-name>``` bash and env to inspect environment variables
