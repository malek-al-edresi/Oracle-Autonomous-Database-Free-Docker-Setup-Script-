#!/bin/bash


# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Global variables
CONTAINER_NAME=""
NETWORK_NAME=""
DATA_DIR=""
WALLET_DIR=""
ADMIN_PASSWORD=""
WALLET_PASSWORD=""
TIMEZONE=""
CPU_CORES=""
MEMORY=""
CHARSET=""
PORTS=()
ADVANCED_OPTIONS=()

print_header() {
    clear
    CYAN='\033[0;36m'
    NC='\033[0m' # Reset color

    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════════════════════════╗"
    echo "║                                                                              ║"
    echo "║       SETUP ORACLE AUTONOMOUS DATABASE FREE CONTAINER IMAGE VIA DOCKER       ║"
    echo "║                     AUTOMATED INSTALLATION SCRIPT                            ║"
    echo "║                                                                              ║"
    echo "║                  Developed by: Malek Mohammed Al-Edresi                      ║"
    echo "║                       Advanced Database Solutions                            ║"
    echo "║                    Professional Database Administration                      ║"
    echo "║                                                                              ║"
    echo "╚══════════════════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Function to print colored messages
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}🚀 ${message}${NC}"
}

# Function to print success messages
print_success() {
    local message=$1
    echo -e "${GREEN}✅ ${message}${NC}"
}

# Function to print error messages
print_error() {
    local message=$1
    echo -e "${RED}❌ ${message}${NC}"
}

# Function to print warning messages
print_warning() {
    local message=$1
    echo -e "${YELLOW}⚠️  ${message}${NC}"
}

# Function to print info messages
print_info() {
    local message=$1
    echo -e "${BLUE}ℹ️  ${message}${NC}"
}

# Function to print menu
print_menu() {
    local title=$1
    local options=("${@:2}")

    echo -e "${PURPLE}╔══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║${WHITE} $title ${PURPLE}║${NC}"
    echo -e "${PURPLE}╠══════════════════════════════════════════════════════════════════════════════╣${NC}"

    for i in "${!options[@]}"; do
        num=$((i + 1))
        echo -e "${PURPLE}║${NC} $num. ${options[$i]} ${PURPLE}║${NC}"
    done

    echo -e "${PURPLE}╚══════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo -e "${WHITE}Enter your choice (1-${#options[@]}): ${NC}"
}

# Function to get user choice
get_user_choice() {
    local options=("$@")
    local choice

    while true; do
        read -p "Enter choice: " choice

        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#options[@]}" ]; then
            return $((choice - 1))
        elif [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -eq 0 ]; then
            # Special case for exit option (if it's at index 0)
            return $((choice - 1))
        else
            print_error "Invalid choice. Please enter a number between 1 and ${#options[@]}"
        fi
    done
}

# Function to select main menu
select_main_menu() {
    local options=(
        "Configure Oracle Database Free Setup"
        "View Current Configuration"
        "Exit"
    )

    print_menu "Main Menu" "${options[@]}"

    get_user_choice "${options[@]}"
    local choice=$?

    case $choice in
        0)
            print_success "Starting configuration..."
            return 0
            ;;
        1)
            view_current_configuration
            select_main_menu
            ;;
        2)
            print_message "${GREEN}" "Thank you for using Malek Mohammed Al-Edresi's Oracle Database Free Setup Script!"
            print_message "${CYAN}" "Goodbye! 👋"
            exit 0
            ;;
    esac
}

