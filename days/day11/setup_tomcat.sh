#!/bin/bash

# ==============================================================================
# Script Name:  setup_tomcat.sh
# Description:  Installs Tomcat, changes default port, and deploys a WAR file.
# Why?          Tomcat is a staple for Java enterprise applications. 
#               Automating its setup and configuration ensures consistent 
#               environments and faster deployments.
# ==============================================================================

# Variables
TOMCAT_VERSION="9"
CUSTOM_PORT="8081"
WAR_SOURCE="/tmp/ROOT.war" # Simulated source on Jump Host
WEBAPPS_DIR="/var/lib/tomcat${TOMCAT_VERSION}/webapps"
CONF_FILE="/etc/tomcat${TOMCAT_VERSION}/server.xml"

echo "--- Starting Tomcat Installation & Configuration ---"

# Step 1: Install Tomcat and Java
echo "Installing OpenJDK and Tomcat ${TOMCAT_VERSION}..."
sudo apt update -y -q
sudo apt install -y -q openjdk-11-jdk tomcat${TOMCAT_VERSION}

# Step 2: Change Port in server.xml
echo "Changing default port to ${CUSTOM_PORT} in ${CONF_FILE}..."
# Use sed to replace the default 8080 port with CUSTOM_PORT
sudo sed -i "s/Connector port=\"8080\"/Connector port=\"${CUSTOM_PORT}\"/" "$CONF_FILE"

# Step 3: Deployment (Simulated)
echo "Deploying ROOT.war to ${WEBAPPS_DIR}..."
# In a real scenario, this would be scp'd from Jump Host
# We'll simulate the presence and move
if [ -f "$WAR_SOURCE" ]; then
    sudo rm -rf "${WEBAPPS_DIR}/ROOT"
    sudo cp "$WAR_SOURCE" "${WEBAPPS_DIR}/ROOT.war"
    echo "WAR file deployed."
else
    echo "Warning: ${WAR_SOURCE} not found. Skipping WAR deployment step."
fi

# Step 4: Restart and Verify
echo "Restarting Tomcat service..."
sudo systemctl restart tomcat${TOMCAT_VERSION}

echo "Waiting for service to initialize..."
sleep 5

echo "--- Verification ---"
curl -I "http://localhost:${CUSTOM_PORT}"

if [ $? -eq 0 ]; then
    echo "SUCCESS: Tomcat is running and accessible on port ${CUSTOM_PORT}."
else
    echo "ERROR: Tomcat health check failed."
    exit 1
fi
