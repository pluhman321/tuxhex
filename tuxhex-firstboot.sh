#!/bin/bash

# This script will run once at first boot and then remove itself

LOGFILE=/home/pi/tuxhex-firstboot.log
SETUP_SCRIPT=/home/pi/setup.sh

echo "[*] Running TuxHex first-boot setup..." | tee -a $LOGFILE

if [ -f "$SETUP_SCRIPT" ]; then
    chmod +x $SETUP_SCRIPT
    bash $SETUP_SCRIPT | tee -a $LOGFILE
else
    echo "[!] setup.sh not found." | tee -a $LOGFILE
fi

# Remove self from rc.local to prevent re-running
sudo sed -i '/tuxhex-firstboot.sh/d' /etc/rc.local
sudo sed -i '/exit 0/d' /etc/rc.local
echo "exit 0" | sudo tee -a /etc/rc.local

exit 0
