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

if [[ $EUID -ne 0 ]]; then
	echo "Root privileges are required to run this script."
	read -rp "Do you want to run it with sudo now? [y/N]: " answer
	if [[ "$answer" =~ ^[Yy]$ ]]; then
		exec sudo "$0" "$@"
	else
		echo "Exiting..."
		exit 1
	fi
fi

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
ENV_FILE="$SCRIPT_DIR/.configs/.env"
if [[ -f "$ENV_FILE" ]]; then
    source "$ENV_FILE"
else
	echo "Error: .env file not found at $ENV_FILE, the toolbox environment may not be initialized. Please run initialize.sh first."
	exit 1
fi

source "$FUNC_FILE"

setup_traps

show_banner

sleep 3

log "$USER started the toolbox"

while true; do
	choice=$(echo -e "Exit\nSystem Monitoring\nSystem Information\nService Statuses\nSecurity Management\nNetwork Diagnostics\nNetwork Configuration\nLog Viewing\nFile System Checks\nFile Management\nDisk Management" | fzf)

	if [[ -z "$choice" ]]; then
		echo "No selection made. Possibly Cancelled..."
		sleep 2
		continue
	fi

	case "$choice" in
		"Disk Management") disk_mgmt ;;
		"File Management") file_mgmt ;;
		"File System Checks") file_sys_chks ;;
		"Log Viewing") log_viewing ;;
		"Network Configuration") net_config ;;
		"Network Diagnostics") net_diag ;;
		"Security Management") sec_mgmt ;;
		"Service Statuses") srv_stat ;;
		"System Information") sys_info ;;
		"System Monitoring") sys_mon ;;
		"Exit")
			log "$USER exited The Abyss Sysadmin Toolbox"
			echo ""
			echo ""
			show_exit
			echo ""
			echo""
			echo "Goodbye!"
			sleep 2
			break
			;;
		*) echo "Invalid selection." ;;
	esac
done
