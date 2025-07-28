#!/usr/bin/env bash
# The Abyss Sysadmin Toolbox
# Copyright (c) 2025 Lord Sodomiser
# Licensed under the Mozilla Public License 2.0 or commercial license.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

source "$(dirname "$(readlink -f "$0")")/.configs/.env"

log() {
	echo "$(date '+%Y-%m-%d %H:%M:%S') - $USER - $*" >> "$LOG_FILE"
}

setup_traps() {
	trap  'echo "Interrupted (Ctrl+C)"; exit 1' INT
	trap 'echo "Terminated"; exit 1' TERM
	trap 'echo "Error on line $LINEO"; exit 1' ERR
}

show_banner() {
	cat << "EOF"
▄▄▄█████▓ ██░ ██ ▓█████
▓  ██▒ ▓▒▓██░ ██▒▓█   ▀
▒ ▓██░ ▒░▒██▀▀██░▒███
░ ▓██▓ ░ ░▓█ ░██ ▒▓█  ▄
  ▒██▒ ░ ░▓█▒░██▓░▒████▒
  ▒ ░░    ▒ ░░▒░▒░░ ▒░ ░
    ░     ▒ ░▒░ ░ ░ ░  ░
  ░       ░  ░░ ░   ░
          ░  ░  ░   ░  ░

 ▄▄▄       ▄▄▄▄ ▓██   ██▓  ██████   ██████
▒████▄    ▓█████▄▒██  ██▒▒██    ▒ ▒██    ▒
▒██  ▀█▄  ▒██▒ ▄██▒██ ██░░ ▓██▄   ░ ▓██▄
░██▄▄▄▄██ ▒██░█▀  ░ ▐██▓░  ▒   ██▒  ▒   ██▒
 ▓█   ▓██▒░▓█  ▀█▓░ ██▒▓░▒██████▒▒▒██████▒▒
 ▒▒   ▓▒█░░▒▓███▀▒ ██▒▒▒ ▒ ▒▓▒ ▒ ░▒ ▒▓▒ ▒ ░
  ▒   ▒▒ ░▒░▒   ░▓██ ░▒░ ░ ░▒  ░ ░░ ░▒  ░ ░
  ░   ▒    ░    ░▒ ▒ ░░  ░  ░  ░  ░  ░  ░
      ░  ░ ░     ░ ░           ░        ░
                ░░ ░
  ██████▓██   ██▓  ██████  ▄▄▄      ▓█████▄  ███▄ ▄███▓ ██▓ ███▄    █
▒██    ▒ ▒██  ██▒▒██    ▒ ▒████▄    ▒██▀ ██▌▓██▒▀█▀ ██▒▓██▒ ██ ▀█   █
░ ▓██▄    ▒██ ██░░ ▓██▄   ▒██  ▀█▄  ░██   █▌▓██    ▓██░▒██▒▓██  ▀█ ██▒
  ▒   ██▒ ░ ▐██▓░  ▒   ██▒░██▄▄▄▄██ ░▓█▄   ▌▒██    ▒██ ░██░▓██▒  ▐▌██▒
▒██████▒▒ ░ ██▒▓░▒██████▒▒ ▓█   ▓██▒░▒████▓ ▒██▒   ░██▒░██░▒██░   ▓██░
▒ ▒▓▒ ▒ ░  ██▒▒▒ ▒ ▒▓▒ ▒ ░ ▒▒   ▓▒█░ ▒▒▓  ▒ ░ ▒░   ░  ░░▓  ░ ▒░   ▒ ▒
░ ░▒  ░ ░▓██ ░▒░ ░ ░▒  ░ ░  ▒   ▒▒ ░ ░ ▒  ▒ ░  ░      ░ ▒ ░░ ░░   ░ ▒░
░  ░  ░  ▒ ▒ ░░  ░  ░  ░    ░   ▒    ░ ░  ░ ░      ░    ▒ ░   ░   ░ ░
      ░  ░ ░           ░        ░  ░   ░           ░    ░           ░
         ░ ░                         ░
▄▄▄█████▓ ▒█████   ▒█████   ██▓     ▄▄▄▄    ▒█████  ▒██   ██▒
▓  ██▒ ▓▒▒██▒  ██▒▒██▒  ██▒▓██▒    ▓█████▄ ▒██▒  ██▒▒▒ █ █ ▒░
▒ ▓██░ ▒░▒██░  ██▒▒██░  ██▒▒██░    ▒██▒ ▄██▒██░  ██▒░░  █   ░
░ ▓██▓ ░ ▒██   ██░▒██   ██░▒██░    ▒██░█▀  ▒██   ██░ ░ █ █ ▒
  ▒██▒ ░ ░ ████▓▒░░ ████▓▒░░██████▒░▓█  ▀█▓░ ████▓▒░▒██▒ ▒██▒
  ▒ ░░   ░ ▒░▒░▒░ ░ ▒░▒░▒░ ░ ▒░▓  ░░▒▓███▀▒░ ▒░▒░▒░ ▒▒ ░ ░▓ ░
    ░      ░ ▒ ▒░   ░ ▒ ▒░ ░ ░ ▒  ░▒░▒   ░   ░ ▒ ▒░ ░░   ░▒ ░
  ░      ░ ░ ░ ▒  ░ ░ ░ ▒    ░ ░    ░    ░ ░ ░ ░ ▒   ░    ░
             ░ ░      ░ ░      ░  ░ ░          ░ ░   ░    ░
                                         ░
EOF
}

