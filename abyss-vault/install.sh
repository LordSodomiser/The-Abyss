#!/usr/bin/env bash
# The Abyss Sysadmin Vault
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

# Installation

set -Eeuo pipefail
trap 'echo "Error: Script failed at line $LINENO"; exit 1' ERR

# Function for logging
log() {
	local msg="$*"
	echo "$(date '+%Y-%m-%d %H:%M:%S') - $msg" >> "${LOG_FILE:-/var/log/The-Abyss/.logs/vault.log}"
}

# Check root and prompt for sudo if needed
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

SRC_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
ENV_FILE="$SRC_DIR/.configs/.env"
DEST_DIR="/opt/The-Abyss"
VAULT_DIR="$DEST_DIR/abyss-vault"
LOG_DIR="/var/log/The-Abyss/.logs"
LOG_FILE="$LOG_DIR/vault.log"
LAUNCHER="/usr/local/bin/cadavault"
SOURCE_SCRIPT="$VAULT_DIR/vault.sh"
FUNC_FILE="$VAULT_DIR/functions.sh"
CHECKSUM_DIR="$VAULT_DIR/checksum"

echo "[*] Installing The Abyss Sysadmin Vault..."

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
# User-configurable settings
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
	    # Key exists, update it (escape special characters in value for sed)
	    escaped_value=$(printf '%s\n' "$value" | sed -e 's/[\/&]/\\&/g')
	    sed -i "s/^$key=.*/$key=$escaped_value/" "$ENV_FILE"
    else
	    # Key doesn't exist, append it
	    echo "$key=$value" >> "$ENV_FILE"
    fi
}

update_or_append "ABYSS_USER" "\"\${SUDO_USER:-\$USER}\""
update_or_append "ABYSS_OS" "\"\$(if [[ -f /etc/os-release ]]; then grep '^PRETTY_NAME=' /etc/os-release | cut -d= -f2 | tr -d '\"'; else echo 'Unknown'; fi)\""
update_or_append "ABYSS_INSTALL_DATE" "\"\$(date '+%Y-%m-%d %H:%M:%S')\""
update_or_append "LOG_INSTALLED_PKGS" "\"$VAULT_DIR/installed-pkgs.txt\""
update_or_append "VAULT_PATH" "\"$VAULT_DIR\""
update_or_append "LAUNCHER" "\"$LAUNCHER\""
update_or_append "SOURCE_SCRIPT" "\"$SOURCE_SCRIPT\""
update_or_append "FUNC_FILE" "\"$FUNC_FILE\""
update_or_append "LOG_DIR" "\"$LOG_DIR\""
update_or_append "LOG_FILE" "\"$LOG_FILE\""
update_or_append "ENV_FILE" "\"$VAULT_DIR/.configs/.env\""
update_or_append "CHECKSUM_DIR" "\"$CHECKSUM_DIR\""
update_or_append "CHALLENGE" "\"my-static-challenge-string\""
update_or_append "HOST" "\"$(hostname)\""
update_or_append "PKG_MGR" "\"$pkg_mgr_found\""

source "$ENV_FILE"

for file in vault.sh functions.sh; do
	if [[ ! -f "$SRC_DIR/$file" ]]; then
		echo "Error: $file not found."
		log "Missing file: $file"
		exit 1
	fi
done

if [[ -f "$LAUNCHER" ]]; then
	echo "Already installed at $LAUNCHER. Skipping copy."
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
	
	cp -r "$SRC_DIR/vault.sh" "$SRC_DIR/functions.sh" "$SRC_DIR/.configs" "$SRC_DIR/checksum" "$VAULT_DIR/"

	find "$VAULT_DIR" -type d -exec chmod 755 {} +
	find "$VAULT_DIR" -type f -exec chmod 644 {} +

	cat << 'EOF' > "$LAUNCHER"
#!/usr/bin/env bash

set -Eeuo pipefail

ENV_FILE="/opt/The-Abyss/abyss-vault/.configs/.env"
if [[ -f "$ENV_FILE" ]]; then
	source "$ENV_FILE"
else
	echo "Error: .env not found at $ENV_FILE" >&2
	exit 1
fi

