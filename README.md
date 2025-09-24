# Oracle Autonomous Database Free – Docker Setup Script  

## Overview  

This repository contains a **fully interactive Bash script** to set up and run **Oracle Autonomous Database Free (ADB-Free)** using **Docker**.  

The script is designed to make the installation seamless and user-friendly by guiding you through a series of menus to configure the container, environment, resources, and advanced options.  
It also performs validation, cleanup, and provides connection information once the database is ready.  

---

## Key Features  

- **Interactive Configuration**:  
  Menu-driven setup for all parameters.  

- **Customizable Settings**:  
  - Container name  
  - Docker network  
  - Data directory (persistent storage)  
  - Wallet directory (for secure wallet files)  
  - Admin and Wallet passwords  
  - Timezone  
  - CPU cores  
  - Memory allocation  
  - Database character set  
  - Port mappings  

- **Password Management**:  
  - Auto-generate strong, compliant passwords.  
  - Manual entry with validation (uppercase, lowercase, numeric, length).  

- **Advanced Options**:  
  - Enable/disable health checks.  
  - Configure restart policies (`always` or none).  
  - Set ulimits and sysctl values for high workloads.  

- **Automation**:  
  - Creates directories for data and wallet.  
  - Cleans up existing containers and networks with the same name.  
  - Creates Docker volumes for data and logs.  
  - Runs the Oracle container with the selected configuration.  

- **Monitoring & Startup**:  
  - Waits for the container to become healthy (if health checks are enabled).  
  - Displays clear connection information and JDBC connection strings.  

- **Utility Options**:  
  - `--help` for usage guide.  
  - `--version` to display script version and author information.  

---

## Script Workflow  

### 1. Header Display  
The script starts by displaying a professional banner with the author’s name and purpose of the script.  

### 2. Prerequisites Check  
Verifies that Docker is installed and accessible. If not, the script stops with an error message.  

### 3. Main Menu  
Provides three options:  
- Configure Oracle Database Free Setup  
- View Current Configuration  
- Exit  

### 4. Interactive Configuration Steps  

Each step is menu-driven with defaults and custom options:  

- **Container Name**: Default `oracle-adb-container` or custom.  
- **Network Name**: Default `oracle-adb-network` or custom.  
- **Data Directory**: Default `/home/<user>/oracle_data` or custom.  
- **Wallet Directory**: Default `/home/<user>/oracle_wallet` or custom.  
- **Passwords**: Auto-generate or manual input with validation.  
- **Timezone**: Choose from common regions or provide custom.  
- **CPU Cores**: Select from 1, 2, 4 (recommended), 6, 8, or custom.  
- **Memory**: Select from 1g, 2g (recommended), 4g, 8g, or custom.  
- **Character Set**: Default `AL32UTF8` or other options (Arabic, Western European, Japanese, Chinese, or custom).  
- **Ports**: Default (1521, 1522, 8443, 27017, 8888), custom, or skip mapping.  
- **Advanced Options**:  
  - Health checks  
  - Restart policies  
  - Ulimits  

### 5. Summary Review  
After configuration, a summary of all chosen values is displayed.  
The user can:  
- Proceed with setup  
- Edit configuration  
- Return to main menu  

### 6. Execution Steps  

- **Create Directories**: Ensures data and wallet directories exist.  
- **Cleanup Existing**: Stops/removes old containers and networks with same names.  
- **Setup Network and Volumes**: Creates Docker network and volumes for data and logs.  
- **Run Oracle Container**:  
  Builds a `docker run` command dynamically, including:  
  - Name, network, ports  
  - Volumes for data, logs, and wallet  
  - Resource constraints (`--cpus`, `--memory`)  
  - Environment variables:  
    - `ADMIN_PASSWORD`  
    - `WALLET_PASSWORD`  
    - `ORACLE_CHARACTERSET`  
    - `TZ` (timezone)  
    - Database sizing (`PROCESSES`, `SESSIONS`, cache sizes, pool sizes, timeouts)  
  - Optional restart and health check policies  
  - Logging driver configuration  
  - Oracle ADB-Free image: `container-registry.oracle.com/database/adb-free:latest-23ai`  

### 7. Startup Wait  
If health checks are enabled, the script polls the container status until it reports `healthy` or until timeout.  

### 8. Connection Information  
Once running, the script displays:  
- Container name  
- Network name  
- Password status (hidden but confirmed set)  
- Data and wallet directories  
- Ports  
- Example JDBC connection string  

---

## Example Connection String  

```
jdbc:oracle:thin:@localhost:1521/MYATP_high
```

---

## Installation  

Clone the repository and make the script executable:  

```bash
git clone https://github.com/ <your-username>/<your-repo>.git
cd <your-repo>
chmod +x setup_oracle_adb.sh
```

---

## Usage  

Run the script:  

```bash
./setup_oracle_adb.sh
```

### Options  

```
-h, --help     Show help message  
-v, --version  Show script version  
```

---

## Example `docker run` Command Generated  

An example of the command this script generates:  

```bash
docker run -d \
  --name oracle-adb-container \
  --network oracle-adb-network \
  -p 1521:1521 -p 8443:8443 \
  -v oracle-adb-data:/opt/oracle/oradata \
  -v oracle-adb-logs:/opt/oracle/diag \
  -v /home/user/oracle_wallet:/opt/oracle/admin/MYATP/wallet \
  --hostname oracle-adb \
  --shm-size=2g \
  --cpus=4.0 \
  --memory=2g \
  -e ADMIN_PASSWORD=YourPassword \
  -e WALLET_PASSWORD=YourWalletPassword \
  -e ORACLE_CHARACTERSET=AL32UTF8 \
  -e TZ=Asia/Riyadh \
  container-registry.oracle.com/database/adb-free:latest-23ai
```

---

## Author  

**Malek Mohammed Al-Edresi**  
- Advanced Database Solutions  
- Professional Database Administration  

---

## License  

This project is licensed under the **MIT License**.  