# Function to view current configuration
view_current_configuration() {
    print_message "${CYAN}" "Current Configuration"
    echo ""
    echo -e "${WHITE}Container Name:${NC} ${CONTAINER_NAME:-Not set}"
    echo -e "${WHITE}Network:${NC} ${NETWORK_NAME:-Not set}"
    echo -e "${WHITE}Data Directory:${NC} ${DATA_DIR:-Not set}"
    echo -e "${WHITE}Wallet Directory:${NC} ${WALLET_DIR:-Not set}"
    echo -e "${WHITE}Admin Password:${NC} ${ADMIN_PASSWORD:+[SET]}${ADMIN_PASSWORD:-Not set}"
    echo -e "${WHITE}Wallet Password:${NC} ${WALLET_PASSWORD:+[SET]}${WALLET_PASSWORD:-Not set}"
    echo -e "${WHITE}Timezone:${NC} ${TIMEZONE:-Not set}"
    echo -e "${WHITE}CPU Cores:${NC} ${CPU_CORES:-Not set}"
    echo -e "${WHITE}Memory:${NC} ${MEMORY:-Not set}"
    echo -e "${WHITE}Character Set:${NC} ${CHARSET:-Not set}"
    echo -e "${WHITE}Ports:${NC} ${PORTS[*]:-Not set}"
    echo -e "${WHITE}Advanced Options:${NC} ${ADVANCED_OPTIONS[*]:-Not set}"
    echo ""
    read -p "Press Enter to continue..."
}

# Function to select container name
select_container_name() {
    local options=("Default: oracle-adb-container" "Custom name" "Back to main menu")
    print_menu "Container Name" "${options[@]}"

    get_user_choice "${options[@]}"
    local choice=$?

    case $choice in
        0)
            CONTAINER_NAME="oracle-adb-container"
            print_success "Container name set to: $CONTAINER_NAME"
            ;;
        1)
            read -p "Enter custom container name: " CONTAINER_NAME
            CONTAINER_NAME=${CONTAINER_NAME:-"oracle-adb-container"}
            print_success "Container name set to: $CONTAINER_NAME"
            ;;
        2)
            select_main_menu
            return
            ;;
    esac
}

# Function to select network
select_network() {
    local options=("Default: oracle-adb-network" "Custom network name" "Back to main menu")
    print_menu "Network Configuration" "${options[@]}"

    get_user_choice "${options[@]}"
    local choice=$?

    case $choice in
        0)
            NETWORK_NAME="oracle-adb-network"
            print_success "Network name set to: $NETWORK_NAME"
            ;;
        1)
            read -p "Enter custom network name: " NETWORK_NAME
            NETWORK_NAME=${NETWORK_NAME:-"oracle-adb-network"}
            print_success "Network name set to: $NETWORK_NAME"
            ;;
        2)
            select_main_menu
            return
            ;;
    esac
}

# Function to select data directory
select_data_directory() {
    local options=("Default: /home/$(whoami)/oracle_data" "Custom directory" "Back to main menu")
    print_menu "Data Directory" "${options[@]}"

    get_user_choice "${options[@]}"
    local choice=$?

    case $choice in
        0)
            DATA_DIR="/home/$(whoami)/oracle_data"
            print_success "Data directory set to: $DATA_DIR"
            ;;
        1)
            read -p "Enter custom data directory: " DATA_DIR
            DATA_DIR=${DATA_DIR:-"/home/$(whoami)/oracle_data"}
            print_success "Data directory set to: $DATA_DIR"
            ;;
        2)
            select_main_menu
            return
            ;;
    esac
}

# Function to select wallet directory
select_wallet_directory() {
    local options=("Default: /home/$(whoami)/oracle_wallet" "Custom directory" "Back to main menu")
    print_menu "Wallet Directory" "${options[@]}"

    get_user_choice "${options[@]}"
    local choice=$?

    case $choice in
        0)
            WALLET_DIR="/home/$(whoami)/oracle_wallet"
            print_success "Wallet directory set to: $WALLET_DIR"
            ;;
        1)
            read -p "Enter custom wallet directory: " WALLET_DIR
            WALLET_DIR=${WALLET_DIR:-"/home/$(whoami)/oracle_wallet"}
            print_success "Wallet directory set to: $WALLET_DIR"
            ;;
        2)
            select_main_menu
            return
            ;;
    esac
}