: "${VAULT_PATH:=/opt/The-Abyss/abyss-vault}"
: "${SOURCE_SCRIPT:=/opt/The-Abyss/abyss-vault/vault.sh}"

if [[ ! -x "$SOURCE_SCRIPT" ]]; then
	echo "ERROR: vault.sh not found or not executable at $SOURCE_SCRIPT" >&2
	exit 1
fi

exec "$SOURCE_SCRIPT" "$@"
EOF

	chmod 755 "$SOURCE_SCRIPT" "$FUNC_FILE" "$LAUNCHER"
	log "Installed to $LAUNCHER"
	sleep 1
fi

# Initialization

echo "Beginning initiation..."
sleep 1

source "$ENV_FILE"

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
				required_tools=(apg btrfs cat cryptsetup e2fsck exfatlabel fatlabel fdisk fzf git gpg haveged ifconfig ip mat2 nmcli ntfs-3g paperkey parted qrencode rsync shred ssss-split steghide tar tomb vim wipe xfs_repair xz ykman)
				pkg_install="sudo apk add"
				;;
			apt)
				required_tools=(apg btrfs cat cryptsetup e2fsck exfatlabel fatlabel fdisk fzf git gpg haveged ifconfig ip mat2 nmcli ntfs-3g paperkey parted qrencode rsync shred ssss-split steghide tar tomb vim wipe xfs_repair xz ykman)
				pkg_install="sudo apt install -y"
				;;
			conda)
        			required_tools=(cat fzf git gpg haveged ifconfig paperkey qrencode shred ssss tar vim xz)
        			pkg_install="conda install -c conda-forge"
        			;;
    			dnf|yum)
        			required_tools=(apg btrfs cat cryptsetup e2fsck exfatlabel fatlabel fdisk fzf git gpg haveged ifconfig ip mat2 nmcli ntfs-3g paperkey parted qrencode rsync shred ssss-split steghide tar vim wipe xfs_repair xz ykman)
        			pkg_install="sudo $pkg_mgr_found install"
        			;;
    			emerge)
        			required_tools=(apg btrfs cat cryptsetup e2fsck exfatlabel fatlabel fdisk fzf git gpg haveged ifconfig ip mat2 nmcli ntfs-3g paperkey parted qrencode rsync shred ssss-split steghide tar tomb vim wipe xfs_repair xz ykman)
        			pkg_install="sudo emerge"
        			;;
    			nix-env)
        			required_tools=(apg btrfs cat cryptsetup e2fsck exfatlabel fatlabel fdisk fzf git gpg haveged ifconfig ip mat2 nmcli ntfs-3g paperkey parted qrencode rsync shred ssss-split steghide tar vim xfs_repair xz ykman)
        			pkg_install="nix-env -iA"
        			;;
			pacman)
				required_tools=(btrfs cat clevis cryptsetup e2fsck exfatlabel fatlabel fdisk fzf git gpg haveged ifconfig ip mat2 nmcli ntfs-3g paperkey parted pwgen qrencode rsync shred tar vim wipe xfs_repair xz ykman)
				pkg_install="sudo pacman -S --noconfirm"
				;;
    			pkg)
        			required_tools=(apg btrfs cat e2fsck exfatlabel fatlabel fzf git gpg haveged ifconfig ntfs-3g paperkey parted qrencode rsync shred ssss-split steghide tar vim wipe xz ykman)
       			 	pkg_install="sudo pkg install"
        			;;
    			pkg_add)
        			required_tools=(apg fatlabel fzf git gpg haveged ifconfig ntfs-3g qrencode rsync ssss-split tar vim wipe xz)
        			pkg_install="sudo pkg_add"
        			;;
   	 		pkgin)
        			required_tools=(apg btrfs cat e2fsck exfatlabel fatlabel fdisk fzf git gpg haveged ifconfig ntfs-3g paperkey parted qrencode rsync shred ssss-split steghide tar vim wipe xz ykman)
        			pkg_install="sudo pkgin install"
        			;;
    			slackpkg)
        			required_tools=(apg btrfs cat cryptsetup e2fsck exfatlabel fatlabel fdisk fzf git gpg haveged ifconfig ip nmcli ntfs-3g parted qrencode sync shred ssss-split tar vim wipe xfs_repair xz ykman)
        			pkg_install="sudo slackpkg install"
        			;;
    			spack)
       				required_tools=(btrfs cat cryptsetup e2fsck exfatlabel fatlabel fdisk fzf git gpg haveged ifconfig ip ntfs-3g paperkey parted qrencode rsync shred ssss-split steghide tar vim wipe xfs_repair xz)
        			pkg_install="spack install"
        			;;
    			zypper)
        			required_tools=(apg btrfs cat cryptsetup e2fsck exfatlabel fatlabel fdisk fzf git gpg haveged ifconfig ip mat2 nmcli ntfs-3g paperkey parted qrencode rsync shred ssss-split steghide tar tomb vim wipe xfs_repair xz ykman)
        			pkg_install="sudo zypper install -y"
        			;;
		esac
		
		declare -A tool_to_package

		case "$pkg_mgr_found" in
			apk)
				tool_to_package=(
					["apg"]="apg" ["btrfs"]="btrfs-progs" ["cat"]="coreutils"
					["cryptsetup"]="cryptsetup" ["fatlabel"]="dosfstools"
					["e2fsck"]="e2fsprogs" ["exfatlabel"]="exfatprogs" ["fdisk"]="util-linux"
					["fzf"]="fzf" ["git"]="git" ["gpg"]="gnupg" ["haveged"]="haveged" ["ifconfig"]="net-tools"
					["ip"]="iproute2" ["mat2"]="mat2" ["nmcli"]="networkmanager"
					["ntfs-3g"]="ntfs-3g" ["paperkey"]="paperkey" ["parted"]="parted" ["qrencode"]="qrencode"
					["rsync"]="rsync" ["shred"]="coreutils" ["ssss-split"]="ssss" ["steghide"]="steghide" ["tar"]="tar"
					["tomb"]="tomb" ["vim"]="vim" ["wipe"]="wipe" ["xfs_repair"]="xfsprogs" ["xz"]="xz"
					["ykman"]="yubikey-manager"
				)
				;;
			apt)
				tool_to_package=(
					["apg"]="apg" ["btrfs"]="btrfs-progs" ["cat"]="coreutils"
					["cryptsetup"]="cryptsetup" ["fatlabel"]="dosfstools" ["e2fsck"]="e2fsprogs"
					["exfatlabel"]="exfatprogs" ["fdisk"]="util-linux" ["fzf"]="fzf" ["git"]="git" ["gpg"]="gnupg" ["haveged"]="haveged"
					["ifconfig"]="net-tools" ["ip"]="iproute2" ["mat2"]="mat2" ["nmcli"]="network-manager"
					["ntfs-3g"]="ntfs-3g" ["paperkey"]="paperkey" ["parted"]="parted" ["qrencode"]="qrencode"
					["rsync"]="rsync" ["shred"]="coreutils" ["ssss-split"]="ssss"
					["steghide"]="steghide" ["tar"]="tar" ["tomb"]="tomb" ["vim"]="vim"
					["wipe"]="wipe" ["xfs_repair"]="xfsprogs" ["xz"]="xz-utils"
					["ykman"]="yubikey-manager"
				)
				;;
			conda)
				tool_to_package=(
					["cat"]="coreutils" ["fzf"]="fzf" ["git"]="git" ["gpg"]="gnupg" ["haveged"]="haveged"
					["ifconfig"]="net-tools" ["paperkey"]="paperkey" ["qrencode"]="qrencode"
					["shred"]="coreutils" ["ssss-split"]="ssss"
					["tar"]="tar" ["vim"]="vim" ["xz"]="xz"
				)
				;;
			dnf|yum)
				tool_to_package=(
					["apg"]="apg" ["btrfs"]="btrfs-progs" ["cat"]="coreutils" ["cryptsetup"]="cryptsetup"
					["fatlabel"]="dosfstools" ["e2fsck"]="e2fsprogs" ["exfatlabel"]="exfatprogs" ["fdisk"]="util-linux"
					["fzf"]="fzf" ["git"]="git" ["gpg"]="gnupg2" ["haveged"]="haveged" ["ifconfig"]="net-tools" ["ip"]="iproute" ["mat2"]="mat2"
					["nmcli"]="NetworkManager" ["ntfs-3g"]="ntfs-3g" ["paperkey"]="paperkey" 
					["parted"]="parted" ["qrencode"]="qrencode" ["rsync"]="rsync"
					["shred"]="coreutils" ["ssss-split"]="ssss" ["steghide"]="steghide"
					["tar"]="tar" ["vim"]="vim" ["wipe"]="wipe"
					["xfs_repair"]="xfsprogs" ["xz"]="xz"
					["ykman"]="yubikey-manager"
				)
				;;
			emerge)
				tool_to_package=(
					["apg"]="app-misc/apg" ["btrfs"]="sys-fs/btrfs-progs" ["cat"]="sys-apps/coreutils"
					["cryptsetup"]="sys-fs/cryptsetup" ["fatlabel"]="sys-fs/dosfstools" ["e2fsck"]="sys-fs/e2fsprogs"
					["exfatlabel"]="sys-fs/exfatprogs" ["fdisk"]="sys-apps/util-linux" ["fzf"]="app-misc/fzf" ["git"]="dev-vcs/git" ["gpg"]="app-crypt/gnupg"
					["haveged"]="app-crypt/haveged" ["ifconfig"]="net-misc/net-tools" ["ip"]="net-misc/iproute2"
					["mat2"]="app-text/mat2" ["nmcli"]="net-misc/networkmanager" ["ntfs-3g"]="sys-fs/ntfs3g" ["paperkey"]="app-text/paperkey"
					["parted"]="sys-block/parted" ["qrencode"]="media-gfx/qrencode" ["rsync"]="rsync"
					["shred"]="sys-apps/coreutils" ["ssss-split"]="apt-crypt/ssss" ["steghide"]="media-gfx/steghide"
					["tar"]="app-arch/tar" ["tomb"]="app-crypt/tomb" ["vim"]="app-editors/vim" ["wipe"]="sys-apps/wipe"
					["xfs_repair"]="sys-fs/xfsprogs" ["xz"]="app-arch/xz-utils" ["ykman"]="sys-auth/yubikey-manager"
				)
				;;
			nix-env)
				tool_to_package=(
					["apg"]="nixpkgs.apg" ["btrfs"]="nixpkgs.btrfs-progs" ["cat"]="nixpkgs.coreutils"
					["cryptsetup"]="nixpkgs.cryptsetup" ["fatlabel"]="nixpkgs.dosfstools" ["e2fsck"]="nixpkgs.e2fsprogs"
					["exfatlabel"]="nixpkgs.exfat" ["fdisk"]="nixpkgs.util-linux" ["fzf"]="nixpkgs.fzf" ["git"]="nixpkgs.git" ["gpg"]="nixpkgs.gnupg" ["haveged"]="nixpkgs.haveged"
					["ifconfig"]="nixpkgs.nettools" ["ip"]="nixpkgs.iproute2" ["mat2"]="nixpkgs.mat2" ["nmcli"]="nixpkgs.networkmanager"
					["ntfs-3g"]="nixpkgs.ntfs3g" ["paperkey"]="nixpkgs.paperkey" ["parted"]="nixpkgs.parted" ["qrencode"]="nixpkgs.qrencode"
					["rsync"]="nixpkgs.rsync" ["shred"]="nixpkgs.coreutils" ["ssss-split"]="nixpkgs.ssss"
					["steghide"]="nixpkgs.steghide" ["tar"]="nixpkgs.gnutar"
					["vim"]="nixpkgs.vim" ["xfsprogs"]="nixpkgs.xfsprogs" ["xz"]="nixpkgs.xz"
					["ykman"]="nixpkgs.yubikey-manager"
				)
				;;
			pacman)
				tool_to_package=(
					["btrfs"]="btrfs-progs" ["cat"]="coreutils" ["clevis"]="clevis"
					["cryptsetup"]="cryptsetup" ["fatlabel"]="dosfstools"
					["e2fsck"]="e2fsprogs" ["exfatlabel"]="exfatprogs" ["fdisk"]="util-linux"
					["fzf"]="fzf" ["git"]="git" ["gpg"]="gnupg" ["haveged"]="haveged" ["ifconfig"]="net-tools"
					["ip"]="iproute2" ["mat2"]="mat2" ["nmcli"]="networkmanager"
					["ntfs-3g"]="ntfs-3g" ["paperkey"]="paperkey" ["parted"]="parted" ["pwgen"]="pwgen"
					["qrencode"]="qrencode" ["rsync"]="rsync" ["shred"]="coreutils" ["tar"]="tar"
					["vim"]="vim" ["wipe"]="wipe" ["xfs_repair"]="xfsprogs" ["xz"]="xz"
					["ykman"]="yubikey-manager"
				)
				;;
			pkg)
				tool_to_package=(
					["apg"]="security/apg" ["btrfs"]="sysutils/btrfs-progs"
					["cat"]="sysutils/coreutils" ["fatlabel"]="sysutils/dosfstools"
					["e2fsck"]="sysutils/e2fsprogs" ["exfatlabel"]="sysutils/fusefs-exfat" ["fzf"]="fzf"
					["gpg"]="security/gnupg" ["haveged"]="security/haveged" ["ifconfig"]="base" ["git"]="git"
					["ntfs-3g"]="sysutils/fusefs-ntfs" ["paperkey"]="security/paperkey"
					["parted"]="sysutils/gparted" ["qrencode"]="graphics/qrencode" ["rsync"]="net/rsync"
					["shred"]="sysutils/coreutils" ["ssss-split"]="security/ssss" ["steghide"]="security/steghide"
					["tar"]="base" ["vim"]="editors/vim" ["wipe"]="sysutils/wipe"
					["xz"]="archivers/xz" ["ykman"]="security/yubikey-manager"
				)
				;;
			pkg_add)
				tool_to_package=(
					["apg"]="security/apg" ["fatlabel"]="sysutils/mtools" ["fzf"]="fzf"
					["git"]="git" ["gpg"]="security/gpg" ["haveged"]="security/haveged"
					["ifconfig"]="base" ["ntfs-3g"]="sysutils/ntfs-3g"
					["qrencode"]="graphics/qrencode" ["rsync"]="rsync" ["tar"]="base" 
					["ssss-split"]="security/ssss" ["vim"]="editors/vim" ["wipe"]="sysutils/wipe"
					["xz"]="archivers/xz"
				)
				;;
			pkgin)
				tool_to_package=(
					["apg"]="security/apg" ["btrfs"]="sys-fs/btrfs-progs"
					["cat"]="sysutils/coreutils" ["fatlabel"]="sysutils/dosfstools"
					["e2fsck"]="sysutils/e2fsprogs" ["exfatlabel"]="sysutils/exfat-fuse"
					["fdisk"]="sysutils/fdisk" ["fzf"]="fzf" ["git"]="git" ["gpg"]="security/gnupg2" ["haveged"]="security/haveged"
					["ifconfig"]="base" ["ntfs-3g"]="sysutils/ntfs-3g" ["paperkey"]="security/paperkey"
					["parted"]="sysutils/gpart" ["qrencode"]="graphics/qrencode" ["rsync"]="net/rsync"
					["shred"]="sysutils/coreutils" ["ssss-split"]="security/ssss" ["steghide"]="security/steghide"
					["tar"]="base" ["vim"]="editors/vim" ["wipe"]="sysutils/wipe"
					["xz"]="archivers/xz" ["ykman"]="security/yubikey-manager"
				)
				;;
			slackpkg)
				tool_to_package=(
					["apg"]="apg" ["btrfs"]="btrfs-progs"
					["cat"]="coreutils" ["cryptsetup"]="cryptsetup"
					["fatlabel"]="dosfstools" ["e2fsck"]="e2fsprogs"
					["exfatlabel"]="exfatprogs" ["fdisk"]="util-linux" ["fzf"]="fzf" ["git"]="git"
					["gpg"]="gnupg" ["haveged"]="haveged" ["ifconfig"]="net-tools"
					["ip"]="iproute2" ["nmcli"]="NetworkManager" ["ntfs-3g"]="ntfs-3g"
					["parted"]="parted" ["qrencode"]="qrencode" ["rsync"]="rsync"
					["shred"]="coreutils" ["ssss-split"]="ssss" ["tar"]="tar" ["vim"]="vim"
					["wipe"]="wipe" ["xfs_repair"]="xfsprogs" ["xz"]="xz"
					["ykman"]="yubikey-manager"
				)
				;;
			spack)
				tool_to_package=(
					["btrfs"]="btrfsprogs" ["cat"]="coreutils"
					["cryptsetup"]="cryptsetup" ["fatlabel"]="dosfstools"
					["e2fsck"]="e2fsprogs" ["exfatlabel"]="exfatprogs"
					["fdisk"]="util-linux" ["fzf"]="fzf" ["git"]="git" ["gpg"]="gnupg" ["haveged"]="haveged"
					["ifconfig"]="net-tools" ["ip"]="iproute2" ["ntfs-3g"]="ntfs3g"
					["paperkey"]="paperkey" ["parted"]="parted" ["qrencode"]="qrencode" ["rsync"]="rsync"
					["shred"]="coreutils" ["ssss-split"]="ssss" ["steghide"]="steghide" ["tar"]="tar"
					["vim"]="vim" ["wipe"]="wipe" ["xfs_repair"]="xfsprogs"
					["xz"]="xz"
				)
				;;
			zypper)
				tool_to_package=(
					["apg"]="apg" ["btrfs"]="btrfs-progs"
					["cat"]="coreutils" ["cryptsetup"]="cryptsetup"
					["fatlabel"]="dosfstools" ["e2fsck"]="e2fsprogs"
					["exfatlabel"]="exfatprogs" ["fdisk"]="util-linux" ["fzf"]="fzf"
					["git"]="git" ["gpg"]="gnupg2" ["haveged"]="haveged" ["ifconfig"]="net-tools"
					["ip"]="iproute2" ["mat2"]="mat2" ["nmcli"]="NetworkManager"
					["ntfs-3g"]="ntfs-3g" ["paperkey"]="paperkey" ["parted"]="parted"
					["qrencode"]="qrencode" ["rsync"]="rsync" ["shred"]="coreutils" ["ssss-split"]="ssss"
					["steghide"]="steghide" ["tar"]="tar" ["tomb"]="tomb"
					["vim"]="vim" ["wipe"]="wipe" ["xfs_repair"]="xfsprogs" ["xz"]="xz"
					["ykman"]="yubikey-manager"
				)
				;;
		esac
			
		missing_tools=()
        	missing_packages=()

		for tool in "${required_tools[@]}"; do
			if ! command -v "$tool" &>/dev/null; then
				missing_tools+=("$tool")
				if [[ -n "${tool_to_package[$tool]}" ]]; then
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
			echo "Run with: cadavault"
			echo "Update with: cadavault --update"
			echo "Uninstall with: cadavault --uninstall"
			exit 0
		fi
			
		declare -a installed_pkgs=()
			
		echo "Missing tools: ${missing_tools[*]}"
		prompt_confirm

		unique_packages=($(echo "${missing_packages[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
			
		# Update package manager caches if necessary
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
					pkg_log "$pkg"
				done
				: >"$LOG_INSTALLED_PKGS"
				echo "${unique_packages[*]}" >>"$LOG_INSTALLED_PKGS"
			else
				echo "Warning: Failed to install some or all packages: ${unique_packages[*]}"
				log "Failed to install some or all packages: ${unique_packages[*]}"
			fi
		else
			echo "No packages to install."
		fi

		# Update HOST in .env
		echo
		echo
		echo "All required packages have been installed..."
		echo
		echo

USER_HOME=$(getent passwd "$ABYSS_USER" | cut -d: -f6)
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
		# Remove existing FZF_DEFAULT_OPTS to avoid duplicates
		if grep -q "FZF_DEFAULT_OPTS" "$SHELL_CONFIG"; then
			sed -i '/export FZF_DEFAULT_OPTS=/d' "$SHELL_CONFIG"
			log "Removed existing FZF_DEFAULT_OPTS from $SHELL_CONFIG"
		fi
		# Append Dracula theme
		echo "export FZF_DEFAULT_OPTS='$FZF_DRACULA_OPTS'" >> "$SHELL_CONFIG"
		log "Added Dracula fzf theme to $SHELL_CONFIG"
	fi
fi

echo "[*] The Abyss Sysadmin Vault installed successfully!"
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
echo "Run with: cadavault"
echo "Update with: cadavault --update"
echo "Uninstall with: cadavault --uninstall"