[[ -f "$LOG_FILE" ]] || touch "$LOG_FILE"

disk_mgmt() {
	while true; do
		choice=$(echo -e "Back\nShow Drive UUID\nRun cfdisk\nManage Partitions\nList Block Devices\nCheck Disk Usage\nCheck Disk Free Space" | fzf)

		if [[ -z "$choice" ]]; then
			echo "No selection made. Returning to main menu..."
			sleep 2
			break
		fi

		case "$choice" in
			"Check Disk Free Space")
				cmd="df -h"
				log "$USER viewed disk info using '$cmd'"
				echo ""
				echo ""
				echo "[$USER@$HOS]$ $cmd"
				$cmd | tee -a "$LOG_FILE"
				sleep 1
				echo ""
				echo ""
				read -rp "Press enter to return..."
				;;
			"Check Disk Usage")
				path_choice=$(echo -e "Root Disk\nCustom Path\nAll Mounted Filesystems" | fzf)
				if [[ -z "$path_choice" ]]; then
					echo "No path selected. Returning to disk management menu..."
					sleep 2
					continue
				fi
				case "$path_choice" in
					"All Mounted Filesystems")
						cmd="sudo df -h"
						log "$USER viewed disk usage using $cmd"
						echo ""
						echo ""
						echo "[$USER@$HOST]$ $cmd"
						$cmd 2>/dev/null | tee -a "$LOG_FILE"
						sleep 1
						echo ""
						echo ""
						read -rp "Press enter to return..."
						;;
					"Custom Path")
						read -p "Enter directory path to check (or press Enter for current directory): " path
						path=${path:-.}
						if [[ -d "$path" ]]; then
							cmd="du -h --max-depth=1 $path"
							log "$USER viewed disk usage using '$cmd'"
							echo ""
							echo ""
							echo "[$USER@$HOST]$ $cmd"
							$cmd 2>/dev/null | tee -a "$LOG_FILE"
							sleep 1
							echo ""
							echo ""
							read -rp "Press enter to return..."
						else
							echo "Invalid directory: $path"
							sleep 2
						fi
						;;
					"Root Disk")
						path="/"
						cmd="sudo df -h $path"
						log "$USER viewed disk usage using '$cmd'"
						echo ""
						echo ""
						echo "[$USER@$HOST]$ $cmd"
						$cmd 2>/dev/null | tee -a "$LOG_FILE"
						sleep 1
						echo ""
						echo ""
						read -rp "Press enter to return..."
						;;
				esac
				;;
			"List Block Devices")
				cmd="lsblk"
				log "$USER viewed disk info using '$cmd'"
				echo ""
				echo ""
				echo "[$USER@$HOST]$ $cmd"
				$cmd | tee -a "$LOG_FILE"
				sleep 1
				echo ""
				echo ""
				read -p "Would you like to mount a device? (y/N): " mount_choice
				if [[ "$mount_choice" =~ ^[yY]$ ]]; then
					read -p "Enter device path (e.g., /dev/sda1 /dev/nvme0n1p1): " device
					read -p "Enter mount point (e.g., /mnt): " mountpoint
					if [[ -b "$device" && -d "$mountpoint" ]]; then
						cmd="mount $device $mountpoint"
						log "$USER mounted drive using $cmd"
						echo ""
						echo ""
						echo "[$USER@$HOST]$ $cmd"
						sudo $cmd | tee -a "$LOG_FILE"
						sleep 1
						echo ""
						echo ""
					else
						echo "Invalid decive or mount point..."
						sleep 2
					fi
				fi
				echo ""
				echo ""
				read -rp "Press enter to return..."
				;;
			"Manage Partitions")
			       	read -p "Enter device path (e.g., /dev/sda): " device
				if [[ -b "$device" ]]; then
					cmd="parted $device"
					log "$USER managed partitions using '$cmd'"
					echo ""
					echo ""
					echo "[$USER@$HOST]$ $cmd"
					sudo $cmd | tee -a "$LOG_FILE"
					sleep 1
					echo ""
					echo ""read -rp "Press enter to return..."
				else
					echo "Invalid device: $device"
					sleep 2
				fi
				;;
			"Run cfdisk")
				read -p "Enter device path (e.g., /dev/sda): " device

				if [[ -b "$device" ]]; then
					cmd="cfdisk $device"
					log "$USER managed partitions using '$cmd'"
					echo ""
					echo ""
					echo "[$USER@$HOST]$ $cmd"
					sudo $cmd | tee -a "$LOG_FILE"
					sleep 1
					echo ""
					echo ""
					read -rp "Press enter to return..."
				else
					echo "Invalid device: $device"
					sleep 2
				fi
				;;
			"Show Drive UUID")
				read -p "Entire device path (e.g., /dev/sda /dev/nvme0n1): " device
				if [[ -b "$device" ]]; then 
					cmd="blkid $device"
					log "$USER viewed drive UUID using '$cmd'"
					echo ""
					echo ""
					echo "[$USER@$HOST]$ $cmd"
					sudo $cmd | tee -a "$LOG_FILE"
					sleep 1
					echo ""
					echo ""
					read -rp "Press enter to return..."
				else
					echo "Invalid device: $device"
					sleep 2
				fi
				;;
			"Back")
				echo "Returning to main menu..."
				echo ""
				echo ""
				break
				;;
			*)
				echo "Invalid selection."
				sleep 2
				;;
		esac
	done
}

