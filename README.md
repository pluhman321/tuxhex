# TuxHex

**TuxHex** is a modular, ethical hacking toolkit designed to run on Raspberry Pi (or any Linux system). It comes with both a web UI and CLI, supports Wi-Fi Access Point mode, and is meant for lab environments, ethical pentesting, and network exploration.

---

## 🚀 Features

- Web dashboard (Flask-based) with device scan results
- CLI tool for quick terminal use
- ARP scanning & device discovery
- Port scanning
- Wi-Fi Access Point mode with SSID/password setup
- One-shot auto installer (`install.sh`)
- Headless boot-ready (first-time setup via `tuxhex-firstboot.sh`)

---

## 📦 Installation

### 📁 Manual Method

```bash
git clone https://github.com/pluhman321/tuxhex.git
cd tuxhex
chmod +x install.sh
./install.sh
```

Follow prompts to enable Wi-Fi AP mode and set up the dashboard.

---

## 🔥 Headless Boot Setup (optional)

1. Flash Raspberry Pi OS Lite using Raspberry Pi Imager.
2. Enable SSH and set hostname/credentials in Imager settings.
3. Add this line to `/etc/rc.local` before `exit 0`:

```bash
bash /home/pi/tuxhex-firstboot.sh
```

4. Reboot — the Pi will auto-install and launch TuxHex from GitHub.

---

## 📡 Accessing the Web UI

Once installed and running:

```
http://<pi-ip>:8080
```

---

## 🛑 Ethical Notice

TuxHex is intended **only for ethical hacking, educational use, or lab environments** where you have permission. Unauthorized network access is illegal and unethical.

---

## 👤 Author

**pluhman321** – [github.com/pluhman321](https://github.com/pluhman321)

---

## ✅ License

MIT License – use freely with attribution