# Function to set passwords
set_passwords() {
    local options=("Auto-generate strong passwords" "Set custom passwords" "Back to main menu")
    print_menu "Password Configuration" "${options[@]}"

    get_user_choice "${options[@]}"
    local choice=$?

    case $choice in
        0)
            # Generate strong passwords
            ADMIN_PASSWORD=$(openssl rand -base64 12 | tr -d "=+/" | cut -c1-12)
            ADMIN_PASSWORD="${ADMIN_PASSWORD}A1"
            WALLET_PASSWORD=$(openssl rand -base64 12 | tr -d "=+/" | cut -c1-12)
            WALLET_PASSWORD="${WALLET_PASSWORD}W1"
            print_success "Generated strong passwords"
            print_info "Admin Password: $ADMIN_PASSWORD"
            print_info "Wallet Password: $WALLET_PASSWORD"
            ;;
        1)
            while true; do
                read -sp "Enter admin password (minimum 8 chars, 1 uppercase, 1 lowercase, 1 number): " ADMIN_PASSWORD
                echo
                if validate_password "$ADMIN_PASSWORD"; then
                    break
                fi
            done

            while true; do
                read -sp "Enter wallet password (minimum 8 chars, 1 uppercase, 1 lowercase, 1 number): " WALLET_PASSWORD
                echo
                if validate_password "$WALLET_PASSWORD"; then
                    break
                fi
            done
            ;;
        2)
            select_main_menu
            return
            ;;
    esac
}

# Function to validate password strength
validate_password() {
    local password=$1
    local min_length=8

    if [ ${#password} -lt $min_length ]; then
        print_error "Password must be at least $min_length characters long"
        return 1
    fi

    if ! [[ $password =~ [A-Z] ]]; then
        print_error "Password must contain at least one uppercase letter"
        return 1
    fi

    if ! [[ $password =~ [a-z] ]]; then
        print_error "Password must contain at least one lowercase letter"
        return 1
    fi

    if ! [[ $password =~ [0-9] ]]; then
        print_error "Password must contain at least one number"
        return 1
    fi

    return 0
}

# Function to select timezone
select_timezone() {
    local timezones=(
        "Asia/Riyadh (Default)"
        "UTC"
        "Europe/London"
        "America/New_York"
        "America/Los_Angeles"
        "Asia/Tokyo"
        "Australia/Sydney"
        "Custom timezone"
        "Back to main menu"
    )

    print_menu "Timezone Selection" "${timezones[@]}"

    get_user_choice "${timezones[@]}"
    local choice=$?

    case $choice in
        0)
            TIMEZONE="Asia/Riyadh"
            print_success "Timezone set to: $TIMEZONE"
            ;;
        1)
            TIMEZONE="UTC"
            print_success "Timezone set to: $TIMEZONE"
            ;;
        2)
            TIMEZONE="Europe/London"
            print_success "Timezone set to: $TIMEZONE"
            ;;
        3)
            TIMEZONE="America/New_York"
            print_success "Timezone set to: $TIMEZONE"
            ;;
        4)
            TIMEZONE="America/Los_Angeles"
            print_success "Timezone set to: $TIMEZONE"
            ;;
        5)
            TIMEZONE="Asia/Tokyo"
            print_success "Timezone set to: $TIMEZONE"
            ;;
        6)
            TIMEZONE="Australia/Sydney"
            print_success "Timezone set to: $TIMEZONE"
            ;;
        7)
            read -p "Enter custom timezone (e.g., Asia/Dubai): " TIMEZONE
            TIMEZONE=${TIMEZONE:-"Asia/Riyadh"}
            print_success "Timezone set to: $TIMEZONE"
            ;;
        8)
            select_main_menu
            return
            ;;
    esac
}

