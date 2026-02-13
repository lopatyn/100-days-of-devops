#!/bin/bash

# setup_lamp.sh - Automation for Day 18 (Nautilus App Servers)
# Purpose: Install and configure Apache (Port 6300) and PHP.

PORT=6300

echo "🚀 Starting LAMP Setup for xFusionCorp..."

# 1. Idempotent installation
echo "📦 Installing Apache and PHP..."
sudo yum install -y httpd php php-mysqlnd php-cli php-common

# 2. Port Configuration
echo "⚙️ Configuring Apache to listen on port $PORT..."
if grep -q "Listen $PORT" /etc/httpd/conf/httpd.conf; then
    echo "✅ Port $PORT already configured."
else
    sudo sed -i "s/Listen 80/Listen $PORT/" /etc/httpd/conf/httpd.conf
    echo "✅ Port $PORT configured successfully."
fi

# 3. Enable and Start services
echo "🔄 Restarting Apache..."
sudo systemctl enable --now httpd
sudo systemctl restart httpd

# 4. Verification
echo "🔍 Running Health Check..."
STATUS=$(curl -s -o /dev/null -w "%{http_code}" localhost:$PORT)

if [ "$STATUS" -eq 200 ]; then
    echo "✨ SUCCESS! Apache is serving on port $PORT."
else
    echo "❌ ERROR: Health check failed with status $STATUS."
    exit 1
fi

echo "🏁 Setup complete."
