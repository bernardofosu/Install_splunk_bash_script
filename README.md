# 🚀 Install Splunk Using a Bash Script

## 📌 Key Notes:
✅ This script installs Splunk 9.3.0 for Linux.

✅ Designed for Ubuntu, but can be modified for other distros.

✅ If you're using Amazon Linux, replace apt with yum.

✅ For RedHat, replace apt with dnf.

## 🛠 Installation Instructions:
**1️⃣** Open the install_splunk.sh script file using any text editor.

**2️⃣** Copy all the script content.

**3️⃣** On your server, use a text editor (nano or vi) and paste the script.

**4️⃣** Save the file and exit the editor.

## 🔐 Grant Execution Permissions:
After creating the script, run the following command to make it executable:
```sh
sudo chmod +x install_splunk.sh
```

### 🚀 Run the installation script
```sh
sudo ./install_splunk.sh
```
##### 📌 Note:
_**./** means you are running the script from the current directory. If you are not in the current directory, use the full path to the script instead_

_🔑 Using sudo ensures proper permissions for installation!_

_👤 If you're not using the root user, you'll need sudo to perform administrative actions during installation_

## 📜 What’s Inside the Installation Script?

### 🔹 Step 1: Update and Upgrade Package Managers
```sh
sudo apt update && sudo apt upgrade -y
```

### 🔹 Step 2: Create a Splunk User (using adduser)
#### Disabled the prompt
```sh
sudo adduser --disabled-password --gecos "" splunk
```

### 🔹 Step 3: Creating Splunk user password on the linux box not for splunk web
_note: echo "Creating Splunk user password on the linux box not for splunk web_"
```sh
sudo passwd splunk
```

### 🔹 Step 4: Add the Splunk User to the Root Group
```sh
sudo usermod -aG sudo splunk
```

### 🔹 Step 5: Download Splunk Enterprise
```sh
SPLUNK_URL="https://download.splunk.com/products/splunk/releases/9.3.0/linux/splunk-9.3.0-51ccf43db5bd-Linux-x86_64.tgz"
wget -O /tmp/splunk-9.3.0.tgz "$SPLUNK_URL"
```

### 🔹 Step 6: Install Splunk Enterprise
```sh
sudo tar -xzvf /tmp/splunk-9.3.0.tgz -C /opt
```

### 🔹 Step 7: Change ownership of /opt/splunk
```sh
sudo chown -Rf splunk:splunk /opt/splunk
```

### 🔹 Step 8: Install plocate
```sh
sudo apt install plocate -y
```

### 🔹 Step 9: Locate system.conf
```sh
sudo updatedb
locate system.conf
```

### 🔹 Step 10: Update system.conf to increase ulimit values
```sh
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
```

### 🔹 Step 11: Disable Transparent Huge Pages (THP)
```sh
echo 'never' | sudo tee /sys/kernel/mm/transparent_hugepage/enabled
echo 'never' | sudo tee /sys/kernel/mm/transparent_hugepage/defrag
```

### 🔹 Step 12: Navigate to Splunk bin
```sh
cd /opt/splunk/bin || exit
```

### 🔹Step 13: Start Splunk with automatic license acceptance and confirmation
When starting Splunk for the first time, you'll be prompted for a username and password.
### 🔹 Important Notes:
✅ This username and password are for Splunk Web, not the Linux system user.

✅ You can choose different credentials from your Linux Splunk user.

✅ A common username for testing is admin, and you can set your preferred password.
```sh
sudo ./splunk start --accept-license --answer-yes -user splunk
```

### 🔹 Step 14: Enable Splunk boot-start with automatic license acceptance and confirmation
```sh
sudo ./splunk enable boot-start --accept-license --answer-yes -user splunk
```

### 🔹 Step 15: Reset ownership of /opt/splunk
```sh
sudo chown -Rf splunk:splunk /opt/splunk
```

### 🔹 Step 16: Switch to Splunk User and start Splunk
```sh
sudo su - splunk -c "
    cd /opt/splunk/bin;
    echo 'Checking if Splunk is running...';
    ./splunk status || echo 'Splunk is not running. Starting Splunk...';
    ./splunk start
"

```

### Step 17: Enable Splunk Web SSL (HTTPS)
```sh
echo "Enabling Splunk Web SSL..."
sudo -u splunk bash -c 'echo -e "[settings]\nstartwebserver = True\nenableSplunkWebSSL = True\nsslVersions = tls1.2\n" >> /opt/splunk/etc/system/local/web.conf'
```

### Step 18: Restarting After Enabling HTTPS
```sh
sudo /opt/splunk/bin/splunk restart
```

# Instructions for managing Splunk
```sh
echo "To manage Splunk, use the following commands as the Splunk user:"
echo "  Start Splunk: ./splunk start"
echo "  Stop Splunk: ./splunk stop"
echo "  Restart Splunk: ./splunk restart"
echo "Script execution completed."
```


## 🚀 Simplifying Splunk Installation for the Architect Class
Since we are installing multiple Splunk instances for the architect class, I have designed a Bash script to streamline the process and speed up our work.  

If you encounter any issues while using it, please let me know. I'm happy to help! 😊  

#### 💬 **Share Your Views!**  
Join the discussion on the repository to share feedback and suggestions for improvement.  

#### 🔧 **Want to Contribute?**  
You can **fork** the repository, modify the script, and send a **pull request** to enhance it! 🚀  

Thank you for your support! 🙌  