# Function to select CPU cores
select_cpu_cores() {
    local options=(
        "1.0 cores (Minimum)"
        "2.0 cores"
        "4.0 cores (Recommended)"
        "6.0 cores"
        "8.0 cores"
        "Custom value"
        "Back to main menu"
    )

    print_menu "CPU Cores Allocation" "${options[@]}"

    get_user_choice "${options[@]}"
    local choice=$?

    case $choice in
        0)
            CPU_CORES="1.0"
            print_success "CPU cores set to: $CPU_CORES"
            ;;
        1)
            CPU_CORES="2.0"
            print_success "CPU cores set to: $CPU_CORES"
            ;;
        2)
            CPU_CORES="4.0"
            print_success "CPU cores set to: $CPU_CORES"
            ;;
        3)
            CPU_CORES="6.0"
            print_success "CPU cores set to: $CPU_CORES"
            ;;
        4)
            CPU_CORES="8.0"
            print_success "CPU cores set to: $CPU_CORES"
            ;;
        5)
            read -p "Enter custom CPU cores (e.g., 3.5): " CPU_CORES
            CPU_CORES=${CPU_CORES:-"4.0"}
            print_success "CPU cores set to: $CPU_CORES"
            ;;
        6)
            select_main_menu
            return
            ;;
    esac
}

# Function to select memory
select_memory() {
    local options=(
        "1g (Minimum)"
        "2g (Recommended)"
        "4g"
        "8g"
        "Custom value"
        "Back to main menu"
    )

    print_menu "Memory Allocation" "${options[@]}"

    get_user_choice "${options[@]}"
    local choice=$?

    case $choice in
        0)
            MEMORY="1g"
            print_success "Memory set to: $MEMORY"
            ;;
        1)
            MEMORY="2g"
            print_success "Memory set to: $MEMORY"
            ;;
        2)
            MEMORY="4g"
            print_success "Memory set to: $MEMORY"
            ;;
        3)
            MEMORY="8g"
            print_success "Memory set to: $MEMORY"
            ;;
        4)
            read -p "Enter custom memory (e.g., 3g, 512m): " MEMORY
            MEMORY=${MEMORY:-"2g"}
            print_success "Memory set to: $MEMORY"
            ;;
        5)
            select_main_menu
            return
            ;;
    esac
}

# Function to select character set
select_charset() {
    local charsets=(
        "AL32UTF8 (Default, Unicode)"
        "AR8MSWIN1256 (Arabic)"
        "WE8MSWIN1252 (Western European)"
        "JA16SJIS (Japanese)"
        "ZHS16GBK (Chinese)"
        "Custom charset"
        "Back to main menu"
    )

    print_menu "Character Set" "${charsets[@]}"

    get_user_choice "${charsets[@]}"
    local choice=$?

    case $choice in
        0)
            CHARSET="AL32UTF8"
            print_success "Character set set to: $CHARSET"
            ;;
        1)
            CHARSET="AR8MSWIN1256"
            print_success "Character set set to: $CHARSET"
            ;;
        2)
            CHARSET="WE8MSWIN1252"
            print_success "Character set set to: $CHARSET"
            ;;
        3)
            CHARSET="JA16SJIS"
            print_success "Character set set to: $CHARSET"
            ;;
        4)
            CHARSET="ZHS16GBK"
            print_success "Character set set to: $CHARSET"
            ;;
        5)
            read -p "Enter custom character set: " CHARSET
            CHARSET=${CHARSET:-"AL32UTF8"}
            print_success "Character set set to: $CHARSET"
            ;;
        6)
            select_main_menu
            return
            ;;
    esac
}

# Function to select ports
select_ports() {
    local options=(
        "Default ports (1521,1522,8443,27017,8888)"
        "Custom ports"
        "Skip port mapping"
        "Back to main menu"
    )

    print_menu "Port Configuration" "${options[@]}"

    get_user_choice "${options[@]}"
    local choice=$?

    case $choice in
        0)
            PORTS=(1521 1522 8443 27017 8888)
            print_success "Default ports selected"
            ;;
        1)
            read -p "Enter ports separated by space (e.g., 1521 1522 8443): " port_input
            PORTS=($port_input)
            print_success "Custom ports set: ${PORTS[*]}"
            ;;
        2)
            print_warning "Port mapping skipped"
            ;;
        3)
            select_main_menu
            return
            ;;
    esac
}