# File Management Submenu
file_mgmt() {
	while true; do
		choice=$(echo -e "Back\nView File\nRemove File\nMove File\nList Files\nCopy File\nChange Permissions\nChange Ownership" | fzf)
		
		if [[ -z "$choice" ]]; then
			echo "No selection made. Returning to main menu..."
			sleep 2
			break
		fi

		case "$choice" in
			"Change Ownership")
				read -p "Enter file or directory path: " path
				read -p "Enter owner (user[:group]): " owner
				if [[ -e "$path" && -n "$owner" ]]; then
					cmd="chown $owner $path"
					log "$USER changed ownership using '$cmd'"
					echo ""
					echo ""
					echo "[$USER@$HOST]$ $cmd"
					sudo $cmd | tee -a "$LOG_FILE"
					sleep 1
					echo ""
					echo ""
					read -rp "Press enter to return..."
				else
					echo "Invalid path or owner."
					sleep 2
				fi
				;;
			"Change Permissions")
				read -p "Enter file or directory path: " path
				read -p "Enter permissions (e.g., 755): " perms
				if [[ -e "$path" && "$perms" =~ ^[0-7]{3}$ ]]; then
					cmd="chmod $perms $path"
					log "$USER changed permissions using '$cmd'"
					echo ""
					echo ""
					echo "[$USER@$HOST]$ $cmd"
					$cmd | tee -a "$LOG_FILE"
					sleep 1
					echo ""
					echo ""
					read -rp "Press enter to return..."
				else
					echo "Invalid path or permissions format."
					sleep 2
				fi
				;;
			"Copy File")
				read -p "Enter source file path: " src
				read -p "Enter destination path: " dest
				if [[ -f "$src" && -d "$(dirname "$dest")" ]]; then
					cmd="cp $src $dest"
					log "$USER copied file using '$cmd'"
					echo ""
					echo ""
					echo "[$USER@$HOST]$ $cmd"
					$cmd | tee -a "$LOG_FILE"
					sleep 1
					echo ""
					echo ""
					read -rp "Press enter to return..."
				else
					echo "Invalid source file or destination directory."
					sleep 2
				fi
				;;
			"List Files")
				read -p "Enter directory path to list (or press Enter for current directory): " path
				path=${path:-.}  # Default to current directory if empty
				if [[ -d "$path" ]]; then
					cmd="ls -la $path"
					log "$USER listed files using '$cmd'"
					echo ""
					echo ""
					echo "[$USER@$HOST]$ $cmd"
					$cmd | tee -a "$LOG_FILE"
					sleep 1
					echo ""
					echo ""
					read -rp "Press enter to return..."
				else
					echo "Invalid directory: $path"
					sleep 2
				fi
				;;
			"Move File")
				read -p "Enter source file path: " src
				read -p "Enter destination path: " dest
				if [[ -f "$src" && -d "$(dirname "$dest")" ]]; then
					cmd="mv $src $dest"
					log "$USER moved file using '$cmd'"
					echo ""
					echo ""
					echo "[$USER@$HOST]$ $cmd"
					$cmd | tee -a "$LOG_FILE"
					sleep 1
					echo ""
					echo ""
					read -rp "Press enter to return..."
				else
					echo "Invalid source file or destination directory."
					sleep 2
				fi
				;;
			"Remove File")
				read -p "Enter file path to remove: " file
				if [[ -f "$file" ]]; then
					cmd="rm $file"
					log "$USER removed file using '$cmd'"
					echo ""
					echo ""
					echo "[$USER@$HOST]$ $cmd"
					$cmd | tee -a "$LOG_FILE"
					sleep 1
					echo ""
					echo ""
					read -rp "Press enter to return..."
				else
					echo "Invalid file: $file"
					sleep 2
				fi
				;;
			"View File")
				read -p "Enter file path to view: " file
				if [[ -f "$file" ]]; then
					cmd="cat $file"
					log "$USER viewed file using '$cmd'"
					echo ""
					echo ""
					echo "[$USER@$HOST]$ $cmd"
					$cmd | tee -a "$LOG_FILE"
					sleep 1
					echo ""
					echo ""
					read -rp "Press enter to return..."
				else
					echo "Invalid file: $file"
					sleep 2
				fi
				;;
			"Back")
				echo "Returning to main menu..."
				echo ""
				echo ""
				break
				;;
			*)
				echo "Invalid selection."
				sleep 2
				;;
		esac
	done
}

