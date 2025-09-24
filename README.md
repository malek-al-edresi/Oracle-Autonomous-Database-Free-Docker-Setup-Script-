# Oracle Autonomous Database Free – Docker Setup Script  

🚀 Automated installation script for setting up **Oracle Autonomous Database Free (ADB-Free)** inside a **Docker container**.  
This interactive Bash script provides a guided setup with menus, validations, and customization options.  

---

## ✨ Features  

- Interactive menu-driven configuration  
- Colored terminal output for better UX  
- Auto-generation or manual input for secure passwords  
- Customizable:  
  - Container name  
  - Network name  
  - Data and wallet directories  
  - Timezone  
  - CPU and memory allocation  
  - Character set  
  - Port mapping  
  - Advanced Docker options (health checks, restart policies, ulimits)  
- Automatic cleanup of old containers and networks  
- Connection info and JDBC string displayed after setup  
- Built-in help and version display  

---

## 🛠️ Prerequisites  

- **Docker** installed and running  
- Linux or macOS terminal (tested on Ubuntu 22.04)  
- Internet access to pull the Oracle container image  

---

## 📦 Installation  

Clone this repository:  

```bash
git clone https://github.com/<your-username>/<your-repo>.git
cd <your-repo>
chmod +x setup_oracle_adb.sh
```

---

## 🚀 Usage  

Run the script:  

```bash
./setup_oracle_adb.sh
```

### Options  

```bash
-h, --help     Show help  
-v, --version  Show script version  
```

---

## ⚙️ Configuration Flow  

1. Container & network setup  
2. Data and wallet directories  
3. Password setup (auto-generate or custom)  
4. Timezone selection  
5. CPU and memory allocation  
6. Character set selection  
7. Port mapping  
8. Advanced Docker options (health checks, restart, ulimits)  
9. Review configuration summary  
10. Automatic setup & container start  

---

## 🔑 Example Connection String  

After successful setup, connect using:  

```text
jdbc:oracle:thin:@localhost:1521/MYATP_high
```

---

## 🧩 Advanced Options  

- **Health checks** – Monitor DB container readiness  
- **Restart policy** – Auto-restart on failures  
- **Ulimits** – Optimize for high connection workloads  

---

## 📸 Demo (Menu Preview)  

```
╔══════════════════════════════════════════════════════════════════════════════╗
║       SETUP ORACLE AUTONOMOUS DATABASE FREE CONTAINER IMAGE VIA DOCKER       ║
║                     AUTOMATED INSTALLATION SCRIPT                            ║
║                  Developed by: Malek Mohammed Al-Edresi                      ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

---

## 👨‍💻 Author  

**Malek Mohammed Al-Edresi**  
- Advanced Database Solutions  
- Professional Database Administration  

---

## 📜 License  

This project is licensed under the **MIT License**.  