# Function to select advanced options
select_advanced_options() {
    local options=(
        "Enable health checks (Recommended)"
        "Disable health checks"
        "Enable restart always"
        "Disable restart policy"
        "Configure ulimits"
        "Skip advanced options"
        "Back to main menu"
    )

    print_menu "Advanced Options" "${options[@]}"

    while true; do
        get_user_choice "${options[@]}"
        local choice=$?

        case $choice in
            0)
                ADVANCED_OPTIONS+=("health-checks")
                print_success "Health checks enabled"
                ;;
            1)
                print_warning "Health checks disabled"
                ;;
            2)
                ADVANCED_OPTIONS+=("restart-always")
                print_success "Restart always policy enabled"
                ;;
            3)
                print_warning "Restart policy disabled"
                ;;
            4)
                ADVANCED_OPTIONS+=("ulimits")
                print_success "Ulimits configuration enabled"
                ;;
            5)
                print_info "Advanced options completed"
                break
                ;;
            6)
                select_main_menu
                return
                ;;
        esac

        read -p "Add another option? (y/n) or press Enter to continue: " continue_choice
        if [[ ! "$continue_choice" =~ ^[Yy]$ ]]; then
            break
        fi
    done
}

# Function to show summary
show_summary() {
    print_message "${CYAN}" "Configuration Summary"
    echo ""
    echo -e "${WHITE}Container Name:${NC} $CONTAINER_NAME"
    echo -e "${WHITE}Network:${NC} $NETWORK_NAME"
    echo -e "${WHITE}Data Directory:${NC} $DATA_DIR"
    echo -e "${WHITE}Wallet Directory:${NC} $WALLET_DIR"
    echo -e "${WHITE}Admin Password:${NC} [SET]"
    echo -e "${WHITE}Wallet Password:${NC} [SET]"
    echo -e "${WHITE}Timezone:${NC} $TIMEZONE"
    echo -e "${WHITE}CPU Cores:${NC} $CPU_CORES"
    echo -e "${WHITE}Memory:${NC} $MEMORY"
    echo -e "${WHITE}Character Set:${NC} $CHARSET"
    echo -e "${WHITE}Ports:${NC} ${PORTS[*]}"
    echo -e "${WHITE}Advanced Options:${NC} ${ADVANCED_OPTIONS[*]}"
    echo ""

    local options=("Proceed with setup" "Edit configuration" "Back to main menu")
    print_menu "Setup Options" "${options[@]}"

    get_user_choice "${options[@]}"
    local choice=$?

    case $choice in
        0)
            return 0
            ;;
        1)
            print_warning "Returning to configuration menu..."
            return 1
            ;;
        2)
            select_main_menu
            return 2
            ;;
    esac
}

# Function to validate Docker installation
check_docker() {
    print_info "Checking Docker installation..."
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed or not in PATH"
        print_message "${YELLOW}" "Please install Docker first and try again"
        exit 1
    fi
    print_success "Docker is installed: $(docker --version)"
}

# Function to create directories
create_directories() {
    print_info "Creating directories..."

    mkdir -p "$DATA_DIR" || { print_error "Failed to create data directory: $DATA_DIR"; exit 1; }
    mkdir -p "$WALLET_DIR" || { print_error "Failed to create wallet directory: $WALLET_DIR"; exit 1; }

    print_success "Directories created successfully"
}

# Function to cleanup existing
cleanup_existing() {
    print_info "Cleaning up existing containers..."

    if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
        print_message "${YELLOW}" "Stopping existing container: $CONTAINER_NAME"
        docker stop "$CONTAINER_NAME" 2>/dev/null

        print_message "${YELLOW}" "Removing existing container: $CONTAINER_NAME"
        docker rm "$CONTAINER_NAME" 2>/dev/null
    fi

    if docker network ls --format '{{.Name}}' | grep -q "^${NETWORK_NAME}$"; then
        print_message "${YELLOW}" "Removing existing network: $NETWORK_NAME"
        docker network rm "$NETWORK_NAME" 2>/dev/null
    fi

    print_success "Cleanup completed"
}

