#!/usr/bin/env bash
# The Abyss Sysadmin Vault
# Copyright (c) 2025 LordSodomiser
# Licensed under the Mozilla Public License 2.0 or commercial license.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

set -Eeuo pipefail

ENV_FILE="/opt/The-Abyss/abyss-vault/.configs/.env"
if [[ -f "$ENV_FILE" ]]; then
    source "$ENV_FILE"
else
	echo "Error: .env file not found at $ENV_FILE, the vault environment may not be initialized. Please run install.sh first."
	exit 1
fi

if [[ -f "$FUNC_FILE" ]]; then
	source "$FUNC_FILE"
else
	echo "Error: functions.sh not found at $FUNC_FILE"
	exit 1
fi

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
	handling "$0"
	exit 0
fi

if [[ $EUID -ne 0 ]]; then
	echo "Root privileges required to run this installation."
	read -rp "Do you want to run with sudo now? [Y/n]: " ans
	ans=${ans:-Y}
	if [[ "$ans" =~ ^([yY]|[Yy][Ee][Ss])$ ]]; then
		sudo -v || { echo "Failed to get sudo."; exit 1; }
		exec sudo "$0" "$@"
	else
		exit 1
	fi
fi

handling "$@"

setup_traps

show_banner

sleep 3

check_dependencies

while true; do
	choice=$(echo -e "Exit\nVault Management\nUtilities\nSecure Deletion\nNetwork & OpSec\nKey Management\nFilesystem Tools\nBackup & Archive\nAdvanced Security" | fzf --prompt="Main Menu > ")

	if [[ -z "$choice" ]]; then
		echo "No selection made. Possibly Cancelled..."
		sleep 2
		continue
	fi

	case "$choice" in
		"Advanced Security") advsec_menu ;;
		"Backup & Archive") backup_menu ;;
		"Filesystem Tools") fs_menu ;;
		"Key Management") key_menu ;;
		"Network & OpSec") net_menu ;;
		"Secure Deletion") wipe_menu ;;
		"Utilities") util_menu ;;
		"Vault Management") vault_menu ;;
		"Exit")
			log "$ABYSS_USER exited The Abyss Sysadmin Vault"
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
