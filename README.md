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