# Function to setup network and volumes
setup_network_volumes() {
    print_info "Setting up network and volumes..."

    docker network create "$NETWORK_NAME" 2>/dev/null || true
    docker volume create oracle-adb-data 2>/dev/null || true
    docker volume create oracle-adb-logs 2>/dev/null || true

    print_success "Network and volumes created"
}

# Function to run Oracle container
run_oracle_container() {
    print_info "Starting Oracle Database Free container..."

    local docker_cmd="docker run -d \
        --name '$CONTAINER_NAME' \
        --network '$NETWORK_NAME'"

    # Add port mappings
    for port in "${PORTS[@]}"; do
        docker_cmd="$docker_cmd -p $port:$port"
    done

    # Add basic configuration
    docker_cmd="$docker_cmd \
        -e WORKLOAD_TYPE=ATP \
        -v oracle-adb-/opt/oracle/oradata \
        -v oracle-adb-logs:/opt/oracle/diag \
        -v '$WALLET_DIR:/opt/oracle/admin/MYATP/wallet' \
        --hostname oracle-adb \
        --shm-size=2g \
        --cpus='$CPU_CORES' \
        --memory='$MEMORY' \
        --memory-swap='6g' \
        --cpu-shares=1024 \
        -e ADMIN_PASSWORD='$ADMIN_PASSWORD' \
        -e WALLET_PASSWORD='$WALLET_PASSWORD' \
        -e ORACLE_CHARACTERSET='$CHARSET' \
        -e TZ='$TIMEZONE' \
        -e PROCESSES=1000 \
        -e SESSIONS=500 \
        -e DB_CACHE_SIZE=1G \
        -e SHARED_POOL_SIZE=512M \
        -e PGA_AGGREGATE_TARGET=1G \
        -e SQLNET.INBOUND_CONNECT_TIMEOUT=60 \
        -e SQLNET.OUTBOUND_CONNECT_TIMEOUT=60 \
        -e TCP.CONNECT_TIMEOUT=10"

    # Add advanced options
    if [[ " ${ADVANCED_OPTIONS[@]} " =~ " restart-always " ]]; then
        docker_cmd="$docker_cmd --restart=always"
    fi

    if [[ " ${ADVANCED_OPTIONS[@]} " =~ " health-checks " ]]; then
        docker_cmd="$docker_cmd \
            --health-cmd='lsnrctl status' \
            --health-interval=30s \
            --health-timeout=10s \
            --health-retries=3 \
            --health-start-period=120s"
    fi

    if [[ " ${ADVANCED_OPTIONS[@]} " =~ " ulimits " ]]; then
        docker_cmd="$docker_cmd \
            --ulimit nofile=1048576:1048576 \
            --ulimit nproc=1048576:1048576 \
            --sysctl net.core.somaxconn=65535 \
            --sysctl net.ipv4.ip_local_port_range='1024 65535'"
    fi

    # Add logging options
    docker_cmd="$docker_cmd \
        --log-driver=json-file \
        --log-opt max-size=100m \
        --log-opt max-file=3"

    # Add image
    docker_cmd="$docker_cmd \
        container-registry.oracle.com/database/adb-free:latest-23ai"

    # Execute the command
    eval $docker_cmd

    if [ $? -eq 0 ]; then
        print_success "Oracle Database Free container started successfully"
    else
        print_error "Failed to start Oracle Database Free container"
        exit 1
    fi
}

# Function to show connection information
show_connection_info() {
    print_message "${GREEN}" "Connection Information"
    echo ""
    echo -e "${WHITE}Container Name:${NC} $CONTAINER_NAME"
    echo -e "${WHITE}Network:${NC} $NETWORK_NAME"
    echo -e "${WHITE}Admin Password:${NC} [SET]"
    echo -e "${WHITE}Wallet Password:${NC} [SET]"
    echo -e "${WHITE}Data Directory:${NC} $DATA_DIR"
    echo -e "${WHITE}Wallet Directory:${NC} $WALLET_DIR"
    echo ""
    echo -e "${WHITE}Ports:${NC} ${PORTS[*]}"
    echo ""
    echo -e "${WHITE}Connection String:${NC}"
    echo -e "  ${CYAN}jdbc:oracle:thin:@localhost:1521/MYATP_high"
    echo ""
    print_success "Setup completed successfully! 🎉"
}

