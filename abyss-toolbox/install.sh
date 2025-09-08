#!/usr/bin/env bash
# The Abyss Sysadmin Toolbox
# Copyright (c) 2025 LordSodomiser
# Licensed under the Mozilla Public License 2.0 or a commercial license.
# See LICENSE file or https://github.com/LordSodomiser/The-Abyss/blob/main/LICENSE for details
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

set -Eeuo pipefail
trap 'echo "Error: Script failed at line $LINENO"; exit 1' ERR

log() {
	local msg="$*"
	echo "$(date '+%Y-%m-%d %H:%M:%S') - $msg" >> "${LOG_FILE:-/var/log/The-Abyss/.logs/toolbox.log}"
}

if [[ $EUID -ne 0 ]]; then
	echo "Root privileges are required to run this script."
	read -rp "Do you want to run it with sudo now? [Y/n]: " ans
	ans=${ans:-Y}

	if [[ "$ans" =~ ^([yY]|[Yy][Ee][Ss])$ ]]; then
		if ! exec sudo "$0" "$@"; then
			echo "Error: Failed to run script with sudo. Check sudo permissions..."
			exit 1
		fi
	else
		echo "Exiting..."
		exit 1
	fi
fi

pkg_mgr_found=""
for pkg_mgr in apk apt conda dnf emerge nix-env pacman pkg pkgin pkg_add slackpkg spack yum zypper; do
	if command -v "$pkg_mgr" &>/dev/null; then
		echo "Detected $pkg_mgr package manager..."
		pkg_mgr_found="$pkg_mgr"
		break
	fi
done

if [[ -z "$pkg_mgr_found" ]]; then
	echo "Error: Unkown package manager."
	exit 1
fi

SCR_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
ENV_FILE="$TOOLBOX_DIR/.configs/.env"
DEST_DIR="/opt/The-Abyss"
TOOLBOX_DIR="$DEST_DIR/abyss-toolbox"
LOG_DIR="/var/log/The-Abyss/.logs"
LOG_FILE="$LOG_DIR/toolbox.log"
LAUNCHER="/usr/local/bin/cystoolbox"
SOURCE_SCRIPT="$TOOLBOX_DIR/toolbox.sh"
FUNC_FILE="$TOOLBOX_DIR/functions.sh"

echo "[*] Installing The Abyss Sysadmin Toolbox..."

echo "Creating $LOG_DIR..."
mkdir -p "$LOG_DIR"
touch "$LOG_FILE"
chmod 644 "$LOG_FILE"
chown root:root "$LOG_FILE"
log "Starting installation from $SRC_DIR"

echo "Ensuring .configs directory exists..."
mkdir -p "$(dirname "$ENV_FILE")"
chmod 755 "$(dirname "$ENV_FILE")" 

echo "Creating or updating .env file..."
cat << EOF > "$ENV_FILE"
ABYSS_INITIALIZED=true
ABYSS_VERSION=0.2.1
ABYSS_FZF_THEME=dracula
ABYSS_PROMPT_ON_LAUNCH=false
REPO_URL="https://github.com/LordSodomiser/The-Abyss.git"
EOF
chmod 644 "$ENV_FILE"
chown root:root "$ENV_FILE"
log "Created or updated .env file at $ENV_FILE"

update_or_append() {
	local key="$1" value="$2"
	if grep -q "^$key=" "$ENV_FILE"; then
		escaped_value=$(printf '%s\n' "$value" | sed -e 's/[\/&]/\\&/g')
		sed -i "s/^$key=.*/$key=$escaped_value/" "$ENV_FILE"
	else
		echo "$key=$value" >> "$ENV_FILE"
	fi
}

update_or_append "ABYSS_USER" "\"\${SUDO_USER:-\$USER}\""
update_or_append "ABYSS_OS" "\"\$(if [[ -f /etc/os-release ]]; then grep '^PRETTY_NAME=' /etc/os-release | cut -d= -f2 | tr -d '\"'; else echo 'Unknown'; fi)\""
update_or_append "ABYSS_INSTALL_DATE" "\"\$(date '+%Y-%m-%d %H:%M:%S')\""
update_or_append "LOG_INSTALED_PKGS" "\"$TOOLBOX_DIR/installed-pkgs.txt\""
update_or_append "TOOLBOX_PATH" "\"$TOOLBOX_DIR\""
update_or_append "LAUNCHER" "\"$LAUNCHER\""
update_or_append "SOURCE_SCRIPT" "\"$SOURCE_SCRIPT\""
update_or_append "FUNC_FILE" "\"$FUNC_FILE\""
update_or_append "LOG_DIR" "\"$LOG_DIR\""
update_or_append "LOG_FILE" "\"$LOG_FILE\""
update_or_append "ENV_FILE" "\"$ENV_FILE\""
update_or_append "HOST" "\"$(hostname)\""
update_or_append "PKG_MGR" "\"$pkg_mgr_found\""

