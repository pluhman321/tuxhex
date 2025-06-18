#!/bin/bash

set -e

echo "[*] Starting TuxHex Setup..."

# Step 1: Update system
sudo apt update && sudo apt upgrade -y

# Step 2: Install required packages
sudo apt install -y python3 python3-pip python3-venv git flask scapy hostapd dnsmasq

# Step 3: Set up Python virtual environment (optional)
cd ~/TuxHex || (echo "TuxHex folder not found in ~"; exit 1)
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# Step 4: Create systemd service to autostart web UI
echo "[*] Creating systemd service..."

SERVICE_FILE="/etc/systemd/system/tuxhex.service"
sudo tee $SERVICE_FILE > /dev/null <<EOF
[Unit]
Description=TuxHex Flask Dashboard
After=network.target

[Service]
User=pi
WorkingDirectory=/home/pi/TuxHex
ExecStart=/home/pi/TuxHex/venv/bin/python3 /home/pi/TuxHex/app.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable tuxhex
sudo systemctl start tuxhex

# Step 5: Configure Wi-Fi Access Point (optional)
read -p "🛜 Do you want to configure the Pi as a Wi-Fi Access Point? (y/n): " ap_choice
if [[ "$ap_choice" == "y" || "$ap_choice" == "Y" ]]; then
  read -p "📶 Enter SSID (network name): " wifi_ssid
  read -p "🔐 Enter Password (min 8 chars): " wifi_pass

  # Stop services if active
  sudo systemctl stop hostapd
  sudo systemctl stop dnsmasq

  # Create hostapd.conf
  sudo tee /etc/hostapd/hostapd.conf > /dev/null <<EOF
interface=wlan0
driver=nl80211
ssid=${wifi_ssid}
hw_mode=g
channel=7
wmm_enabled=0
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=${wifi_pass}
wpa_key_mgmt=WPA-PSK
rsn_pairwise=CCMP
EOF

  sudo sed -i 's|#DAEMON_CONF="".*|DAEMON_CONF="/etc/hostapd/hostapd.conf"|' /etc/default/hostapd

  # Create dnsmasq.conf
  sudo tee /etc/dnsmasq.conf > /dev/null <<EOF
interface=wlan0
dhcp-range=192.168.50.10,192.168.50.100,255.255.255.0,24h
EOF

  # Static IP for wlan0
  sudo tee -a /etc/dhcpcd.conf > /dev/null <<EOF
interface wlan0
    static ip_address=192.168.50.1/24
    nohook wpa_supplicant
EOF

  sudo systemctl unmask hostapd
  sudo systemctl enable hostapd
  sudo systemctl enable dnsmasq
  sudo systemctl restart dhcpcd
  sudo systemctl start hostapd
  sudo systemctl start dnsmasq
fi

echo "✅ TuxHex setup complete. Dashboard will run at boot."