# Function to wait for startup
wait_for_startup() {
    print_info "Waiting for Oracle Database to start..."
    print_message "${YELLOW}" "This may take 2-3 minutes..."

    local timeout=180
    local count=0

    while [ $count -lt $timeout ]; do
        if docker inspect --format='{{json .State.Health}}' "$CONTAINER_NAME" &>/dev/null; then
            local status=$(docker inspect --format='{{json .State.Health}}' "$CONTAINER_NAME")
            local health=$(echo "$status" | jq -r '.Status' 2>/dev/null)
            if [ "$health" = "healthy" ]; then
                print_success "Oracle Database is ready! 🚀"
                return 0
            fi
        fi
        sleep 10
        ((count += 10))
    done

    print_warning "Container may still be starting up. Check status with: docker ps"
}

# Function to display help
show_help() {
    echo -e "${CYAN}Oracle Database Free Setup Script${NC}"
    echo ""
    echo -e "${WHITE}Usage:${NC}"
    echo "  $0 [OPTIONS]"
    echo ""
    echo -e "${WHITE}Options:${NC}"
    echo "  -h, --help     Show this help message"
    echo "  -v, --version  Show script version"
    echo ""
    echo -e "${WHITE}Description:${NC}"
    echo "  This script provides an interactive setup for Oracle Database Free using Docker."
    echo "  It allows you to choose various configuration options interactively."
    echo ""
    echo -e "${WHITE}Developed by:${NC} Malek Mohammed Al-Edresi"
    echo -e "${WHITE}Version:${NC} 1.0.0"
}

# Function to display version
show_version() {
    echo -e "${CYAN}Oracle Database Free Setup Script${NC}"
    echo -e "${WHITE}Version:${NC} 1.0.0"
    echo -e "${WHITE}Developed by:${NC} Malek Mohammed Al-Edresi"
}

# Main configuration function
main_configuration() {
    print_message "${PURPLE}" "Starting Interactive Configuration"
    echo ""

    select_container_name
    echo ""

    select_network
    echo ""

    select_data_directory
    echo ""

    select_wallet_directory
    echo ""

    set_passwords
    echo ""

    select_timezone
    echo ""

    select_cpu_cores
    echo ""

    select_memory
    echo ""

    select_charset
    echo ""

    select_ports
    echo ""

    select_advanced_options
    echo ""

    local continue_setup=1
    while [ $continue_setup -ne 0 ]; do
        show_summary
        continue_setup=$?
        if [ $continue_setup -eq 1 ]; then
            main_configuration
            break
        elif [ $continue_setup -eq 2 ]; then
            select_main_menu
            break
        fi
    done

    # If we get here, user chose to proceed
    if [ $continue_setup -eq 0 ]; then
        # Create directories
        create_directories

        # Cleanup existing setup
        cleanup_existing

        # Setup network and volumes
        setup_network_volumes

        # Run Oracle container
        run_oracle_container

        # Wait for startup
        wait_for_startup

        # Show connection information
        show_connection_info

        print_message "${GREEN}" "Thank you for using Malek Mohammed Al-Edresi's Oracle Database Free Setup Script! 🚀"
        print_message "${WHITE}" "For support and consulting, contact: Malek Mohammed Al-Edresi"
    fi
}

# Main function
main() {
    # Check for help or version flags
    case "$1" in
        -h|--help)
            show_help
            exit 0
            ;;
        -v|--version)
            show_version
            exit 0
            ;;
    esac

    # Print header
    print_header

    # Check prerequisites
    check_docker

    # Show main menu
    select_main_menu

    # If we get here from main menu, run configuration
    main_configuration
}

# Trap to handle script interruption
trap 'echo -e "\n${YELLOW}Script interrupted by user${NC}"; exit 130' INT

# Run main function
main "$@"