# File System Checks Submenu
file_sys_chks() {
	while true; do
		choice=$(echo -e "Back\nRun fsck\nFind Files" | fzf)
        
		if [[ -z "$choice" ]]; then
			echo "No selection made. Returning to main menu..."
			sleep 2
			break
		fi

		case "$choice" in
			"Find Files")
				read -p "Enter search path (or press Enter for current directory): " path
				path=${path:-.}  # Default to current directory
				read -p "Enter file name or pattern to search: " pattern
				if [[ -d "$path" ]]; then
					cmd="find $path -name $pattern"
					log "$USER searched files using '$cmd'"
					echo ""
					echo ""
					echo "[$USER@$HOST]$ $cmd"
					$cmd | tee -a "$LOG_FILE"
					sleep 1
					echo ""
					echo ""
					read -rp "Press enter to return..."
				else
					echo "Invalid directory: $path"
					sleep 2
				fi
				;;
			"Run fsck")
				read -p "Enter device path (e.g., /dev/sda1 /dev/nvme0n1p1): " device
				if [[ -b "$device" ]]; then
					cmd="fsck $device"
					log "$USER checked filesystem using '$cmd'"
					echo ""
					echo ""
					echo "[$USER@$HOST]$ $cmd"
					sudo $cmd | tee -a "$LOG_FILE"
					sleep 1
					echo ""
					echo ""
					read -rp "Press enter to return..."
				else
					echo "Invalid device: $device"
					sleep 2
				fi
				;;
			"Back")
				echo "Returning to main menu..."
				echo ""
				echo ""
				break
				;;
			*)
				echo "Invalid selection."
				sleep 2
				;;
		esac
	done
}

# Log Viewing Submenu
log_viewing() {
	while true; do
		choice=$(echo -e "Back\nView Log File\nView File Content\nTail Log File\nSearch Logs" | fzf)
        
		if [[ -z "$choice" ]]; then
			echo "No selection made. Returning to main menu..."
			sleep 2
			break
		fi

		case "$choice" in
			"Search Logs")
				read -p "Enter log file path: " file
				read -p "Enter search pattern: " pattern
				if [[ -f "$file" ]]; then
					cmd="grep $pattern $file"
					log "$USER searched logs using '$cmd'"
					echo ""
					echo ""
					echo "[$USER@$HOST]$ $cmd"
					$cmd | tee -a "$LOG_FILE"
					sleep 1
					echo ""
					echo ""
					read -rp "Press enter to return..."
				else
					echo "Invalid file: $file"
					sleep 2
				fi
				;;
			"Tail Log File")
				read -p "Enter log file path: " file
				read -p "Enter number of lines to tail (default 10): " lines
				lines=${lines:-10}
				if [[ -f "$file" && "$lines" =~ ^[0-9]+$ ]]; then
					cmd="tail -n $lines $file"
					log "$USER tailed log file using '$cmd'"
					echo ""
					echo ""
					echo "[$USER@$HOST]$ $cmd"
					$cmd | tee -a "$LOG_FILE"
					sleep 1
					echo ""
					echo ""
					read -rp "Press enter to return..."
				else
					echo "Invalid file or number of lines."
					sleep 2
				fi
				;;
			"View File Content")
				read -p "Enter file path to view: " file
				if [[ -f "$file" ]]; then
					cmd="cat $file"
					log "$USER viewed file using '$cmd'"
					echo ""
					echo ""
					echo "[$USER@$HOST]$ $cmd"
					$cmd | tee -a "$LOG_FILE"
					sleep 1
					echo ""
					echo ""
					read -rp "Press enter to return..."
				else
					echo "Invalid file: $file"
					sleep 2
				fi
				;;
			"View Log File")
				read -p "Enter log file path: " file
				if [[ -f "$file" ]]; then
					cmd="less $file"
					log "$USER viewed log file using '$cmd'"
					echo ""
					echo ""
					echo "[$USER@$HOST]$ $cmd"
					$cmd | tee -a "$LOG_FILE"
					sleep 1
					echo ""
					echo ""
					read -rp "Press enter to return..."
				else
					echo "Invalid file: $file"
					sleep 2
				fi
				;;
			"Back")
				echo "Returning to main menu..."
				echo ""
				echo ""
				break
				;;
			*)
				echo "Invalid selection."
				sleep 2
				;;
		esac
	done
}

# Network Configuration Submenu
net_config() {
	while true; do
		choice=$(echo -e "Back\nShow Socket Statistics\nShow Network Statistics" | fzf)
        
		if [[ -z "$choice" ]]; then
			echo "No selection made. Returning to main menu..."
			sleep 2
			break
		fi

		case "$choice" in
			"Show Network Statistics")
				cmd="netstat"
				log "$USER viewed network statistics using '$cmd'"
				echo ""
				echo ""
				echo "[$USER@$HOST]$ $cmd"
				$cmd | tee -a "$LOG_FILE"
				sleep 1
				echo ""
				echo ""
				read -rp "Press enter to return..."
				;;
			"Show Socket Statistics")
				cmd="ss"
				log "$USER viewed socket statistics using '$cmd'"
				echo ""
				echo ""
				echo "[$USER@$HOST]$ $cmd"
				$cmd | tee -a "$LOG_FILE"
				sleep 1
				echo ""
				echo ""
				read -rp "Press enter to return..."
				;;
			"Back")
				echo "Returning to main menu..."
				echo ""
				echo ""
				break
				;;
			*)
				echo "Invalid selection."
				sleep 2
				;;
		esac
	done
}