source "$ENV_FILE"

for file in toolbox.sh functions.sh; do
	if [[ ! -f "$SRC_DIR/$file" ]]; then
		echo "Error: $file not found."
		log "Missing file: $file"
		exit 1
	fi
done

if [[ -f "$LAUNCHER" ]]; then
	echo "Already installed at $Launcher. Skipping copy."
else
	if [[ ! -d "$DEST_DIR" ]]; then
		mkdir -p "$DEST_DIR"
	fi
	
	if [[ -d "$DEST_DIR/.git" ]]; then
		echo "[*] Marking $DEST_DIR as safe for Git operations..."
		git config --global --add safe.directory "$DEST_DIR" || echo "Warning: Failed to mark $DEST_DIR as safe directory..."
		echo "[*] Repo already exists, pulling latest..."
		cd "$DEST_DIR"
		git pull
	else
		echo "[*] Marking $DEST_DIR as safe for Git operations..."
		git config --global --add safe.directory "$DEST_DIR" || echo "Warning: Failed to mark $DEST_DIR as safe directory..."
		echo "[*] Cloning repository..."
		git clone "$REPO_URL" "$DEST_DIR"
	fi

	echo "[*] Installing launcher script to $LAUNCHER"
	
	cp -r "$SRC_DIR/toolbox.sh" "$SRC_DIR/functions.sh" "$SRC_DIR/.configs" "$TOOLBOX_DIR/"

	find "$TOOLBOX_DIR" -type d -exec chmod 755 {} +
	find "$TOOLBOX_DIR" -type f -exec chmod 644 {} +

	cat << 'EOF' > "$LAUNCHER"
#!/usr/bin/env bash

set -Eeuo pipefail
ENV_FILE="/opt/The-Abyss/abyss-toolbox/.configs/.env"

if [[ -f "$ENV_FILE" ]]; then
	source "$ENV_FILE"
else
	echo "Error: .env not found at $ENV_FILE" >&2
	exit 1
fi

: "${TOOLBOX_PATH:=/opt/The-Abyss/abyss-toolbox}"
: "${SOURCE_SCRIPT:=/opt/The-Abyss/abyss-toolbox/toolbox.sh}"

if [[ ! -x "$SOURCE_SCRIPT" ]]; then
	echo "Error: toolbox.sh not found or not executable at $SOURCE_SCRIPT" >&2
	exit 1
fi

exec "$SOURCE_SCRIPT" "$@"
EOF

# Initialization

echo "Beginning initiation..."
sleep 1

pkg_log() {
	installed_pkgs+=("$1")
}

