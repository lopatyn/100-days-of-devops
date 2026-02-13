#!/bin/bash

# setup_db.sh - Automation for Day 18 (Stdb01 Database Server)
# Purpose: Initialize database and user for WordPress.

DB_NAME="kodekloud_db5"
DB_USER="kodekloud_top"
DB_PASS="8FmzjvFU6S"

echo "🗄️ Starting MariaDB Setup for xFusionCorp..."

# 1. Install MariaDB
echo "📦 Installing MariaDB..."
sudo yum install -y mariadb-server
sudo systemctl enable --now mariadb

# 2. Database & User Creation (Idempotent)
echo "🔑 Provisioning Database and Users..."
sudo mysql -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
sudo mysql -e "CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS';"
sudo mysql -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';"
sudo mysql -e "FLUSH PRIVILEGES;"

# 3. Verification
echo "🔍 Verifying database existence..."
sudo mysql -e "SHOW DATABASES LIKE '$DB_NAME';"

echo "🏁 Database Setup complete."