# Network Diagnostics Submenu
net_diag() {
	while true; do
		choice=$(echo -e "Back\nShow IP Configuration\nShow Interface Configuration\nPing Host\nNetwork Management UI\nDNS Lookup" | fzf)
        
		if [[ -z "$choice" ]]; then
			echo "No selection made. Returning to main menu..."
			sleep 2
			break
		fi

		case "$choice" in
			"DNS Lookup")
				read -p "Enter domain or IP for lookup: " domain
				if [[ -n "$domain" ]]; then
					cmd="nslookup $domain"
					log "$USER performed DNS lookup using '$cmd'"
					echo ""
					echo ""
					echo "[$USER@$HOST]$ $cmd"
					$cmd | tee -a "$LOG_FILE"
					sleep 1
					echo ""
					echo ""
					read -rp "Press enter to return..."
				else
					echo "No domain or IP specified."
					sleep 2
				fi
				;;
			"Network Management UI")
				cmd="nmtui"
				log "$USER launched network management UI using '$cmd'"
				echo ""
				echo ""
				echo "[$USER@$HOST]$ $cmd"
				$cmd | tee -a "$LOG_FILE"
				sleep 1
				echo ""
				echo ""
				;;
			"Ping Host")
				read -p "Enter host to ping: " host
				if [[ -n "$host" ]]; then
					cmd="ping -c 5 -O $host"
					log "$USER pinged $host using '$cmd'"
					echo ""
					echo ""
					echo "[$USER@$HOST]$ $cmd"
					$cmd | tee -a "$LOG_FILE"
					sleep 1
					echo ""
					echo ""
					read -rp "Press enter to return..."
				else
					echo "No host specified."
					sleep 2
				fi
				;;
			"Show Interface Configuration")
				cmd="ifconfig"
				log "$USER viewed interface configuration using '$cmd'"
				echo ""
				echo ""
				echo "[$USER@$HOST]$ $cmd"
				$cmd | tee -a "$LOG_FILE"
				sleep 1
				echo ""
				echo ""
				read -rp "Press enter to return..."
				;;
			"Show IP Configuration")
				cmd="ip addr"
				log "$USER viewed IP configuration using '$cmd'"
				echo ""
				echo ""
				echo "[$USER@$HOST]$ $cmd"
				$cmd | tee -a "$LOG_FILE"
				sleep 1
				echo ""
				echo ""
				read -rp "Press enter to return..."
				;;
			"Back")
				echo "Returning to main menu..."
				echo ""
				echo ""
				break
				;;
			*)
				echo "Invalid selection."
				sleep 2
				;;
		esac
	done
}