prompt_confirm() {
	read -rp "Install required packages for missing tools? [Y/n] " response
	case "$response" in
		[nN][oO]|[nN])
			echo "Installation aborted by user."
			exit 1
			;;
		*)
			return 0
			;;
	esac
}

		case "$pkg_mgr_found" in
			apk)
				required_tools=(awk cat cd clamscan cifs cp cfdisk df du find free fzf git grep hostname htop ifconfig ip less ls lsblk mount mv netstat nmtui nslookup parted ping ps rkhunter rm smartctl smbclient service shred sudo top ufw umount uname uptime vmstat which who)
				pkg_install="sudo apk add"
				;;
			apt)
				required_tools=(awk cat cd clamscan cifs cp cfdisk df du find free fzf git grep hostname htop ifconfig ip journalctl less ls lsblk lscpu lsmem mount mv netstat nmtui nslookup parted ping ps rkhunter rm smartctl smbclient service shred sudo systemctl top ufw umount uname uptime vmstat which who)
				pkg_install="sudo apt install -y"
				;;
			conda)
				required_tools=(awk cat cd cp df du find free fzf git grep hostname less ls mv netstat ping ps rm shred smartctl top uname uptime vmstat which who)
				pkg_install="conda install -c conda-forge"
				;;
			dnf)
				required_tools=(awk cat cd clamscan cifs cp cfdisk df du find free fzf git grep hostname htop ifconfig ip journalctl less ls lsblk lscpu lsmem mount mv netstat nmtui nslookup parted ping ps rkhunter rm smbclient service shred smartctl sudo systemctl top ufw umount uname uptime vmstat which who)
				pkg_install="sudo $pkg_mgr install -y"
				;;
			emerge)
				required_tools=(awk cat cd clamscan cifs cp cfdisk df du find free fzf git grep hostname htop ifconfig ip journalctl less ls lsblk lscpu lsmem mount mv netstat nmtui nslookup parted ping ps rkhunter rm smbclient service shred smartctl sudo systemctl top ufw umount uname uptime vmstat which who)
				pkg_install="sudo emerge --ask n"
				;;
			nix-env)
				required_tools=(awk cat cd cifs cp df du find free fzf git grep hostname less ls mount mv nslookup parted ping ps smartctl shred smbclient top umount uname uptime vmstat which who)
				pkg_install="nix-env -iA"
				;;
			pacman)
				required_tools=(awk cat cd clamscan cifs cp cfdisk df du find free fzf git grep hostname htop ifconfig ip journalctl less ls lsblk lscpu lsmem mount mv netstat nmtui nslookup parted ping ps rkhunter rm shred smartctl smbclient sudo systemctl top ufw umount uname uptime vmstat which who)
				pkg_install="sudo pacman -S --noconfirm"
				;;
			pkg)
				required_tools=(awk cat cd clamscan cp cfdisk df du find free fzf git grep hostname htop ifconfig ip less ls lsblk lscpu lsmem mount_smbfs mv netstat nmtui nslookup parted ping ps rkhunter rm shred smartctl smbclient sudo top ufw uname uptime vmstat which who)
				pkg_install="sudo pkg install"
				;;
			pkg_add)
				required_tools=(awk cat cd cp clamscan cfdisk df du find free fzf git grep hostname htop ifconfig ip less ls lsblk lscpu lsmem mount_smbfs mv netstat nmtui nslookup parted ping ps rcctl rkhunter rm smartctl smbclient sudo top ufw uname uptime vmstat which who)
				pkg_install="sudo pkg_add"
				;;
			pkgin)
				required_tools=(awk cat cd clamscan cp cfdisk df du find free fzf git grep hostname htop ifconfig ip less ls lsblk lscpu lsmem mount_smbfs mv netstat nmtui nslookup parted ping ps rkhunter rm smbclient shred smartctl sudo top ufw uname uptime vmstat which who)
				pkg_install="sudo pkgin install"
				;;
			slackpkg)
				required_tools=(awk cat cd cp clamscan cfdisk df du find free fzf git grep hostname htop ifconfig ip less lsblk lscpu lsmem mount mv netstat nmtui nslookup parted ping ps rkhunter rm smbclient service shred smartctl sudo top ufw umount uname uptime vmstat which who)
				pkg_install="sudo slackpkg install -batch=on"
				;;
			spack)
				required_tools=(awk cat cd cp df du find free fzf git grep hostname less ls mount mv netstat nslookup parted ping ps rm shred top umount uname uptime vmstat which who)
				pkg_install="spack install"
				;;
			yum)
				required_tools=(awk cat cd clamscan cifs cp cfdisk df du find free fzf git grep hostname htop ifconfig ip journalctl less ls lsblk lscpu lsmem mount mv netstat nmtui nslookup parted ping ps rkhunter rm smbclient service shred smartctl sudo systemctl top ufw umount uname uptime vmstat which who)
				pkg_install="sudo yum install -y"
				;;
			zypper)
				required_tools=(awk cat cd clamscan cifs cp cfdisk df du find free fzf git grep hostname htop ifconfig ip journalctl less ls lsblk lscpu lsmem mount mv netstat nmtui nslookup parted ping ps rkhunter rm smbclient service shred smartctl sudo systemctl top ufw umount uname uptime vmstat which who)
				pkg_install="sudo zypper install --non-interactive"
				;;
		esac

		declare -A tool_to_package
		
		case "$pkg_mgr_found" in
			apk)
				tool_to_package=(
					["awk"]="busybox" ["cat"]="busybox" ["cd"]="busybox" ["clamscan"]="clamav" ["cifs"]="cifs-utils"
					["cp"]="busybox" ["cfdisk"]="util-linux" ["df"]="busybox" ["du"]="busybox" ["find"]="findutils"
					["free"]="procps" ["fzf"]="fzf" ["git"]"git" ["grep"]="busybox" ["hostname"]="busybox"
					["htop"]="htop" ["ifconfig"]="net-tools" ["ip"]="iproute2" ["less"]="busybox" ["ls"]="busybox" ["lsblk"]="util-linux"
					["mount"]="util-linux"["mv"]="busybox" ["netstat"]="net-tools" ["nmtui"]="networkmanager" ["nslookup"]="bind-tools"
					["parted"]="parted" ["ping"]="busybox" ["ps"]="procps" ["rkhunter"]="rkhunter" ["rm"]="busybox"
					["service"]="initscripts" ["shred"]="coreutils" ["smartctl"]="smartmontools" ["smbclient"]="samba" ["sudo"]="sudo" ["top"]="procps" ["ufw"]="ufw" ["umount"]="util-linux"
					["uname"]="busybox" ["vmstat"]="procps" ["which"]="busybox" ["who"]="busybox"
				)
				;;
			apt)
				tool_to_package=(
					["awk"]="gawk" ["cat"]="coreutils" ["cd"]="coreutils" ["clamscan"]="clamav" ["cifs"]="cifs-utils"
					["cp"]="coreutils" ["cfdisk"]="util-linux" ["df"]="coreutils" ["du"]="coreutils" ["find"]="findutils"
					["free"]="procps" ["fzf"]="fzf" ["git"]="git" ["grep"]="grep" ["hostname"]="inetutils-tools"
					["htop"]="htop" ["ifconfig"]="net-tools" ["ip"]="iproute2" ["journalctl"]="systemd"
					["less"]="less" ["ls"]="coreutils" ["lsblk"]="util-linux" ["lscpu"]="util-linux" ["lsmem"]="util-linux"
					["mount"]="util-linux" ["mv"]="coreutils" ["netstat"]="net-tools" ["nmtui"]="network-manager" ["nslookup"]="dnsutils"
					["parted"]="parted"
					["ping"]="inetutils" ["ps"]="procps" ["rkhunter"]="rkhunter" ["rm"]="coreutils" ["service"]="initscripts" ["shred"]="coreutils" ["smartctl"]="smartmontools" ["smbclient"]="samba"
					["sudo"]="sudo" ["systemctl"]="systemd" ["top"]="procps" ["ufw"]="ufw" ["umount"]="util-linux"
					["uname"]="coreutils" ["uptime"]="coreutils" ["vmstat"]="procps" ["which"]="coreutils" ["who"]="coreutils"
				)
				;;
			conda)
				tool_to_package=(
					["awk"]="gawk" ["cat"]="coreutils" ["cd"]="coreutils" ["cp"]="coreutils"
					["df"]="coreutils" ["du"]="coreutils" ["find"]="findutils" ["free"]="procps-ng"
					["fzf"]="fzf" ["git"]="git" ["grep"]="grep" ["hostname"]="coreutils" ["less"]="less"
					["ls"]="coreutils" ["mv"]="coreutils" ["netstat"]="net-tools" ["ping"]="inetutils"
					["ps"]="procps-ng" ["rm"]="coreutils" ["shred"]="coreutils" ["smartctl"]="smartmontools" ["top"]="procps-ng" ["uname"]="coreutils"
					["uptime"]="coreutils" ["vmstat"]="procps-ng" ["which"]="coreutils" ["who"]="coreutils"
				)
				;;
			dnf|yum)
				tool_to_package=(
					["awk"]="gawk" ["cat"]="coreutils" ["cd"]="coreutils" ["clamscan"]="clamav" ["cifs"]="cifs-utils"
					["cp"]="coreutils" ["cfdisk"]="util-linux" ["df"]="coreutils" ["du"]="coreutils" ["find"]="findutils"
					["free"]="procps-ng" ["fzf"]="fzf" ["git"]="git" ["grep"]="grep" ["hostname"]="hostname"
					["htop"]="htop" ["ifconfig"]="net-tools" ["ip"]="iproute" ["journalctl"]="systemd"
					["less"]="less" ["ls"]="coreutils" ["lsblk"]="util-linux" ["lscpu"]="util-linux" ["lsmem"]="util-linux" ["mount"]="util-linux"
					["mv"]="coreutils" ["netstat"]="net-tools" ["nmtui"]="NetworkManager-tui" ["nslookup"]="bind-utils" ["parted"]="parted"
					["ping"]="iputils" ["ps"]="procps-ng" ["rkhunter"]="rkhunter" ["rm"]="coreutils" ["service"]="initscripts" ["shred"]="coreutils" ["smartctl"]="smartmontools" ["smbclient"]="samba"
					["sudo"]="sudo" ["systemctl"]="systemd" ["top"]="procps-ng" ["ufw"]="ufw" ["umount"]="util-linux"
					["uname"]="coreutils" ["uptime"]="coreutils" ["vmstat"]="procps-ng" ["which"]="coreutils" ["who"]="coreutils"
				)
				;;
			emerge)
				tool_to_package=(
					["awk"]="sys-apps/gawk" ["cat"]="sys-apps/coreutils" ["cd"]="sys-apps/coreutils" ["clamscan"]="app-antivirus/clamav"
					["cifs"]="net-fs/cifs-utils" ["cp"]="sys-apps/coreutils" ["cfdisk"]="sys-apps/util-linux" ["df"]="sys-apps/coreutils"
					["du"]="sys-apps/coreutils" ["find"]="sys-apps/findutils" ["free"]="sys-process/procps"
					["fzf"]="app-misc/fzf" ["git"]="dev-vcs/git" ["grep"]="sys-apps/grep" ["hostname"]="sys-apps/inetutils"
					["htop"]="sys-process/htop" ["ifconfig"]="sys-apps/net-tools" ["ip"]="sys-apps/iproute2"
					["journalctl"]="sys-apps/systemd" ["less"]="sys-apps/less" ["ls"]="sys-apps/coreutils"
					["lsblk"]="sys-apps/util-linux" ["lscpu"]="sys-apps/util-linux" ["lsmem"]="sys-apps/util-linux" ["parted"]="sys-block/parted"
					["mount"]="sys-apps/util-linux" ["mv"]="sys-apps/coreutils" ["netstat"]="sys-apps/net-tools" ["nmtui"]="net-misc/networkmanager"
					["nslookup"]="net-dns/bind-tools" ["ping"]="sys-apps/inetutils" ["ps"]="sys-process/procps" ["rkhunter"]="app-forensics/rkhunter" ["rm"]="sys-apps/coreutils"
					["service"]="sys-apps/sysvinit" ["shred"]="sys-apps/coreutils" ["smartctl"]="sys-apps/smartmontools"["smbclient"]="net-fs/samba" ["sudo"]="app-admin/sudo" ["systemctl"]="sys-apps/systemd"
					["top"]="sys-process/procps" ["ufw"]="net-misc/ufw" ["umount"]="sys-apps/util-linux" ["uname"]="sys-apps/coreutils" ["uptime"]="sys-apps/coreutils"
					["vmstat"]="sys-process/procps" ["which"]="sys-apps/coreutils" ["who"]="sys-apps/coreutils"
				)
				;;
			nix-env)
				tool_to_package=(
					["awk"]="nixpkgs.gawk" ["cat"]="nixpkgs.coreutils" ["cd"]="nixpkgs.coreutils" ["cifs"]="nixpkgs.cifs-utils"
					["cp"]="nixpkgs.coreutils" ["df"]="nixpkgs.coreutils" ["du"]="nixpkgs.coreutils"
					["find"]="nixpkgs.findutils" ["free"]="nixpkgs.procps" ["fzf"]="nixpkgs.fzf" ["git"]="nixpkgs.git"
					["grep"]="nixpkgs.grep" ["hostname"]="nixpkgs.coreutils" ["less"]="nixpkgs.less" ["ls"]="nixpkgs.coreutils"
					["mount"]="nixpkgs.util-linux" ["mv"]="nixpkgs.coreutils" ["netstat"]="nixpkgs.net-tools" ["nslookup"]="nixpkgs.bind" ["parted"]="nixpkgs.parted"
					["ping"]="nixpkgs.inetutils" ["ps"]="nixpkgs.procps" ["rm"]="nixpkgs.coreutils" ["shred"]="nixpkgs.coreutils" ["smartctl"]="nixpkgs.smartmontools" ["smbclient"]="nixpkgs.samba"
					["top"]="nixpkgs.procps" ["umount"]="nixpkgs.util-linux" ["uname"]="nixpkgs.coreutils" ["uptime"]="nixpkgs.coreutils"
					["vmstat"]="nixpkgs.procps" ["which"]="nixpkgs.coreutils" ["who"]="nixpkgs.coreutils"
				)
				;;
			pacman)
				tool_to_package=(
					["awk"]="gawk" ["cat"]="coreutils" ["cd"]="coreutils" ["clamscan"]="clamav" ["cifs"]="cifs-utils"
					["cp"]="coreutils" ["cfdisk"]="util-linux" ["df"]="coreutils" ["du"]="coreutils" ["find"]="findutils"
					["free"]="procps-ng" ["fzf"]="fzf" ["git"]="git" ["grep"]="grep" ["hostname"]="inetutils"
					["htop"]="htop" ["ifconfig"]="net-tools" ["ip"]="iproute2" ["journalctl"]="systemd"
					["less"]="less" ["ls"]="coreutils" ["lsblk"]="util-linux" ["lscpu"]="util-linux" ["lsmem"]="util-linux" ["mount"]="util-linux" ["mv"]="coreutils"
					["netstat"]="net-tools" ["nmtui"]="networkmanager" ["nslookup"]="bind" ["parted"]="parted"
					["ping"]="inetutils" ["ps"]="procps-ng" ["rkhunter"]="rkhunter" ["rm"]="coreutils" ["shred"]="coreutils" ["smartctl"]="smartmontools" ["smbclient"]="samba" ["sudo"]="sudo" ["systemctl"]="systemd"
					["top"]="procps-ng" ["ufw"]="ufw" ["umount"]="util-linux" ["uname"]="coreutils" ["uptime"]="coreutils" ["vmstat"]="procps-ng"
					["which"]="coreutils" ["who"]="coreutils"
				)
				;;
			pkg)
				tool_to_package=(
					["awk"]="gawk" ["cat"]="coreutils" ["cd"]="coreutils" ["clamscan"]="clamav" ["cp"]="coreutils"
					["cfdisk"]="sysutils/cfdisk" ["df"]="coreutils" ["du"]="coreutils" ["find"]="coreutils"
					["free"]="procps" ["fzf"]="fzf" ["git"]="git" ["grep"]="grep" ["hostname"]="coreutils"
					["htop"]="sysutils/htop" ["ifconfig"]="net-tools" ["ip"]="iproute2" ["less"]="less"
					["ls"]="coreutils" ["lsblk"]="util-linux" ["lscpu"]="util-linux" ["lsmem"]="util-linux" ["mv"]="coreutils"
					["netstat"]="net/libnet" ["nmtui"]="net/networkmanager" ["nslookup"]="bind-tools" ["parted"]="parted" ["ping"]="net/inetutils"
					["ps"]="procps" ["rkhunter"]="rkhunter" ["rm"]="coreutils" ["shred"]="sysutils/coreutils" ["smartctl"]="smartmontools" ["smbclient"]="samba413" ["sudo"]="sudo" ["top"]="procps"
					["ufw"]="net/ufw" ["uname"]="coreutils" ["uptime"]="coreutils" ["vmstat"]="procps"
					["which"]="coreutils" ["who"]="coreutils"
				)
				;;
			pkg_add)
				tool_to_package=(
					["awk"]="gawk" ["cat"]="coreutils" ["cd"]="coreutils" ["clamscan"]="clamav" ["cp"]="coreutils"
					["cfdisk"]="sysutils/cfdisk" ["df"]="coreutils" ["du"]="coreutils" ["find"]="coreutils"
					["free"]="procps" ["fzf"]="fzf" ["git"]="git" ["grep"]="grep" ["hostname"]="coreutils"
					["htop"]="sysutils/htop" ["ifconfig"]="net-tools" ["ip"]="iproute2" ["less"]="less"
					["ls"]="coreutils" ["lsblk"]="util-linux" ["lscpu"]="util-linux" ["lsmem"]="util-linux" ["mv"]="coreutils"
					["netstat"]="net/libnet" ["nmtui"]="net/networkmanager" ["nslookup"]="bind" ["parted"]="parted" ["ping"]="net/inetutils"
					["ps"]="procps" ["rcctl"]="openbsd-base" ["rkhunter"]="rkhunter" ["rm"]="coreutils" ["smartctl"]="smartmontools" ["smbclient"]="samba" ["sudo"]="sudo"
					["top"]="procps" ["ufw"]="net/ufw" ["uname"]="coreutils" ["uptime"]="coreutils"
					["vmstat"]="procps" ["which"]="coreutils" ["who"]="coreutils"
				)
				;;
			pkgin)
				tool_to_package=(
					["awk"]="gawk" ["cat"]="coreutils" ["cd"]="coreutils" ["clamscan"]="clamav" ["cp"]="coreutils"
					["cfdisk"]="sysutils/cfdisk" ["df"]="coreutils" ["du"]="coreutils" ["find"]="coreutils"
					["free"]="procps" ["fzf"]="fzf" ["git"]="git" ["grep"]="grep" ["hostname"]="coreutils"
					["htop"]="sysutils/htop" ["ifconfig"]="net-tools" ["ip"]="iproute2" ["less"]="less"
					["ls"]="coreutils" ["lsblk"]="util-linux" ["lscpu"]="util-linux" ["lsmem"]="util-linux" ["mv"]="coreutils"
					["netstat"]="net/libnet" ["nmtui"]="net/networkmanager" ["nsloookup"]="bind" ["parted"]="parted" ["ping"]="net/inetutils"
					["ps"]="procps" ["rkhunter"]="rkhunter" ["rm"]="coreutils" ["shred"]="sysutils/coreutils" ["smartctl"]="smartmontools" ["smbclient"]="samba" ["sudo"]="sudo" ["top"]="procps"
					["ufw"]="net/ufw" ["uname"]="coreutils" ["uptime"]="coreutils"
					["vmstat"]="procps" ["which"]="coreutils" ["who"]="coreutils"
				)
				;;
			slackpkg)
				tool_to_package=(
					["awk"]="gawk" ["cat"]="coreutils" ["cd"]="coreutils" ["clamscan"]="clamav" ["cp"]="coreutils"
					["cfdisk"]="util-linux" ["df"]="coreutils" ["du"]="coreutils" ["find"]="findutils"
					["free"]="procps" ["fzf"]="fzf" ["git"]="git" ["grep"]="grep" ["hostname"]="net-tools"
					["htop"]="htop" ["ifconfig"]="net-tools" ["ip"]="iproute2" ["less"]="less"
					["ls"]="coreutils" ["lsblk"]="util-linux" ["lscpu"]="util-linux" ["lsmem"]="util-linux" ["mount"]="util-linux"
					["mv"]="coreutils" ["netstat"]="net-tools" ["nmtui"]="networkmanager" ["nslookup"]="bind" ["parted"]="parted" ["ping"]="net-tools"
					["ps"]="procps" ["rkhunter"]="rkhunter" ["rm"]="coreutils" ["service"]="initscripts" ["shred"]="coreutils" ["smartctl"]="smartmontools" ["smbclient"]="samba" ["sudo"]="sudo"
					["top"]="procps" ["ufw"]="ufw" ["umount"]="util-linux" ["uname"]="coreutils" ["uptime"]="coreutils"
					["vmstat"]="procps" ["which"]="coreutils" ["who"]="coreutils"
				)
				;;
			spack)
				tool_to_package=(
					["awk"]="gawk" ["cat"]="coreutils" ["cd"]="coreutils" ["cp"]="coreutils"
					["df"]="coreutils" ["du"]="coreutils" ["find"]="procps" ["free"]="procps-ng"
					["fzf"]="fzf" ["git"]="git" ["grep"]="grep" ["hostname"]="coreutils" ["less"]="less" ["ls"]="coreutils"
					["mv"]="coreutils" ["netstat"]="net-tools" ["nslookup"]="bind9" ["parted"]="parted" ["ping"]="inetutils" ["ps"]="procps-ng"
					["rm"]="coreutils" ["shred"]="coreutils" ["top"]="procps-ng" ["uname"]="coreutils" ["uptime"]="coreutils"
					["vmstat"]="procps-ng" ["which"]="coreutils" ["who"]="coreutils"
				)
				;;
			zypper)
				tool_to_package=(
					["awk"]="gawk" ["cat"]="coreutils" ["cd"]="coreutils" ["clamscan"]="clamav" ["cifs"]="cifs-utils"
					["cp"]="coreutils" ["cfdisk"]="util-linux" ["df"]="coreutils" ["du"]="coreutils" ["find"]="findutils"
					["free"]="procps" ["fzf"]="fzf" ["git"]="git" ["grep"]="grep" ["hostname"]="hostname"
					["htop"]="htop" ["ifconfig"]="net-tools" ["ip"]="iproute2" ["journalctl"]="systemd"
					["less"]="less" ["ls"]="coreutils" ["lsblk"]="util-linux" ["lscpu"]="util-linux"
					["lsmem"]="util-linux" ["mount"]="util-linux" ["mv"]="coreutils" ["netstat"]="net-tools" ["nmtui"]="network-manager"
					["nslookup"]="bind-utils" ["parted"]="parted" ["ping"]="iputils" ["ps"]="procps" ["rkhunter"]="rkhunter" ["rm"]="coreutils" ["service"]="initscripts"
					["shred"]="coreutils" ["smartctl"]="smartmontools" ["smbclient"]="samba" ["sudo"]="sudo" ["systemctl"]="systemd" ["top"]="procps" ["ufw"]="ufw" ["umount"]="util-linux"
					["uname"]="coreutils" ["vmstat"]="procps" ["which"]="coreutils" ["who"]="coreutils"
				)
				;;
		esac

		missing_tools=()
		missing_packages=()

		for tool in "${required_tools[@]}"; do
			if [[ "$tool" == "cifs" ]]; then
				if mount --help | grep -q "cifs" || modinfo cifs >/dev/null 2>&1; then
					echo "CIFS support is installed"
				else
					echo "CIFS support is not installed"
					missing_tools+=("$tool")
					missing_packages+=("${tool_to_package[$tool]}")
				fi
			elif [[ "$tool" == "mount_smbfs" ]]; then
				if command -v mount_smbfs &>/dev/null || kldstat | grep -q smbfs; then
					echo "mount_smbfs support is installed"
				else
					echo "mount_smbfs support is not installed"
					missing_tools+=("$tool")
					missing_packages+=("${tool_to_package[$tool]}")
				fi
			elif [[ "$tool" != "rcctl" || "$pkg_mgr" == "pkg_add" ]]; then
				if ! command -v "$tool" &>/dev/null; then
					missing_tools+=("$tool")
					missing_packages+=("${tool_to_package[$tool]}")
				fi
			fi
		done

		if [ ${#missing_tools[@]} -eq 0 ]; then
			echo "All required tools are already installed..."
			read -rp "Cleanup installation? [Y/n] " ans
			ans=${ans:-Y}

			if [[ "$ans" =~ ^[yY]$ ]]; then
				echo "Shredding and removing: $SRC_DIR"

				cd "$SRC_DIR" || exit 1
				find . -type f -exec shred -v -n 1 -u {} \;

				cd "$(mktemp -d)" || exit 1
				rm -rf "$SRC_DIR"
				
				echo "Cleanup complete..."
			else
				echo "Skipping cleanup..."
			fi

			echo
			echo
			echo "Run with: cystoolbox"
			exit 0
		fi

		declare -a installed_pkgs=()

		echo "Missing tools: ${missing_tools[*]}"
		prompt_confirm

		unique_packages=($(echo "${missing_packages[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))

		case "$pkg_mgr_found" in
			apk)
				sudo apk update
				;;
			apt)
				sudo apt update
				;;
			slackpkg)
				sudo slackpkg update
				;;
			dnf|yum)
				sudo $pkg_mgr_found makecache
				;;
			zypper)
				sudo zypper refresh
				;;
		esac

		if [ ${#unique_packages[@]} -gt 0 ]; then
			echo "Installing packages: ${unique_packages[*]}..."
			if $pkg_install "${unique_packages[@]}"; then
				for pkg in "${unique_packages[@]}"; do
					pkg_log
				done
				: >"$LOG_INSTALLED_PKGS"
				echo "${unique_packages[*]}" >> "$LOG_INSTALLED_PKGS"
			else
				echo "Warning: Failed to install some or all packages: ${unique_packages[*]}"
				log "Failed to install some or all packages: ${unique_packages[*]}"
			fi
		else
			echo "No packages to install."
		fi

		echo
		echo
		echo "All required packages have been installed..."
		echo
		echo

USER_HOME=$(getent passwd "ABYSS_USER" | cut -d: -f6)
SHELL_CONFIG=""
if [[ -n "${ZSH_VERSION:-}" ]]; then
	SHELL_CONFIG="$USER_HOME/.zshrc"
elif [[ -n "${BASH_VERSION:-}" ]]; then
	SHELL_CONFIG="$USER_HOME/.bashrc"
else
	echo "Warning: Unsupported shell. Please manually add FZF_DEFAULT_OPTS to your shell startup file."
	log "Unsupported shell for fzf theme setup"
fi

if [[ -n "$SHELL_CONFIG" ]]; then
	FZF_DRACULA_OPTS='--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'
	if [[ "$ABYSS_FZF_THEME" == "dracula" ]]; then
		if grep -q "FZF_DEFAULT_OPTS" "$SHELL_CONFIG"; then
			sed -i '/export FZF_DEFAULT_OPTS=/d' "$SHELL_CONFIG"
			log "Removed existing FZF_DEFAULT_OPTS from $SHELL_CONFIG"
		fi
		echo "export FZF_DEFAULT_OPTS='$FZF_DRACULA_OPTS'" >> "$SHELL_CONFIG"
		log "Added Dracula fzf theme to $SHELL_CONFIG"
	fi
fi

echo "[*] The Abyss Sysadmin Toolbox installed successfully!"
log "Installation completed"
echo
echo
read -rp "Cleanup installation? [Y/n] " ans
ans=${ans:-Y}

if [[ "$ans" =~ ^[yY]$ ]]; then
	echo "Shredding and removing: $SRC_DIR"

	cd "$SRC_DIR" || exit 1

	find . -type f -exec shred -v -n 1 -u {} \;

	cd "$(mktemp -d)" || exit 1
	rm -rf "$SRC_DIR"

	echo "Cleanup complete..."
else
	echo "Skipping cleanup..."
fi
echo
echo
echo "Run with: cystoolbox"
echo "Update with: cystoolbox --update"
echo "Uninstall with: cystoolbox --uninstall"
