#!/bin/bash

LOGFILE="$HOME/tuxhex-firstboot.log"
REPO_URL="https://github.com/pluhman321/tuxhex.git"
CLONE_DIR="$HOME/tuxhex"

echo "[*] Starting TuxHex first-boot setup..." | tee -a "$LOGFILE"

# Clone the GitHub repo if not already present
if [ ! -d "$CLONE_DIR" ]; then
    git clone "$REPO_URL" "$CLONE_DIR" | tee -a "$LOGFILE"
fi

cd "$CLONE_DIR"

# Ensure we always fetch the latest install.sh
curl -O https://raw.githubusercontent.com/pluhman321/tuxhex/main/install.sh
chmod +x install.sh

# Run the installer
./install.sh | tee -a "$LOGFILE"

# Remove from rc.local to prevent re-running
sudo sed -i '/tuxhex-firstboot.sh/d' /etc/rc.local
sudo sed -i '/exit 0/d' /etc/rc.local
echo "exit 0" | sudo tee -a /etc/rc.local

echo "[✓] TuxHex installation complete. Reboot recommended." | tee -a "$LOGFILE"