# Security Management Submenu
sec_mgmt() {
	while true; do
		choice=$(echo -e "Back\nShow Last Logins\nShow Firewall Status\nShow Active Users\nDeny Traffic\nAllow Traffic" | fzf)
       
		if [[ -z "$choice" ]]; then
			echo "No selection made. Returning to main menu..."
			sleep 2
			break
		fi

		case "$choice" in
			"Allow Traffic")
				echo "Select traffic type to allow:"
				traffic_type=$(echo -e "Back\nAll Incoming\nAll Outgoing\nIP Address\nSpecific Port" | fzf)
				if [[ -z "$traffic_type" ]]; then
					echo "No traffic type selected."
					sleep 2
					continue
				fi

				case "$traffic_type" in
					"All Incoming")
						echo "Allowing all incoming traffic (requires sudo)..."
						read -p "Are you sure? (y/N): " confirm
						if [[ "$confirm" =~ ^[yY]$ ]]; then
							cmd="ufw allow in"
							log "$USER allowed all incoming traffic using '$cmd'"
							echo ""
							echo ""
							echo "[$USER@$HOST]$ $cmd"
							sudo $cmd | tee -a "$LOG_FILE"
							sleep 1
							echo ""
							echo ""
							read -rp "Press enter to return..."
						else
							echo "Action cancelled."
							sleep 2
						fi
						;;
					"All Outgoing")
						echo "Allowing all outgoing traffic (requires sudo)..."
						read -p "Are you sure? (y/N): " confirm
						if [[ "$confirm" =~ ^[yY]$ ]]; then
							cmd="ufw allow out"
							log "$USER allowed all outgoing traffic using '$cmd'"
							echo ""
							echo ""
							echo "[$USER@$HOST]$ $cmd"
							sudo $cmd | tee -a "$LOG_FILE"
							sleep 1
							echo ""
							echo ""
							read -rp "Press enter to return..."
						else
							echo "Action cancelled."
							sleep 2
						fi
						;;
					"IP Address")
						read -p "Enter IP address: " ip
						if [[ "$ip" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}(/[0-9]{1,2})?$ ]]; then
							cmd="ufw allow from $ip"
							log "$USER allowed traffic from IP using '$cmd'"
							echo ""
							echo ""
							echo "[$USER@$HOST]$ $cmd"
							sudo $cmd | tee -a "$LOG_FILE"
							sleep 1
							echo ""
							echo ""
							read -rp "Press enter to return..."
						else
							echo "Invalid IP address format."
							sleep 2
						fi
						;;
					"Specific Port")
						read -p "Enter port and protocol (e.g., 22/tcp): " port
						if [[ "$port" =~ ^[0-9]+/(tcp|udp)$ ]]; then
							cmd="ufw allow $port"
							log "$USER allowed traffic on port using '$cmd'"
							echo ""
							echo ""
							echo "[$USER@$HOST]$ $cmd"
							sudo $cmd | tee -a "$LOG_FILE"
							sleep 1
							echo ""
							echo ""
							read -rp "Press enter to return..."
						else
							echo "Invalid port/protocol format."
							sleep 2
						fi
						;;
				esac
				;;
			"Deny Traffic")
				echo "Select traffic type to deny:"
				traffic_type=$(echo -e "All Incoming\nAll Outgoing\nIP Address\nSpecific Port" | fzf)
				if [[ -z "$traffic_type" ]]; then
					echo "No traffic type selected."
					sleep 2
					continue
				fi
				case "$traffic_type" in
					"All Incoming")
						echo "Denying all incoming traffic (requires sudo)..."
						read -p "Are you sure? (y/N): " confirm
						if [[ "$confirm" =~ ^[yY]$ ]]; then
							cmd="ufw deny in"
							log "$USER denied all incoming traffic using '$cmd'"
							echo ""
							echo ""
							echo "[$USER@$HOST]$ $cmd"
							sudo $cmd | tee -a "$LOG_FILE"
							sleep 1
							echo ""
							echo ""
							read -rp "Press enter to return..."
						else
							echo "Action cancelled."
							sleep 2
						fi
						;;
					"All Outgoing")
						echo "Denying all outgoing traffic (requires sudo)..."
						read -p "Are you sure? (y/N): " confirm
						if [[ "$confirm" =~ ^[yY]$ ]]; then
							cmd="ufw deny out"
							log "$USER denied all outgoing traffic using '$cmd'"
							echo ""
							echo ""
							echo "[$USER@$HOST]$ $cmd"
							sudo $cmd | tee -a "$LOG_FILE"
							sleep 1
							echo ""
							echo ""
							read -rp "Press enter to return..."
						else
							echo "Action cancelled."
							sleep 2
						fi
						;;
					"IP Address")
						read -p "Enter IP address: " ip
						if [[ "$ip" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}(/[0-9]{1,2})?$ ]]; then
							cmd="ufw deny from $ip"
							log "$USER denied traffic from IP using '$cmd'"
							echo ""
							echo ""
							echo "[$USER@$HOST]$ $cmd"
							sudo $cmd | tee -a "$LOG_FILE"
							sleep 1
							echo ""
							echo ""
							read -rp "Press enter to return..."
						else
							echo "Invalid IP address format."
							sleep 2
						fi
						;;
					"Specific Port")
						read -p "Enter port and protocol (e.g., 22/tcp): " port
						if [[ "$port" =~ ^[0-9]+/(tcp|udp)$ ]]; then
							cmd="ufw deny $port"
							log "$USER denied traffic on port using '$cmd'"
							echo ""
							echo ""
							echo "[$USER@$HOST]$ $cmd"
							sudo $cmd | tee -a "$LOG_FILE"
							sleep 1
							echo ""
							echo ""
							read -rp "Press enter to return..."
						else
							echo "Invalid port/protocol format."
							sleep 2
						fi
						;;
				esac
				;;
			"Show Active Users")
				cmd="who"
				log "$USER viewed active users using '$cmd'"
				echo ""
				echo ""
				echo "[$USER@$HOST]$ $cmd"
				$cmd | tee -a "$LOG_FILE"
				sleep 1
				echo ""
				echo ""
				read -rp "Press enter to return..."
				;;
			"Show Firewall Status")
				cmd="ufw status"
				log "$USER viewed firewall status using '$cmd'"
				echo ""
				echo ""
				echo "[$USER@$HOST]$ $cmd"
				sudo $cmd | tee -a "$LOG_FILE"
				sleep 1
				echo ""
				echo ""
				read -rp "Press enter to return..."
				;;
			"Show Last Logins")
				cmd="last"
				log "$USER viewed last logins using '$cmd'"
				echo ""
				echo ""
				echo "[$USER@$HOST]$ $cmd"
				$cmd | tee -a "$LOG_FILE"
				sleep 1
				echo ""
				echo ""
				read -rp "Press enter to return..."
				;;
			"Back")
				echo "Returning to main menu..."
				echo ""
				echo ""
				break
				;;
			*)
				echo "Invalid selection."
				sleep 2
				;;
		esac
	done
}

