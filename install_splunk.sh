#!/bin/bash

# Step 1: Update and Upgrade Package Managers
echo "Updating and upgrading package managers..."
sudo apt update && sudo apt upgrade -y


# Step 2: Create a Splunk User (using adduser)
# Disabled the prompt
echo "Creating Splunk user..."
sudo adduser --disabled-password --gecos "" splunk

# Step 3: Creating Splunk user password on the linux box not for splunk web
echo "Creating Splunk user password on the linux box not for splunk web"
sudo passwd splunk


# Step 4: Add the Splunk User to the Root Group
echo "Adding Splunk user to the sudo group..."
sudo usermod -aG sudo splunk

# Step 5: Download Splunk Enterprise
echo "Downloading Splunk Enterprise..."
SPLUNK_URL="https://download.splunk.com/products/splunk/releases/9.3.2/linux/splunk-9.3.2-d8bb32809498-Linux-x86_64.tgz"
wget -O /tmp/splunk-9.3.2.tgz "$SPLUNK_URL"

# Step 6: Install Splunk Enterprise
echo "Installing Splunk Enterprise..."
sudo tar -xzvf /tmp/splunk-9.3.2.tgz -C /opt

# Step 7: Change ownership of /opt/splunk
echo "Changing ownership of /opt/splunk to Splunk user..."
sudo chown -Rf splunk:splunk /opt/splunk

# Step 8: Install plocate
echo "Installing plocate utility..."
sudo apt install plocate -y

# Step 9: Locate system.conf
echo "Locating system.conf..."
sudo updatedb
locate system.conf

# Step 10: Update system.conf to increase ulimit values
echo "Updating /etc/systemd/system.conf to increase ulimit values..."
sudo cp /etc/systemd/system.conf /etc/systemd/system.conf.bak
sudo sed -i.bak \
    -e 's/^#DefaultLimitNOFILE=.*/DefaultLimitNOFILE=64000/' \
    -e 's/^#DefaultLimitNPROC=.*/DefaultLimitNPROC=16000/' \
    -e 's/^#DefaultTasksMax=.*/DefaultTasksMax=80%/' \
    -e '/^DefaultLimitNOFILE=/!s/^DefaultLimitNOFILE=.*/DefaultLimitNOFILE=64000/' \
    -e '/^DefaultLimitNPROC=/!s/^DefaultLimitNPROC=.*/DefaultLimitNPROC=16000/' \
    -e '/^DefaultTasksMax=/!s/^DefaultTasksMax=.*/DefaultTasksMax=80%/' \
    /etc/systemd/system.conf

# Step 11: Disable Transparent Huge Pages (THP)
echo "Disabling Transparent Huge Pages (THP)..."
echo 'never' | sudo tee /sys/kernel/mm/transparent_hugepage/enabled
echo 'never' | sudo tee /sys/kernel/mm/transparent_hugepage/defrag

# Step 12: Navigate to Splunk bin
echo "Navigating to Splunk bin directory..."
cd /opt/splunk/bin || exit


# Step 13: Start Splunk with automatic license acceptance and confirmation
echo "Starting Splunk..."
echo " The username and password prompt here is for splunk web not for splunk user on the linux box"
echo "This username and password can be same or different from splunk user on the linux box"
echo "easy or mostly used username for testing is (admin) and you enter your preferred password"
sudo ./splunk start --accept-license --answer-yes -user splunk

# Step 14: Enable Splunk boot-start with automatic license acceptance and confirmation
echo "Enabling Splunk boot-start..."
sudo ./splunk enable boot-start --accept-license --answer-yes -user splunk


# Step 15: Reset ownership of /opt/splunk
echo "Resetting ownership of /opt/splunk..."
sudo chown -Rf splunk:splunk /opt/splunk

# Step 16: Switch to Splunk User and start Splunk
echo "Switching to Splunk user and starting Splunk..."
sudo su - splunk -c "
    cd /opt/splunk/bin;
    echo 'Checking if Splunk is running...';
    ./splunk status || echo 'Splunk is not running. Starting Splunk...';
    ./splunk start
"

# Step 17: Enable Splunk Web SSL (HTTPS)
echo "Enabling Splunk Web SSL..."
sudo -u splunk bash -c 'echo -e "[settings]\nstartwebserver = True\nenableSplunkWebSSL = True\nsslVersions = tls1.2\n" >> /opt/splunk/etc/system/local/web.conf'

# Step 18: Restarting After Enabling HTTPS
sudo /opt/splunk/bin/splunk restart

# Instructions for managing Splunk
echo "To manage Splunk, use the following commands as the Splunk user:"
echo "  Start Splunk: ./splunk start"
echo "  Stop Splunk: ./splunk stop"
echo "  Restart Splunk: ./splunk restart"
echo "Script execution completed."