# System Monitoring Submenu
sys_mon() {
	while true; do
		choice=$(echo -e "Back\nView Memory Info\nShow Virtual Memory Stats\nShow Last Boot Time\nShow Free Memory\nMonitor Processes (top)\nMonitor Processes (htop)\nList Processes" | fzf)
        
		if [[ -z "$choice" ]]; then
			echo "No selection made. Returning to main menu..."
			sleep 2
			break
		fi
		case "$choice" in
			"List Processes")
				read -p "Enter process filter (e.g., 'aux' or press Enter for default 'ps'): " opts
				read -p "Enter user to filter (or press Enter for none): " user
				if [[ -n "$user" ]]; then
					cmd="ps $opts | grep $user"
					log "$USER listed processes for user using '$cmd'"
					echo ""
					echo ""
					echo "[$USER@$HOST]$ $cmd"
					ps "$opts" | grep "$user" | tee -a "$LOG_FILE"
					sleep 1
					echo ""
					echo ""
					read -rp "Press enter to return..."
				elif [[ -n "$opts" ]]; then
					cmd="ps $opts"
					log "$USER listed processes using '$cmd'"
					echo ""
					echo ""
					echo "[$USER@$HOST]$ $cmd"
					ps "$opts" | tee -a "$LOG_FILE"
					sleep 1
					echo ""
					echo ""
					read -rp "Press enter to return..."
				else
					cmd="ps"
					log "$USER listed processes using '$cmd'"
					echo ""
					echo ""
					echo "[$USER@$HOST]$ $cmd"
					$cmd | tee -a "$LOG_FILE"
					sleep 1
					echo ""
					echo ""
					read -rp "Press enter to return..."
				fi
				;;
			"Monitor Processes (htop)")
				cmd="htop"
				log "$USER monitored processes using '$cmd'"
				echo ""
				echo ""
				echo "[$USER@$HOST]$ $cmd"
				$cmd | tee -a "$LOG_FILE"
				sleep 1
				echo ""
				echo ""
				;;
			"Monitor Processes (top)")
				cmd="top"
				log "$USER monitored processes using '$cmd'"
				echo ""
				echo ""
				echo "[$USER@$HOST]$ $cmd"
				$cmd | tee -a "$LOG_FILE"
				sleep 1
				echo ""
				echo ""
				;;
			"Show Free Memory")
				cmd="free -h"
				log "$USER viewed free memory using '$cmd'"
				echo ""
				echo ""
				echo "[$USER@$HOST]$ $cmd"
				$cmd | tee -a "$LOG_FILE"
				sleep 1
				echo ""
				echo ""
				read -rp "Press enter to return..."
				;;
			"Show Last Boot Time")
				cmd="who -b"
				log "$USER viewed last boot time using '$cmd'"
				echo ""
				echo ""
				echo "[$USER@$HOST]$ $cmd"
				$cmd | tee -a "$LOG_FILE"
				sleep 1
				echo ""
				echo ""
				read -rp "Press enter to return..."
				;;
			"Show Virtual Memory Stats")
				cmd="vmstat"
				log "$USER viewed virtual memory stats using '$cmd'"
				echo ""
				echo ""
				echo "[$USER@$HOST]$ $cmd"
				$cmd | tee -a "$LOG_FILE"
				sleep 1
				echo ""
				echo ""
				read -rp "Press enter to return..."
				;;
			"View Memory Info")
				cmd="less /proc/meminfo"
				log "$USER viewed memory info using '$cmd'"
				echo ""
				echo ""
				echo "[$USER@$HOST]$ $cmd"
				$cmd | tee -a "$LOG_FILE"
				sleep 1
				echo ""
				echo ""
				read -rp "Press enter to return..."
				;;
			"Back")
				echo "Returning to main menu..."
				echo ""
				echo ""
				break
				;;
			*)
				echo "Invalid selection."
				sleep 2
				;;
		esac
	done
}

# Service Statuses Submenu
srv_stat() {
	while true; do
		choice=$(echo -e "Back\nView Logs\nManage Service\nList Services\nList Processes" | fzf)
        
		if [[ -z "$choice" ]]; then
			echo "No selection made. Returning to main menu..."
			sleep 2
			break
		fi

		case "$choice" in
			"List Processes")
				read -p "Enter process filter (e.g., 'aux' or press Enter for default 'ps'): " opts
				read -p "Enter user to filter (or press Enter for none): " user
				if [[ -n "$user" ]]; then
					cmd="ps $opts | grep $user"
					log "$USER listed processes for user using '$cmd'"
					echo ""
					echo ""
					echo "[$USER@$HOST]$ $cmd"
					ps "$opts" | grep "$user" | tee -a "$LOG_FILE"
					sleep 1
					echo ""
					echo ""
					read -rp "Press enter to return..."
				elif [[ -n "$opts" ]]; then
					cmd="ps $opts"
					log "$USER listed processes using '$cmd'"
					echo ""
					echo ""
					echo "[$USER@$HOST]$ $cmd"
					ps "$opts" | tee -a "$LOG_FILE"
					sleep 1
					echo ""
					echo ""
					read -rp "Press enter to return..."
				else
					cmd="ps"
					log "$USER listed processes using '$cmd'"
					echo ""
					echo ""
					echo "[$USER@$HOST]$ $cmd"
					$cmd | tee -a "$LOG_FILE"
					sleep 1
					echo ""
					echo ""
					read -rp "Press enter to return..."
				fi
				;;
			"List Services")
				cmd="systemctl list-units --type=service"
				log "$USER listed services using '$cmd'"
				echo ""
				echo ""
				echo "[$USER@$HOST]$ $cmd"
				$cmd | tee -a "$LOG_FILE"
				sleep 1
				echo ""
				echo ""
				read -rp "Press enter to return..."
				;;
			"Manage Service")
				read -p "Enter service name: " service
				read -p "Enter action (start/stop/restart/status): " action
				if [[ -n "$service" && -n "$action" ]]; then
					cmd="service $service $action"
					log "$USER managed service using '$cmd'"
					echo ""
					echo ""
					echo "[$USER@$HOST]$ $cmd"
					sudo $cmd | tee -a "$LOG_FILE"
					sleep 1
					echo ""
					echo ""
					read -rp "Press enter to return..."
				else
					echo "Invalid service name or action."
					sleep 2
				fi
				;;
			"View Logs")
				cmd="journalctl"
				log "$USER viewed system logs using '$cmd'"
				echo ""
				echo ""
				echo "[$USER@$HOST]$ $cmd"
				$cmd | tee -a "$LOG_FILE"
				sleep 1
				echo ""
				echo ""
				read -rp "Press enter to return..."
				;;
			"Back")
				echo "Returning to main menu..."
				echo ""
				echo ""
				break
				;;
			*)
				echo "Invalid selection."
				sleep 2
				;;
		esac
	done
}

# System Information Submenu
sys_info() {
	while true; do
		choice=$(echo -e "Back\nShow Uptime (pretty)\nShow System Uptime (since)\nShow System Uptime\nShow Memory Info\nShow Kernel Info\nShow CPU Info" | fzf)
        
		if [[ -z "$choice" ]]; then
			echo "No selection made. Returning to main menu..."
			sleep 2
			break
		fi

		case "$choice" in
			"Show CPU Info")
				cmd="lscpu"
				log "$USER viewed CPU info using '$cmd'"
				echo ""
				echo ""
				echo "[$USER@$HOST]$ $cmd"
				$cmd | tee -a "$LOG_FILE"
				sleep 1
				echo ""
				echo ""
				read -rp "Press enter to return..."
				;;
			"Show Kernel Info")
				cmd="uname -a"
				log "$USER viewed kernel info using '$cmd'"
				echo ""
				echo ""
				echo "[$USER@$HOST]$ $cmd"
				$cmd | tee -a "$LOG_FILE"
				sleep 1
				echo ""
				echo ""
				read -rp "Press enter to return..."
				;;
			"Show Memory Info")
				cmd="lsmem"
				log "$USER viewed memory info using '$cmd'"
				echo ""
				echo ""
				echo "[$USER@$HOST]$ $cmd"
				$cmd | tee -a "$LOG_FILE"
				sleep 1
				echo ""
				echo ""
				read -rp "Press enter to return..."
				;;
			"Show System Uptime")
				cmd="uptime"
				log "$USER viewed uptime using '$cmd'"
				echo ""
				echo ""
				echo "[$USER@$HOST]$ $cmd"
				$cmd | tee -a "$LOG_FILE"
				sleep 1
				echo ""
				echo ""
				read -rp "Press enter to return..."
				;;
			"Show System Uptime (since)")
				cmd="uptime -s"
				log "$USER viewed uptime (since) using '$cmd'"
				echo ""
				echo ""
				echo "[$USER@$HOST]$ $cmd"
				$cmd | tee -a "$LOG_FILE"
				sleep 1
				echo ""
				echo ""
				read -rp "Press enter to return..."
				;;
			"Show Uptime (pretty)")
			cmd="uptime -p"
			log "$USER viewed uptime (pretty) using '$cmd'"
			echo ""
			echo ""
			echo "[$USER@$HOST]$ $cmd"
			$cmd | tee -a "$LOG_FILE"
			sleep 1
			echo ""
			echo ""
			read -rp "Press enter to return..."
			;;
		"Back")
			echo "Returning to main menu..."
			echo ""
			echo ""
			break
			;;
		*)
			echo "Invalid selection."
			sleep 2
			;;
	esac
done
}

show_exit() {
	cat << "EOF"
▓█████ ▒██   ██▒ ██▓▄▄▄█████▓ ██▓ ███▄    █   ▄████
▓█   ▀ ▒▒ █ █ ▒░▓██▒▓  ██▒ ▓▒▓██▒ ██ ▀█   █  ██▒ ▀█▒
▒███   ░░  █   ░▒██▒▒ ▓██░ ▒░▒██▒▓██  ▀█ ██▒▒██░▄▄▄░
▒▓█  ▄  ░ █ █ ▒ ░██░░ ▓██▓ ░ ░██░▓██▒  ▐▌██▒░▓█  ██▓
░▒████▒▒██▒ ▒██▒░██░  ▒██▒ ░ ░██░▒██░   ▓██░░▒▓███▀▒
░░ ▒░ ░▒▒ ░ ░▓ ░░▓    ▒ ░░   ░▓  ░ ▒░   ▒ ▒  ░▒   ▒
 ░ ░  ░░░   ░▒ ░ ▒ ░    ░     ▒ ░░ ░░   ░ ▒░  ░   ░
   ░    ░    ░   ▒ ░  ░       ▒ ░   ░   ░ ░ ░ ░   ░
   ░  ░ ░    ░   ░            ░           ░       ░
EOF
}
