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

log() { echo -e "\033[1;34m[*]\033[0m $*"; }
warn() { echo -e "\033[1;33m[!]\033[0m $*" >&2; }
die() { echo -e "\033[1;31m[x]\033[0m $*" >&2; exit 1; }

ENV_FILE="/opt/The-Abyss/abyss-vault/.configs/.env"
if [[ -f "$ENV_FILE" ]]; then
	source "$ENV_FILE"
else
	warn "No .env file found at $ENV_FILE"
fi

: "${SOURCE_SCRIPT:=/opt/The-Abyss/abyss-vault/vault.sh}"

oath_banner() {
	cat << "EOF"
                                                 ██▓
                                                 ▒▓▒
                                                 ░▒
                                                 ░
                                                  ░
                                                  ░
                                       ▄▄▄█████▓ ██░ ██ ▓█████
                                       ▓  ██▒ ▓▒▓██░ ██▒▓█   ▀
                                       ▒ ▓██░ ▒░▒██▀▀██░▒███
                                       ░ ▓██▓ ░ ░▓█ ░██ ▒▓█  ▄
                                         ▒██▒ ░ ░▓█▒░██▓░▒████▒          ██▓
                                         ▒ ░░    ▒ ░░▒░▒░░ ▒░ ░          ▒▓▒
                                           ░     ▒ ░▒░ ░ ░ ░  ░          ░▒
                                         ░       ░  ░░ ░   ░             ░
                                                 ░  ░  ░   ░  ░           ░
                                                                          ░




                                                                 ██▓
                                                                 ▒▓▒
                                                                 ░▒
                                                                 ░
                                                                  ░
                                                                  ░
                                  ▒█████   ▄▄▄     ▄▄▄█████▓ ██░ ██
                                 ▒██▒  ██▒▒████▄   ▓  ██▒ ▓▒▓██░ ██▒
                                 ▒██░  ██▒▒██  ▀█▄ ▒ ▓██░ ▒░▒██▀▀██░
                                 ▒██   ██░░██▄▄▄▄██░ ▓██▓ ░ ░▓█ ░██
                ██▓              ░ ████▓▒░ ▓█   ▓██▒ ▒██▒ ░ ░▓█▒░██▓
                ▒▓▒              ░ ▒░▒░▒░  ▒▒   ▓▒█░ ▒ ░░    ▒ ░░▒░▒
                ░▒                 ░ ▒ ▒░   ▒   ▒▒ ░   ░     ▒ ░▒░ ░
                ░                ░ ░ ░ ▒    ░   ▒    ░       ░  ░░ ░
                 ░                   ░ ░        ░  ░         ░  ░  ░
                 ░




                                              ██▓
                                              ▒▓▒
                                              ░▒
                                              ░
                                               ░
                                               ░




                                                                               ██▓
                                                                               ▒▓▒
                                                                               ░▒
                                                                               ░
                                                                                ░
                                                                                ░




                                                             ██▓
                                                             ▒▓▒
                                                             ░▒
                                                             ░
                                                              ░
                                                              ░
                      ██▀███  ▓█████  ███▄ ▄███▓ ▄▄▄       ██▓ ███▄    █   ██████
                     ▓██ ▒ ██▒▓█   ▀ ▓██▒▀█▀ ██▒▒████▄    ▓██▒ ██ ▀█   █ ▒██    ▒
                     ▓██ ░▄█ ▒▒███   ▓██    ▓██░▒██  ▀█▄  ▒██▒▓██  ▀█ ██▒░ ▓██▄
                     ▒██▀▀█▄  ▒▓█  ▄ ▒██    ▒██ ░██▄▄▄▄██ ░██░▓██▒  ▐▌██▒  ▒   ██▒
                     ░██▓ ▒██▒░▒████▒▒██▒   ░██▒ ▓█   ▓██▒░██░▒██░   ▓██░▒██████▒▒ ██▓
                     ░ ▒▓ ░▒▓░░░ ▒░ ░░ ▒░   ░  ░ ▒▒   ▓▒█░░▓  ░ ▒░   ▒ ▒ ▒ ▒▓▒ ▒ ░ ▒▓▒
                       ░▒ ░ ▒░ ░ ░  ░░  ░      ░  ▒   ▒▒ ░ ▒ ░░ ░░   ░ ▒░░ ░▒  ░ ░ ░▒
                       ░░   ░    ░   ░      ░     ░   ▒    ▒ ░   ░   ░ ░ ░  ░  ░   ░
                        ░        ░  ░       ░         ░  ░ ░           ░       ░    ░
                                                                                    ░




                                                                                  ██▓
                                                                                  ▒▓▒
                                                                                  ░▒
                                                                                  ░
                                                                                   ░
                                                                                   ░




                                           ██▓
                                           ▒▓▒
                                           ░▒
                                           ░
                                            ░
                                            ░




                                                                   ██▓
                                                                   ▒▓▒
                                                                   ░▒
                                                                   ░
                                                                    ░
                                                                    ░
                                    ▄▄▄█████▓ ██▀███   █    ██ ▓█████                     
                                    ▓  ██▒ ▓▒▓██ ▒ ██▒ ██  ▓██▒▓█   ▀                     
                                    ▒ ▓██░ ▒░▓██ ░▄█ ▒▓██  ▒██░▒███                       
                                    ░ ▓██▓ ░ ▒██▀▀█▄  ▓▓█  ░██░▒▓█  ▄                     
                                      ▒██▒ ░ ░██▓ ▒██▒▒▒█████▓ ░▒████▒    ██▓             
                                      ▒ ░░   ░ ▒▓ ░▒▓░░▒▓▒ ▒ ▒ ░░ ▒░ ░    ▒▓▒             
                                        ░      ░▒ ░ ▒░░░▒░ ░ ░  ░ ░  ░    ░▒              
                                      ░        ░░   ░  ░░░ ░ ░    ░       ░               
                                                ░        ░        ░  ░     ░              
                                                                           ░              
                                                                                             
                                                                                             
                                                                                             
                                                                                             
                                                    ██▓                                      
                                                    ▒▓▒                                      
                                                    ░▒                                       
                                                    ░                                        
                                                     ░                                       
                                                     ░                                       
                                                                                             
                                                                                             
                                                                                             
                                                                                             
                                              ██▓                                            
                                              ▒▓▒                                            
                                              ░▒                                             
                                              ░                                              
                                               ░                                             
                                               ░                                             
EOF
}

betrayal_banner() {
	cat << "EOF"
                                                   ▄▄▄▄   ▓█████▄▄▄█████▓ ██▀███   ▄▄▄     ▓██   ██▓ ▄▄▄       ██▓
                                                  ▓█████▄ ▓█   ▀▓  ██▒ ▓▒▓██ ▒ ██▒▒████▄    ▒██  ██▒▒████▄    ▓██▒
                                                  ▒██▒ ▄██▒███  ▒ ▓██░ ▒░▓██ ░▄█ ▒▒██  ▀█▄   ▒██ ██░▒██  ▀█▄  ▒██░
                                                  ▒██░█▀  ▒▓█  ▄░ ▓██▓ ░ ▒██▀▀█▄  ░██▄▄▄▄██  ░ ▐██▓░░██▄▄▄▄██ ▒██░
                                  ██▓             ░▓█  ▀█▓░▒████▒ ▒██▒ ░ ░██▓ ▒██▒ ▓█   ▓██▒ ░ ██▒▓░ ▓█   ▓██▒░██████▒             ██▓
                                  ▒▓▒             ░▒▓███▀▒░░ ▒░ ░ ▒ ░░   ░ ▒▓ ░▒▓░ ▒▒   ▓▒█░  ██▒▒▒  ▒▒   ▓▒█░░ ▒░▓  ░             ▒▓▒
                                  ░▒              ▒░▒   ░  ░ ░  ░   ░      ░▒ ░ ▒░  ▒   ▒▒ ░▓██ ░▒░   ▒   ▒▒ ░░ ░ ▒  ░             ░▒
                                  ░                ░    ░    ░    ░        ░░   ░   ░   ▒   ▒ ▒ ░░    ░   ▒     ░ ░                ░
                                   ░               ░         ░  ░           ░           ░  ░░ ░           ░  ░    ░  ░              ░
                                   ░                    ░                                   ░ ░                                     ░




                         ██▓                                                                    ██▓
                         ▒▓▒                                                                    ▒▓▒
                         ░▒                                                                     ░▒
                         ░                                                                      ░
                          ░                                                                      ░
                          ░                                                                      ░
                                                       ▒█████
                                                      ▒██▒  ██▒
                                                      ▒██░  ██▒
                                                      ▒██   ██░
                                                      ░ ████▓▒░
                                                      ░ ▒░▒░▒░
                                                        ░ ▒ ▒░
                                                      ░ ░ ░ ▒
                                                          ░ ░



                         ██▓                                      ██▓
                         ▒▓▒                                      ▒▓▒
                         ░▒                                       ░▒
                         ░                                        ░
                          ░                                        ░
                          ░                                        ░




                                  ██▓                                      ██▓
                                  ▒▓▒                                      ▒▓▒
                                  ░▒                                       ░▒
                                  ░                                        ░
                                   ░                                        ░
                                   ░                                        ░
EOF
}

secure_shred() {
	local target="$1"
	if [[ -z "$target" ]]; then
		warn "No target specified for shredding"
		return 1
	fi
	if [[ -e "$target" ]]; then
		log "Shredding $target ..."
		if command -v shred >/dev/null 2>&1; then
			if [[ -f "$target" ]]; then
				shred -v -n 1 -u "$target" || { warn "Shred failed, falling back to rm"; rm -rf "$target" || die "Failed to remove $target"; }
			else
				log "Target is a directory, using rm -rf"
				rm -rf "$target" || die "Failed to remove directory $target"
			fi
		else
			warn "shred not found. Falling back to rm"
			rm -rf "$target" || die "Failed to remove $target"
		fi
	else
		warn "Target $target does not exist"
	fi
}

show_help() {
	cat << EOF
The Abyss Sysadmin Vault

Usage:
	cadavault [command] [options]

Commands:
	--help			Show this help message
	--update		Update The Abyss Sysadmin Vault
	--uninstall		Uninstall The Abyss Sysadmin Vault
EOF
}

update_cadavault() {
	log "Updating The Abyss Sysadmin Vault..."
	local repo_url="https://github.com/LordSodomiser/The-Abyss.git"
	local install_dir="/opt/The-Abyss"
	local vault_dir="$install_dir/abyss-vault"
	local pkg_file="$vault_dir/installed-pkgs.txt"
	local default_branch="${DEFAULT_BRANCH:-main}"
	local pkg_mgr_found=""
	local pkg_install=""
	local missing_tools=()
	local missing_packages=()
	local required_tools=(
		apg btrfs cat cryptsetup e2fsck exfatlabel fatlabel fdisk fzf git gpg haveged
		ifconfig ip mat2 nmcli ntfs-3g paperkey parted qrencode rsync shred ssss-split
		steghide tar tomb vim wipe xfs_repair xz ykman
	)
	declare -A tool_to_package=(
		["apg"]="apg" ["btrfs"]="btrfs-progs" ["cat"]="coreutils" ["cryptsetup"]="cryptsetup"
		["fatlabel"]="dosfstools" ["e2fsck"]="e2fsprogs" ["exfatlabel"]="exfatprogs"
		["fdisk"]="util-linux" ["fzf"]="fzf" ["git"]="git" ["gpg"]="gnupg" ["haveged"]="haveged"
		["ifconfig"]="net-tools" ["ip"]="iproute2" ["mat2"]="mat2" ["nmcli"]="networkmanager"
		["ntfs-3g"]="ntfs-3g" ["paperkey"]="paperkey" ["parted"]="parted" ["qrencode"]="qrencode"
		["rsync"]="rsync" ["shred"]="coreutils" ["ssss-split"]="ssss" ["steghide"]="steghide"
		["tar"]="tar" ["tomb"]="tomb" ["vim"]="vim" ["wipe"]="wipe" ["xfs_repair"]="xfsprogs"
		["xz"]="xz" ["ykman"]="yubikey-manager"
	)

	local env_file="$vault_dir/.configs/.env"
	if [[ -f "$env_file" ]]; then
		source "$env_file"
	else
		warn "No .env file found at $env_file"
	fi

	for mgr in apk apt conda dnf yum emerge nix-env pacman pkg pkg_add pkgin slackpkg spack zypper; do
		if command -v "$mgr" >/dev/null 2>&1; then
			pkg_mgr_found="$mgr"
			case "$mgr" in
				apk) pkg_install="sudo apk add" ;;
				apt) pkg_install="sudo apt install -y" ;;
				conda) pkg_install="conda install -c conda-forge" ;;
				dnf|yum) pkg_install="sudo $mgr install -y" ;;
				emerge) pkg_install="sudo emerge" ;;
				nix-env) pkg_install="nix-env -iA" ;;
				pacman) pkg_install="sudo pacman -S --noconfirm" ;;
				pkg) pkg_install="sudo pkg install" ;;
				pkg_add) pkg_install="sudo pkg_add" ;;
				pkgin) pkg_install="sudo pkgin install" ;;
				slackpkg) pkg_install="sudo slackpkg install" ;;
				spack) pkg_install="spack install" ;;
				zypper) pkg_install="sudo zypper install -y" ;;
			esac
			break
		fi
	done

	for tool in "${required_tools[@]}"; do
		if ! command -v "$tool" >/dev/null 2>&1; then
			missing_tools+=("$tool")
			if [[ -n "${tool_to_package[$tool]}" ]]; then
				missing_packages+=("${tool_to_package[$tool]}")
			else
				warn "No package mapping for $tool, skipping"
			fi
		fi
	done

	if [[ ${#missing_tools[@]} -gt 0 ]]; then
		if [[ -z "$pkg_mgr_found" ]]; then
			die "No supported package manager found. Please install ${missing_tools[*]} manually."
		fi
		warn "Missing required tools: ${missing_tools[*]}"
		log "Found package manager: $pkg_mgr_found"
		read -rp "Install required packages for missing tools? [Y/n] " ans
		ans=${ans:-Y}
		if [[ ! "$ans" =~ ^[yY]$ ]]; then
			die "Installation aborted by user."
		fi

		case "$pkg_mgr_found" in
			apk) sudo apk update || warn "Failed to update apk cache" ;;
			apt) sudo apt update || warn "Failed to update apt cache" ;;
			slackpkg) sudo slackpkg update || warn "Failed to update slackpkg cache" ;;
			dnf|yum) sudo "$pkg_mgr_found" makecache || warn "Failed to update $pkg_mgr_found cache" ;;
			zypper) sudo zypper refresh || warn "Failed to update zypper cache" ;;
		esac

		local unique_packages=($(echo "${missing_packages[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
		if [[ ${#unique_packages[@]} -gt 0 ]]; then
			log "Installing packages: ${unique_packages[*]}..."
			if $pkg_install "${unique_packages[@]}" ; then
				log "Packages installed successfully."
				# Append to installed-pkgs.txt
				[[ -d "$vault_dir" ]] || sudo mkdir -p "$vault_dir" || die "Failed to create directory $vault_dir"
				for pkg in "${unique_packages[@]}"; do
					if ! grep -Fx "$pkg" "$pkg_file" >/dev/null 2>&1; then
						if [[ $EUID -ne 0 ]]; then
							sudo sh -c "echo '$pkg' >> '$pkg_file'" || warn "Failed to append $pkg to $pkg_file"
						else
							echo "$pkg" >> "$pkg_file" || warn "Failed to append $pkg to $pkg_file"
						fi
					fi
				done
				log "Installed packages recorded in $pkg_file."
			else
				warn "Failed to install some or all packages: ${unique_packages[*]}"
				die "Package installation failed. Update aborted."
			fi
		else
			log "No packages to install."
		fi
	else
		log "All required tools are already installed."
	fi

	if ! command -v git >/dev/null 2>&1; then
		die "git is not installed. Please install git to use the update feature."
	fi

	if [[ ! -d "$install_dir/.git" ]] then
		die "Vault repository not found at $install_dir"
	fi

	log "Marking $install_dir as safe for Git operations..."
	git config --global --add safe.directory "$install_dir" || warn "Failed to mark $install_dir as safe directory, but continuing..."

	cd "$install_dir" || die "Could not access $install_dir"

	if [[ -n "$(git status --porcelain)" ]]; then
		warn "Uncommitted changes detected. They will be overwritten."
		read -p "Continue with update? [y/N]: " ans
		ans=${ans:-N}
		[[ "$ans" =~ ^[yY]$ ]] || die "Update aborted by user"
	fi

	log "Fetching updates from $repo_url ..."
	git fetch --all || die "Failed to fetch updates"
	git reset --hard origin/$default_branch || die "Failed to reset to origin/$default_branch"

	if [[ -f "$env_file" ]]; then
		source "$env_file"
		log "Re-sourced .env file after update."
	else
		warn "No .env file found at $env_file after update."
	fi

	log "Abyss Vault updated successfully."
}

uninstall_cadavault() {
	local repo_dir="${VAULT_PATH:-/opt/The-Abyss/abyss-vault}"
	local launcher="${LAUNCHER:-/usr/local/bin/cadavault}"
	local env_file="${ENV_FILE:-/opt/The-Abyss/abyss-vault/.configs/.env}"

	log "Initiating uninstallation of The Abyss Sysadmin Vault..."
	read -p "The tools may be gone, but the stain of the oath remains. Shall we begin the purge? [y/N]: " ans
	ans=${ans:-N}
	if [[ "$ans" =~ ^[nN]$ ]]; then
		oath_banner || warn "oath_banner not available"
		sleep 1
		echo
		echo "Wise... few who sever the oath ever find peace again..."
		sleep 1
		exit 0
	fi

	if [[ -z "$PKG_MGR" ]]; then
		die "No package manager defined in $PKG_MGR"
	fi

	if [[ ! -f "$LOG_INSTALLED_PKGS" ]]; then
		die "No installed packages log found at $LOG_INSTALLED_PKGS"
	fi

	declare -a INSTALLED_PKG_LIST
	while IFS= read -r pkg; do
		[[ -n "$pkg" ]] && INSTALLED_PKG_LIST+=("$pkg")
	done < "$LOG_INSTALLED_PKGS"

	if pgrep -f "vault.sh" >/dev/null; then
		log "Stopping running vault processes..."
		pkill -f "vault.sh" 2>/dev/null || warn "Failed to halt some vault processes"
	fi

	secure_shred "$launcher"
	secure_shred "$env_file"

	if [[ -d "$repo_dir" ]]; then
		log "Securely removing repo at $repo_dir ..."
		find "$repo_dir" -type f -exec shred -v -n 1 -u {} \; || warn "Some files could not be shredded"
		rm -rf "$repo_dir" || die "Failed to remove $repo_dir"
	fi

	for pkg in "${INSTALLED_PKG_LIST[@]}"; do
		log "Uninstalling $pkg with $PKG_MGR..."
		case "$PKG_MGR" in
			apk) apk del "$pkg" || warn "Failed to uninstall $pkg" ;;
			apt) apt remove --yes "$pkg" || warn "Failed to uninstall $pkg" ;;
			conda) conda remove --yes "$pkg" || warn "Failed to uninstall $pkg" ;;
			dnf) dnf remove --assumeyes "$pkg" || warn "Failed to uninstall $pkg" ;;
			emerge) emerge --unmerge --quiet "$pkg" || warn "Failed to uninstall $pkg" ;;
			nix-env) nix-env --uninstall "$pkg" || warn "Failed to uninstall $pkg" ;;
			pacman) pacman -R --noconfirm "$pkg" || warn "Failed to uninstall $pkg" ;;
			pkg) pkg delete -y "$pkg" || warn "Failed to uninstall $pkg" ;;
			pkgin) pkgin -y remove "$pkg" || warn "Failed to uninstall $pkg" ;;
			pkg_add) pkg_delete -q "$pkg" || warn "Failed to uninstall $pkg" ;;
			slackpkg) slackpkg remove -batch=on "$pkg" || warn "Failed to uninstall $pkg" ;;
			spack) spack uninstall -y "$pkg" || warn "Failed to uninstall $pkg" ;;
			yum) yum remove -y "$pkg" || warn "Failed to uninstall $pkg" ;;
			zypper) zypper remove --non-interactive "$pkg" || warn "Failed to uninstall $pkg" ;;
			*) die "Unsupported package manager: $PKG_MGR" ;;
		esac
	done
	
	log "All packages that were installed for the vault have been uninstalled."
	sleep 1

	log "The Abyss Sysadmin Vault has been uninstalled..."

	betrayal_banner

	sleep 2

	log "The Abyss Sysadmin Vault has been completely uninstalled."
	log "You may need to manually remove references to cadavault from your shell configuration (e.g., .bashrc, .zshrc)."

	exit 0
}

handling() {
	case "${1:-}" in
		--help|-h)
			show_help
			exit 0
			;;
		--update)
			update_cadavault
			exit 0
			;;
		--uninstall)
			uninstall_cadavault
			;;
		"")
			return 0
			;;
		*)
			die "Invalid argument: ${1:-unkown}"
			;;
	esac
}

handling "$@"

setup_traps() {
	trap  'echo "Interrupted (Ctrl+C)"; exit 1' INT
	trap 'echo "Terminated"; exit 1' TERM
	trap 'echo "Error on line $LINENO"; exit 1' ERR
}

check_dependencies() {
    local deps=("cryptsetup" "gpg" "tar" "xz" "wipe" "shred" "lsblk" "fzf")
    for bin in "${deps[@]}"; do
        command -v "$bin" >/dev/null 2>&1 || echo "Missing: $bin"
    done
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
 ██▒   █▓ ▄▄▄       █    ██  ██▓  ▄▄▄█████▓                           
▓██░   █▒▒████▄     ██  ▓██▒▓██▒  ▓  ██▒ ▓▒                           
 ▓██  █▒░▒██  ▀█▄  ▓██  ▒██░▒██░  ▒ ▓██░ ▒░                           
  ▒██ █░░░██▄▄▄▄██ ▓▓█  ░██░▒██░  ░ ▓██▓ ░                            
   ▒▀█░   ▓█   ▓██▒▒▒█████▓ ░██████▒▒██▒ ░                            
   ░ ▐░   ▒▒   ▓▒█░░▒▓▒ ▒ ▒ ░ ▒░▓  ░▒ ░░                              
   ░ ░░    ▒   ▒▒ ░░░▒░ ░ ░ ░ ░ ▒  ░  ░                               
     ░░    ░   ▒    ░░░ ░ ░   ░ ░   ░                                 
      ░        ░  ░   ░         ░  ░                                  
     ░                                                                
EOF
}


[[ -f "$LOG_FILE" ]] || touch "$LOG_FILE"

advsec_menu() {
	while true; do
		choice=$(echo -e "Back\nShamir’s Secret Sharing\nIntegrity Check\nEnable 2FA Unlock" | fzf --prompt="AdvSec > ")

		case "$choice" in
			"Enable 2FA Unlock")
				while true; do
					echo "Note: YubiKey 2FA requires external setup (e.g., challenge-response mode)."
					read -rp "Enter device path (e.g., /dev/sdX1 or q to quit): " device

					if [[ "$device" =~ ^[qQ]$ ]]; then
						break
					fi

					if [[ ! -b "$device" ]]; then
						echo "Error: $device is not a valid block device. Please try again..."
						continue
					fi
				
					read -rsp "Enter your LUKS passphrase (or q to quit): " passphrase

					if [[ "$passphrase" =~ ^[qQ]$ ]]; then
						break
					fi

					if [[ -z "$passphrase" ]]; then
						echo "Error: LUKS passphrase should not be empty. Please try again..."
						continue
					fi

					if [[ -f "$ENV_FILE" ]]; then
						source "$ENV_FILE"
					fi

					if [[ -n "$CHALLENGE" ]]; then
						echo "Current challenge is set to: $CHALLENGE"
						read -rp "Do you want to change it [y/N]: " confirm
						confirm=${confirm:-N}
						if [[ "$confirm" =~ ^[yY]$ ]]; then
							read -rp "Enter a unique challenge string (or press Enter to auto-generate one): " new_challenge
							if [[ -z "$new_challenge" ]]; then
								new_challenge=$(uuidgen)
								echo "Generated challenge: $new_challenge"
							fi
							CHALLENGE="$new_challenge"

							sed -i "s/^CHALLENGE=.*/CHALLENGE=\"$CHALLENGE\"/" "$ENV_FILE"
						fi
					else
						read -rp  "Enter a unique challenge string (or press Enter to auto-generate one): " CHALLENGE
						if [[ -z "$CHALLENGE" ]]; then
							CHALLENGE=$(uuidgen)
							echo "Generated challenge: $CHALLENGE"
						fi
						echo "CHALLENGE=\"$CHALLENGE\"" >> "$ENV_FILE"
					fi

					echo "Challenge has been set to: $CHALLENGE"

					response=$(ykchalresp -2 -x "$CHALLENGE")
					if [[ -z "$response" ]]; then
						echo "Error: Failed to get challenge-response from Yubikey. Is it inserted and configured?"
						continue
					fi

					echo
					haveged -n 1024 -f /tmp/entropy
					echo -n "${passphrase}${response}" | cryptsetup luksAddKey "$device" -
					echo "2FA key slot added to $device."
					echo
					echo
				done
				read -rp "Press enter to return..."
				;;
			"Integrity Check")
				while true; do
					read -rp "Enter file or directory to verify (or q to quit): " target

					if [[ "$target" =~ ^[qQ]$ ]]; then
						break
					fi

					if [[ ! -e "$target" ]]; then
						echo "Error: $target does not exist. Please try again..."
						continue
					fi

					hashfile="$CHECKSUM_DIR/$(basename "$target")_512sum.txt"
					
					if [[ -d "$target" ]]; then
						find "$target" -type f -exec sha512sum {} \; | tee -a "$hashfile"
						echo
						echo
					else
						sha512sum "$target" | tee -a "$hashfile"
						echo
						echo
					fi

					echo -e "\n\nYou can find a copy of the hash file at $hashfile\n\n"
				done

				echo "Compare these hashes with your records."
				read -rp "Press enter to return..."
				;;
			"Shamir’s Secret Sharing")
				while true; do
					read -rp "Enter key file to split (e.g., /path/to/key or q to quit): " key_file
					
					if [[ "$key_file" =~ ^[qQ]$ ]]; then
						break
					fi
					
					if [[ ! -f "$key_file" ]]; then
						echo "Error: $key_file does not exist. Please try again..."
						continue
					fi

					read -rp "Enter number of shares (e.g., 5): " n_shares
					read -rp "Enter threshold (e.g., 3): " threshold

					if [[ ! "$n_shares" =~ ^[0-9]+$ || ! "$threshold" =~ ^[0-9]+$ || $threshold -gt $n_shares ]]; then
						echo "Error: Invalid number of shares or threshold. Please try again..."
						continue
					fi
				
					timestamp=$(date +%s)
					if [[ "$pkg_mgr" == "pacman" ]]; then
						output_file="key_${timestamp}.sss"
						echo "Using clevis-encrypt-sss for Shamir’s Secret Sharing..."
						clevis-encrypt-sss "{\"t\":$threshold,\"n\":$n_shares}" < "$key_file" > "key.sss"
					else
						output_file="key_${timestamp}.shares"
						ssss-split -t "$threshold" -n "$n_shares" -w "vault_key" < "$key_file" > "key.shares"
					fi

					echo "Key split into $n_shares shares (threshold $threshold) in $output_file."

					# Optional combine step
					if [[ "$pkg_mgr" != "pacman" ]]; then
						read -rp "Combine shares now? [y/N]: " combine
						combine=${combine:-N}
						if [[ "$combine" =~ ^[yY]$ ]]; then
							echo "Enter shares one per line (press Ctrl+D when done):"
							ssss-combine -t "$threshold" > "key_restored_${timestamp}"
							echo "Key restored to key_restored_${timestamp}."
						fi
					fi

					echo
				done
				read -rp "Press enter to return..."
				;;
			"Back"|"")
				break
				;;
		esac
	done
}

backup_menu() {
	while true; do
		choice=$(echo -e "Back\nSync Vault with Device\nExtract Archive\nArchive Vault Data" | fzf --prompt="Backup > ")

		case "$choice" in
			"Archive Vault Data")
				while true; do
					read -rp "Enter vault mount point (e.g., /mnt/vault or q to quit): " mount_point

					if [[ "$mount_point" =~ ^[qQ]$ ]]; then
						break
					fi

					if [[ ! -d "$mount_point" ]]; then
						echo "Error: $mount_point is not a valid directory. Please try again..."
						continue
					fi
				
					read -rp "Enter archive path (e.g., /backup/vault.tar.xz or q to quit): " archive_path
					if [[ -z "$archive_path" ]]; then
						echo "Error: Archive path cannot be empty. Please try again..."
						continue
					fi

					archive_dir=$(dirname "$archive_path")
					if [[ ! -d "$archive_dir" ]]; then
						read -rp "Directory $archive_dir does not exist. Create it now? [y/N]: " create_dir
						create_dir=${create_dir:-N}

						if [[ "$create_dir" =~ ^[yY]$ ]]; then
							mkdir -p "$archive_dir" || { echo "Failed to create $archive_dir"; continue; }
						else
							echo "Please enter a valid archive path."
							continue
						fi
					fi

					read -rp "Encrypt with GPG? [y/N]: " encrypt
					encrypt=${encrypt:-N}

					if [[ "$encrypt" =~ ^[yY]$ ]]; then
						read -rp "Enter GPG key ID: " key_id
						if ! gpg --list-keys "$key_id" &>/dev/null; then
							echo "Error: GPG key '$key_id' not found. Please enter a valid key."
							continue
						fi
						tar -c -C "$mount_point" | xz -z | gpg --encrypt -r "$key_id" > "$archive_path"
					else
						tar -c -C "$mount_point" . | xz -z > "$archive_path"
					fi
					echo "Vault data archived to $archive_path."
				done

				read -rp "Press enter to return..."
				;;
			"Extract Archive")
				while true; do
					read -rp "Enter archive path (e.g., /backup/vault.tar.xz or q to quit): " archive_path
					if [[ "$archive_path" =~ ^[qQ]$ ]]; then
						break
					fi

					if [[ -z "$archive_path" ]]; then
						echo "Error: Archive path cannot be empty. Please try again..."
						continue
					fi

					if [[ ! -f "$archive_path" ]]; then
						echo "Please enter a valid archive path."
						continue
					fi

					read -rp "Enter vault mount point (e.g., /mnt/vault): " mount_point
					if [[ "$mount_point" =~ ^[qQ]$ ]]; then
						break
					fi

					if [[ -z "$mount_point" ]]; then
						echo "Error: Mount point cannot be empty. Please try again..."
						continue
					fi

					if [[ ! -d "$mount_point" ]]; then
						echo "Please enter a valid mount point."
						continue
					fi
					
					read -rp "Is the archive GPG-encrypted? [y/N]: " encrypted
					encrypted=${encrypted:-N}
					if [[ "$encrypted" =~ ^[yY]$ ]]; then
						if gpg --decrypt "$archive_path" | xz -d | tar -x -C "$mount_point"; then
							echo "Archive extracted tp $mount_point."
						else
							echo "Error: Failed to extract GPG-encrypted archive."
						fi
					else
						if xz -d < "$archive_path" | tar -x -C "$mount_point"; then
							echo "Archive extracted to $mount_point."
						fi
					fi

				done
				read -rp "Press enter to return..."
				;;
			"Sync Vault with Device")
				while true; do
					read -rp "Enter source vault mount point (e.g., /mnt/vault or q to quit): " source_vault
					if [[ "$source_vault" =~ ^[qQ]$ ]]; then
						break
					fi
				      	
					read -rp "Enter destination device mount point (e.g., /mnt/backup or q to quit): " dest
					if [[ "$dest" =~ ^[qQ]$ ]]; then
						break
					fi

					if [[ ! -d "$source_vault" || ! -d "$dest" ]]; then
						echo "Error: Invalid source or destination directory."
						read -rp "Press enter to return..."
						continue
					fi

					rsync -av --progress "$source/" "$dest/"
					echo "Vault synced to $dest."
					read -rp "Press enter to return..."
					break
				done
				;;
			"Back"|"")
				break
				;;
		esac
	done
}

fs_menu() {
	while true; do
		choice=$(echo -e "Back\nShow Disk Info\nResize Vault\nFormat XFS\nFormat NTFS\nFormat ext4\nFormat FAT32/exFAT\nFormat Btrfs\nCheck Filesystem Health" | fzf --prompt="FS > ")

		case "$choice" in
			"Check Filesystem Health")
				while true; do
					read -rp "Enter device path (e.g., /dev/sdX1 or q to quit): " device
					if [[ "$device" =~ ^[qQ]$ ]]; then
						break
					fi

					if [[ ! -b "$device" ]]; then
						echo "Error: $device is not a valid block device."
						read -rp "Press enter to return..."
						continue
					fi
					
					if mount | grep -q "^$device "; then
						echo "Error: $device is already mounted."
						read -rp "Press Enter to return..."
						continue
					fi

					fs_type=$(blkid -o value -s TYPE "$device")
					case "$fs_type" in
						ext4)
							fsck.ext4 -f "$device"
							;;
						xfs)
							xfs_repair "$device"
							;;
						btrfs)
							btrfs check "$device"
							;;
						ntfs)
							ntfsfix "$device"
							;;
						*)
							echo "Error: Unsupported filesystem type: $fs_type"
							;;
					esac
				done
				read -rp "Press enter to return..."
				;;
			"Format Btrfs")
				while true; do	
					read -rp "Enter device path (e.g., /dev/sdX1): " device
					if [[ "$device" =~ ^[qQ]$ ]]; then
						break
					fi

					if [[ ! -b "$device" ]]; then
						echo "Error: $device is not a valid block device."
						read -rp "Press enter to return..."
						continue
					fi
				
					read -rp "Confirm formatting $device as Btrfs? [y/N]: " confirm
					if [[ "$confirm" =~ ^[yY]$ ]]; then
						mkfs.btrfs -f "$device"
						echo "Device $device formatted as Btrfs."
					else
						echo "Aborted."
					fi
				done
				read -rp "Press enter to return..."
				;;
			"Format FAT32/exFAT")
				while true; do
					read -rp "Enter device path (e.g., /dev/sdX1): " device
					if [[ "$device" =~ ^[qQ]$ ]]; then
						break
					fi
					if [[ ! -b "$device" ]]; then
						echo "Error: $device is not a valid block device."
						read -rp "Press enter to return..."
						continue
					fi

					read -rp "Choose filesystem (fat32/exfat or q to quit): " fs_type
					if [[ "$fs_type" =~ ^[qQ]$ ]]; then
						break
					fi

					read -rp "Confirm formatting $device as $fs_type? [y/N]: " confirm
					if [[ "$confirm" =~ ^[yY]$ ]]; then
						if [[ "$fs_type" == "fat32" ]]; then
							mkfs.vfat -F 32 "$device"
						elif [[ "$fs_type" == "exfat" ]]; then
							mkfs.exfat "$device"
						else
							echo "Error: Invalid filesystem type."
							read -rp "Press enter to return..."
							continue
						fi
						echo "Device $device formatted as $fs_type."
					else
						echo "Aborted."
					fi
				done
				read -rp "Press enter to return..."
				;;
			"Format NTFS")
				while true; do
					read -rp "Enter device path (e.g., /dev/sdX1): " device
					if [[ "$device" =~ ^[qQ]$ ]]; then
						break
					fi

					if [[ ! -b "$device" ]]; then
						echo "Error: $device is not a valid block device."
						read -rp "Press enter to return..."
						continue
					fi
				
					read -rp "Confirm formatting $device as NTFS? [y/N]: " confirm
					if [[ "$confirm" =~ ^[yY]$ ]]; then
						mkfs.ntfs -f "$device"
						echo "Device $device formatted as NTFS."
					else
						echo "Aborted."
					fi
				done
				read -rp "Press enter to return..."
				;;
			"Format XFS")
				while true; do
					read -rp "Enter device path (e.g., /dev/sdX1): " device
					if [[ "$device" =~ ^[qQ]$ ]]; then
						break
					fi

					if [[ ! -b "$device" ]]; then
						echo "Error: $device is not a valid block device."
						read -rp "Press enter to return..."
						continue
					fi
				
					read -rp "Confirm formatting $device as XFS? [y/N]: " confirm
					if [[ "$confirm" =~ ^[yY]$ ]]; then
						mkfs.xfs -f "$device"
						echo "Device $device formatted as XFS."
					else
						echo "Aborted."
					fi
				done
				read -rp "Press enter to return..."
				;;
			"Format ext4")
				while true; do
					read -rp "Enter device path (e.g., /dev/sdX1): " device
					if [[ "$device" =~ ^[qQ]$ ]]; then
						break
					fi

					if [[ ! -b "$device" ]]; then
						echo "Error: $device is not a valid block device."
						read -rp "Press enter to return..."
						continue
					fi
				
					read -rp "Confirm formatting $device as ext4? [y/N]: " confirm
					if [[ "$confirm" =~ ^[yY]$ ]]; then
						mkfs.ext4 "$device"
						echo "Device $device formatted as ext4."
					else
						echo "Aborted."
					fi
				done
				read -rp "Press enter to return..."
				;;
			"Resize Vault")
				while true; do
					read -rp "Enter device path (e.g., /dev/sdX1): " device
					if [[ "$device" =~ ^[qQ]$ ]]; then
						break
					fi

					if [[ ! -b "$device" ]]; then
						echo "Error: $device is not a valid block device."
						read -rp "Press enter to return..."
						continue
					fi
				
					read -rp "Enter new size in GiB (e.g., 10 or q to quit): " new_size
					if [[ "$new_size" =~ ^[qQ]$ ]]; then
						break
					fi

					if [[ -z "$new_size" ]]; then
						echo "Error: The size cannot be empty."
						read -rp "Press Enter to return..."
						continue
					fi

					read -rp "Confirm resizing $device to ${new_size}GiB? [y/N]: " confirm
					if [[ "$confirm" =~ ^[yY]$ ]]; then
						parted "$device" resizepart 1 "${new_size}GiB"
						read -rsp "Enter LUKS passphrase: " passphrase
						echo
						echo -n "$passphrase" | cryptsetup luksOpen "$device" vault -
						cryptsetup resize vault
						resize2fs /dev/mapper/vault
						cryptsetup luksClose vault
						echo "Vault resized to ${new_size}GiB."
					else
						echo "Aborted."
					fi
				done
				read -rp "Press enter to return..."
				;;
			"Show Disk Info")
				(lsblk -o NAME,SIZE,FSTYPE,TYPE,MOUNTPOINT,RM,ROTA,MODEL; echo; blkid; echo; df -h)
				read -rp "Press enter to return..."
				;;
			"Back"|"")
				
				break
				;;
		esac
	done
}

key_menu() {
	while true; do
		choice=$(echo -e "Back\nImport Keys\nGenerate Keys\nBackup Keys" | fzf --prompt="Keys > ")

		case "$choice" in
			"Backup Keys")
				while true; do
					read -rp "Enter GPG key ID (or q to quit): " key_id
					if [[ "$key_id" =~ ^[qQ]$ ]]; then
						break
					fi
					if [[ -z "$key_id" ]]; then
						echo "Error: GPG key ID cannot be empty."
						read -rp "Press Enter to return..."
						continue
					fi
					if ! gpg --list-keys "$key_id" &>/dev/null; then
						echo "Error: GPG key ID does not exist."
						read -rp "Press enter to return..."
						continue
					fi

					read -rp "Backup to USB or paperkey? (usb/paperkey or q to quit): " backup_type
					if [[ "$backup_type" =~ ^[qQ]$ ]]; then
						break
					fi
					if [[ -z "$backup_type" || ( "$backup_type" != "usb" && "$backup_type" != "paperkey" ) ]]; then
						echo "Error: Invalid backup type."
						read -rp "Press Enter to return..."
						continue
					fi

					if [[ "$backup_type" == "usb" ]]; then
						read -rp "Enter USB device path (e.g., /dev/sdX1 or q to quit): " device
						if [[ "$device" =~ ^[qQ]$ ]]; then
							break
						fi
						if [[ -z "$device" || ! -b "$device" ]]; then
							echo "Error: Invalid device path."
							read -rp "Press Enter to return..."
							continue
						fi
						if mount | grep -q "^$device "; then
							echo "Error: Invalid device path."
							read -rp "Press enter to return..."
							continue
						fi
				
						read -rsp "Enter LUKS passphrase for USB (or q to quit): " passphrase
						echo
						if [[ "$passphrase" =~ ^[qQ]$ ]]; then
							break
						fi
						if [[ -z "$passphrase" ]]; then
							echo "Error: LUKS passphrase should not be empty."
							read -rp "Press Enter to return..."
							continue
						fi

						echo
						echo -n "$passphrase" | cryptsetup luksOpen "$device" usb_backup -
						trap 'cryptsetup luksClose usb_backup 2>/dev/null' EXIT
						mkdir -p /mnt/usb_backup
						mount /dev/mapper/usb_backup /mnt/usb_backup
						gpg --export --armor "$key_id" > /mnt/usb_backup/key.asc
						gpg --export-secret-keys --armor "$key_id" > /mnt/usb_backup/secret_key.asc
						umount /mnt/usb_backup
						cryptsetup luksClose usb_backup
						echo "Keys backed up to USB."
					elif [[ "$backup_type" == "paperkey" ]]; then
						read -rp "Create QR code? [y/N]: " qr_choice
						qr_choice=${qr_choice:-N}
						if [[ -f paperkey.txt ]]; then
							echo "Waraning: paperkey.txt already exists and will be overwritten."
							read -rp "Contiure? [y/N]: " confirm
							confirm=${confirm:-N}
							[[ "$confirm" =~ ^[yY]$ ]] ||continue
						fi

						gpg --export-secret-keys "$key_id" | paperkey > paperkey.txt
						if [[ "$qr_choice" =~ ^[yY]$ ]]; then
							qrencode -o paperkey.png < paperkey.txt
							echo "Paperkey saved as paperkey.txt and QR code as paperkey.png."
						else
							echo "Paperkey saved as paperkey.txt."
						fi
					else
						echo "Error: Invalid backup type."
					fi
				done
				read -rp "Press enter to return..."
				;;
			"Generate Keys")
				while true; do
					read -rp "Enter key type (rsa4096/ed25519 or q to quit): " key_type
					if [[ "$key_type" =~ ^[qQ]$ ]]; then
						break
					fi
					if [[ -z "$key_type" ]]; then
						echo "Error: Key type cannot be empty."
						read -rp "Press Enter to return..."
						continue
					fi
					if [[ "$key_type" != "rsa4096" && "$key_type" != "ed25519" ]]; then
						echo "Error: Invalid key type. Choose rsa4096 or ed25519."
						read -rp "Press enter to return..."
						continue
					fi

					read -rp "Enter user ID (e.g., Name <email>): " user_id
					if [[ "$pkg_mgr" == "pacman" ]]; then
						passphrase=$(pwgen -s 32 1)
					else
						passphrase=$(apg -m 32 -x 32 -n 1)
					fi
				
					echo "Generated passphrase: $passphrase (store securely)"

					if [[ "$key_type" == "rsa4096" ]]; then
						gpg --batch --generate-key <<EOF
Key-Type: RSA
Key-Length: 4096
Subkey-Type: RSA
Subkey-Length: 4096
Name-Real: ${user_id%% <*}
Name-Email: ${user_id##* }
Expire-Date: 0
Passphrase: $passphrase
EOF
					else
						gpg --batch --generate-key <<EOF
Key-Type: eddsa
Key-Curve: ed25519
Subkey-Type: ecdh
Name-Real: ${user_id%% <*}
Name-Email: ${user_id##* }
Expire-Date: 0
Passphrase: $passphrase
EOF
					fi

					echo "Fetching new key fingerprint..."
					new_fpr=$(gpg --list-secret-keys --with-colons --fingerprint "$user_id" | awk -F: '/^fpr:/ {print $10; exit}')
					if [[ -n "$new_fpr" ]]; then
						echo "GPG keypair generated for $user_id"
						echo "Fingerprint: $new_fpr"
					else
						echo "Warning: Could not retrieve key fingerprint."
					fi

					echo "GPG keypair generated for $user_id."
				done
				read -rp "Press enter to return..."
				;;
			"Import Keys")
				while true; do
					read -rp "Import from USB or paperkey? (usb/paperkey or q to quit): " import_type
					if [[ "$import_type" =~ ^[qQ]$ ]]; then
						break
					fi
					if [[ -z "$import_type" ]]; then
						echo "Error: Import type cannot be empty."
						read -rp "Press Enter to return..."
						continue
					fi
					if [[ "$import_type" == "usb" ]]; then
						read -rp "Enter USB device path (e.g., /dev/sdX1 or q to quit): " device
						if [[ "$device" =~ ^[qQ]$ ]]; then
							break
						fi
						if [[ -z "$device" ]]; then
							echo "Error: Device path cannot be empty."
							read -rp "Press Enter to return..."
							continue
						fi
						if [[ ! -b "$device" ]]; then
							echo "Error: $device is not a valid block device."
							read -rp "Press enter to return..."
							continue
						fi
						if mount | grep -q "^$device "; then
							echo "Error: $device is already mounted."
							read -rp "Press Enter to return..."
							continue
						fi
			
						read -rsp "Enter LUKS passphrase for USB: " passphrase
						if [[ "$passphrase" =~ ^[qQ]$ ]]; then
							break
						fi
						if [[ -z "$passphrase" ]]; then
							echo "Error: LUKS passphrase should not be empty. Please try again..."
							continue
						fi
						echo

						echo -n "$passphrase" | cryptsetup luksOpen "$device" usb_backup -
						trap 'crypsetup luksClose usb_backup 2>/dev/null' EXIT

						mkdir -p /mnt/usb_backup
						mount /dev/mapper/usb_backup /mnt/usb_backup
						gpg --import /mnt/usb_backup/key.asc
						gpg --import /mnt/usb_backup/secret_key.asc
						umount /mnt/usb_backup
						cryptsetup luksClose usb_backup
						echo "Keys imported from USB."
					elif [[ "$import_type" == "paperkey" ]]; then
						read -rp "Enter paperkey file path (or q to quit): " paperkey_file
						if [[ "$paperkey_file" =~ ^[qQ]$ ]]; then
							break
						fi
						if [[ -z "$paperkey_file" ]]; then
							echo "Error: Paperkey file path cannot be empty."
							read -rp "Press Enter to return..."
							continue
						fi
						if [[ ! -f "$paperkey_file" ]]; then
							echo "Error: File does not exist."
							read -rp "Press Enter to return..."
						fi

						cat "$paperkey_file" | paperkey --secrets --output secret.gpg
						gpg --import secret.gpg
						shred -v -n 3 -u secret.gpg
						echo "Keys imported from paperkey."
					else
						echo "Error: Invalid import type."
					fi
				done
				read -rp "Press enter to return..."
				;;
			"Back"|"")
				break
				;;
		esac
	done
}

net_menu() {
	while true; do
		choice=$(echo -e "Back\nNetwork Connection Status\nForce Airgap Mode\nDisable Airgap Mode\nCheck for Mounted Devices" | fzf --prompt="Net > ")

		case "$choice" in
			"Check for Mounted Devices")
				lsblk -o NAME,MOUNTPOINT,RM | grep -v "RM.*0" | grep -E "[0-9]+ +/.*"
				if [[ $? -eq 0 ]]; then
					echo "Warning: External devices are mounted."
					echo
					echo
				else
					echo "No external devices mounted."
					echo
					echo
				fi
				read -rp "Press enter to return..."
				;;
			"Disable Airgap Mode")
				if [[ ! -f /tmp/airgap_interfaces ]]; then
					echo "No stored interfaces found. Cannot restore network."
					read -rp "Press enter to return..."
					continue
				fi
				read -rp "Press Enter to return..."
				;;
			"Force Airgap Mode")
				read -rp "Confirm disabling all network interfaces? [y/N]: " confirm
				confirm=${confirm:-N}
				if [[ "$confirm" =~ ^[yY]$ ]]; then
					nmcli networking off

					interfaces=($(ls /sys/class/net | grep -v lo))

					echo "${interfaces[@]}" > /tmp/airgap_interfaces

					wired_interfaces=()
					wireless_interfaces=()
					for intf in "${interfaces[@]}"; do
						if [[ -d "/sys/class/net/$intf/wireless" ]]; then
							wireless_interfaces+=("$intf")
						else
							wired_interfaces+=("$intf")
						fi
					done

					for intf in "${wired_interfaces[@]}"; do
						ip link set "$intf" down 2>/dev/null || true
					done

					for intf in "${wireless_interfaces[@]}"; do
						ip link set "$intf" down 2>/dev/null || true
					done

					echo "Network interfaces disabled (airgap mode enabled)."
				else
					echo "Aborted."
				fi
				read -rp "Press enter to return..."
				;;
			"Network Connection Status")
				echo
				echo "=== Network Device Status ==="

				printf "%-10s %-10s %-12s %-20s %-20s\n" "DEVICE" "TYPE" "STATE" "CONNECTION" "IP ADDRESS"
				echo "---------------------------------------------------------------------------------------"

				while read -r line; do
					dev=$(echo "$line" | awk '{print $1}')
					type=$(echo "$line" | awk '{print $2}')
					state=$(echo "$line" | awk '{print $3}')
					conn=$(echo "$line" | awk '{print $4}')

					ip_addr=$(ip -4 addr show "$dev" | awk '/inet /{print $2; exit}')
					ip_addr=${ip_addr:-"--"}

					printf "%-10s %-10s %-12s %-20s %-20s\n" "$type" "$state" "$conn" "$ip_addr"
				done < <(nmcli -t -f DEVICE,TYPE,STATE,CONNECTION dev status)

				echo
				read -rp "Press enter to return..."
				;;
			"Back"|"")
				break
				;;
		esac
	done
}

util_menu() {
	while true; do
		choice=$(echo -e "Back\nSystem Info\nHelp / Usage Tips\nClear Checksum Directory\nCheck Dependencies" | fzf --prompt="Util > ")

		case "$choice" in
			"Check Dependencies")
				missing=()
				for tool in "${required_tools[@]}"; do
					if ! command -v "$tool" &>/dev/null; then
						missing+=("$tool")
					fi
				done
				
				if [[ ${#missing[@]} -eq 0 ]]; then
					echo "All dependencies are installed."
				else
					echo "Missing dependencies: ${missing[*]}"
				fi
				read -rp "Press enter to return..."
				;;
			"Clean Checksum Directory")
				read -rp "Clean up $CHECKSUM_DIR? [y/N] " ans
				ans="${ans:-N}"
				if [[ "$ans" =~ ^[yY]$ ]]; then
					if [[ -d "$CHECKSUM_DIR" ]]; then
						echo "Cleaning up $CHECKSUM_DIR..."
						sleep 1
						shred -v -n 3 -u "$CHECKSUM_DIR"/*
						echo
						echo
						echo "Checksum directory cleaned."
						echo
						echo
					else
						echo "Error: $CHECKSUM_DIR does not exist."
					fi
				fi
				read -rp "Press Enter to return..."
				;;
			"Help / Usage Tips")
				echo "The Abyss Sysadmin Vault Usage:"
				echo "- Create Vault: Set up an encrypted USB vault with LUKS or tomb."
				echo "- Key Management: Generate, backup, or import GPG keys."
				echo "- Filesystem Tools: Format and manage filesystems (ext4, Btrfs, etc.)."
				echo "- Secure Deletion: Wipe files, free space, or entire devices."
				echo "- Network Checks: Ensure airgap mode and check for mounted devices."
				echo "- Backup: Archive or sync vault data securely."
				echo "- Advanced Security: Enable 2FA or split keys."
				read -rp "Press enter to return..."
				;;
			"System Info")
				echo "Kernel: $(uname -r)"
				echo "Distro: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'=' -f2-)"
				echo "Filesystem Support:"
				lsblk -f
				read -rp "Press enter to return..."
				;;
			"Back"|"")
				break
				;;
		esac
	done
}

wipe_menu() {
	while true; do
		choice=$(echo -e "Back\nWipe Free Space\nWipe Entire Device\nShred Files" | fzf --prompt="Wipe > ")

		case "$choice" in
			"Shred Files")
				while true; do
					read -rp "Enter file path(s) to shred (space-separated; q to quit): " input
					if [[ "$input" =~ ^[qQ]$ ]]; then
						break
					fi

					read -r -a files <<< "$input"

					invalid=0
					for file in "${files[@]}"; do
						if [[ ! -f "$file" ]]; then
							echo "Error: '$file' is not a valid file."
							invalid=1
						fi
					done
					if [[ $invalid -eq 1 ]]; then
						read -rp "Please press enter to return..."
						continue
					fi

					read -rp "Confirm shredding ${files[*]}? [y/N]: " confirm
					confirm=${confirm:-N}
					if [[ "$confirm" =~ ^[yY]$ ]]; then
						for file in "${files[@]}"; do

							if [[ "$file" == "/" || "$file" == "/etc" || "$file" == "/home" || "$file" == "/boot" ]]; then
								echo "Warning: '$file' is a protected system path. Skipping."
								continue
							fi
							
							if [[ -f "$file" ]]; then
								shred -v -n 3 -u "$file"
							else
								echo "Error: '$file' is not a valid file."
							fi
							done
							echo "Files shredded."
							echo
							echo
						else
							echo "Aborted."
					fi
				done
				read -rp "Press enter to return..."
				;;
			"Wipe Entire Device")
				while true; do
					read -rp "Enter device path (e.g., /dev/sdX or q to quit): " device
					if [[ "$device" =~ ^[qQ]$ ]]; then
						break
					fi
					if [[ ! -b "$device" ]]; then
						echo "Error: $device is not a valid block device."
						read -rp "Press enter to return..."
						continue
					fi

					read -rp "Confirm wiping $device? [y/N]: " confirm
					if mount | grep -q "^$device"; then
						echo "Warning: $device is currently mounted. Aborting for safety."
						continue
					fi

					if [[ "$confirm" =~ ^[yY]$ ]]; then
						wipe -f -q "$device" || shred -v -n 1 -z "$device"
						echo "Device $device wiped."
					else
						echo "Aborted."
					fi
				done
				read -rp "Press enter to return..."
				;;
			"Wipe Free Space")
				while true; do
					read -rp "Enter mount point (e.g., /mnt/vault or q to quit): " mount_point
					if [[ "$mount_point" =~ ^[qQ]$ ]]; then
						break
					fi
					if [[ ! -d "$mount_point" ]]; then
						echo "Error: $mount_point is not a valid directory."
						read -rp "Press enter to return..."
						continue
					fi

					case "$mount_point" in
						"/"|"/boot"|"/home"|"/etc"|"/usr"|"/var")
							echo "Error: '$mount_point' is a protected system directory. Aborting."
							read -rp "Press enter to return..."
							continue
							;;
					esac

					read -rp "Confirm securely wiping all files and free space in $mount_point? [y/N]: " confirm
					confirm=${confirm:-N}
					if [[ ! "$confirm" =~ ^[yY]$ ]]; then
						echo "Aborted."
						continue
					fi

					echo "Shredding existing files..."
					find "$mount_point" -type -f -print0 | while IFS= read -r -d '' file; do
						shred -v -n 3 -u "$file"
					done

					echo "Filling free space to wipe remaining data..."
					tmpfile="$mount_point/._wipe_tempfile_"

					dd if=/dev/zero of="$tmpfile" bs=1M status=progress 2>/dev/null || true
					shred -v -n3 -u "$tmpfile"

					echo "Free space securely wiped on $mount_point."
					read -rp "Press enter to return..."
				done
				read -rp "Press enter to return..."
				;;
			"Back"|"")
				break
				;;
		esac
	done
}

vault_menu() {
	while true; do
		choice=$(echo -e "Back\nUnmount Vault\nMount Vault\nCreate Vault\nBackup Vault Header" | fzf --prompt="Vault > ")

		case "$choice" in
			"Backup Vault Header")
				while true; do
					read -rp "Enter device path (e.g., /dev/sdX1 or q to quit): " device
					if [[ "$device" =~ ^[qQ]$ ]]; then
						break
					fi
					if [[ ! -b "$device" ]]; then
						echo "Error: $device is not a valid block device."
						read -rp "Press Enter to return..."
						continue
					fi
				
					read -rp "Enter backup file path (e.g., /backup/luks_header.bin or q to quit): " backup_file
					if [[ "$backup_file" =~ ^[qQ]$ ]]; then
						break
					fi
					if [[ -z "$backup_file" ]]; then
						echo "Error: Backup file path cannot be empty."
						read -rp "Press Enter to return..."
						continue
					fi

					mkdir -p "$(dirname "$backup_file")"
					if cryptsetup luksHeaderBackup "$device" --header-backup-file "$backup_file"; then
						echo "LUKS header successfully backed up to $backup_file."
					else
						echo "Error: Failed to back up LUKS header."
					fi
				done
				read -rp "Press enter to return..."
				;;
			"Create Vault")
				while true; do
					echo "WARNING: This will wipe and encrypt a USB device. All data will be lost!"
					read -rp "Enter device path (e.g., /dev/sdX or q to quit): " device
					if [[ "$device" =~ ^[qQ]$ ]]; then
						break
					fi
					if [[ ! -b "$device" ]]; then
						echo "Error: $device is not a valid block device."
						read -rp "Press enter to return..."
						continue
					fi
					if mount | grep -q "^$device"; then
						echo "Error: $device appears to be mounted. Unmount it first."
						read -rp "Press enter to return..."
						continue
					fi
				
					read -rp "Confirm wiping $device? [y/N]: " confirm
					confirm=${confirm:-N}
					if [[ ! "$confirm" =~ ^[yY]$ ]]; then
						echo "Aborted."
						read -rp "Press enter to return..."
						continue
					fi
				
					luks_name=$(basename "$device" | tr -cd '[:alnum:]')
					mount_point="/mnt/vault_$luks_name"

					trap 'cryptsetup luksClose "$luks_name" &>/dev/null || true' EXIT
				
					# Securely wipe the device
					echo "Step 1/7: Wiping $device (this may take a while)..."
					if command -v wipe &>/dev/null; then
						wipe -f -q "$device" || shred -v -n 1 -z "$device"
					else
						shred -v -n 1 -z "$device"
					fi
				
					# Create a single partition
					echo "Step 2/7: Creating GPT and single partition..."
					parted -s "$device" mklabel gpt mkpart primary ext4 1MiB 100%
					partprobe "$device" 2>/dev/null || true
					udevadm settle 2>/dev/null || sleep 2

					part="${device}1"
					if [[ ! -b "$part" ]]; then
						echo "Waiting for partition node to appear..."
						for i in {1..5}; do
							[[ -b "$part" ]] && break
							sleep 1
						done
					fi
					if [[ ! -b "$part" ]]; then
						echo "Error: Partition $part not found after creation."
						read -rp "Press enter to return..."
						continue
					fi
				
					# Set up LUKS encryption
					echo "Step 3/7: Setting up LUKS on $part..."
					read -rsp "Enter LUKS passphrase: " passphrase
					echo
					read -rsp "Re-enter LUKS passphrase: " passphrase2
					echo
					if [[ "$passphrase" != "$passphrase2" ]]; then
						echo "Error: Passphrases do not match."
						read -rp "Press enter to return..."
						continue
					fi

					echo -n "$passphrase" | cryptsetup luksFormat "$part" -
					echo -n "$passphrase" | cryptsetup luksOpen "$part" $luks_name -
				
					# Format LUKS container as ext4
					echo "Step 4/7: Formatting LUKS container as ext4..."
					mkfs.ext4 -F "/dev/mapper/$luks_name"

					echo "Step 5/7: Mounting vault..."
					if [[ ! -d "$mount_point" ]]; then
						mkdir -p "$mount_point"
					fi
					if mount "/dev/mapper/$luks_name" "$mount_point"; then
						echo "Vault mounted at $mount_point"
					else
						echo "Error: Failed to mount /dev/mapper/$luks_name at $mount_point"
						read -rp "Press Enter to return..."
						continue
					fi
				
					# Optionally create tomb with GPG keyfile
					if ! command -v tomb &>/dev/null; then
						echo "The tomb package was not installed due to potential security risks."
						echo "Please install tomb manually if needed."
					else
						read -rp "Use tomb with GPG keyfile? [y/N]: " use_tomb
						use_tomb=${use_tomb:-N}
						if [[ "$use_tomb" =~ ^[yY]$ ]]; then
							read -rp "Enter Tomb size (e.g., 4096M or 4G or q to quit): " tomb_size
							if [[ "$tomb_size" =~ ^[qQ]$ ]]; then
								break
							fi
							if [[ -z "$tomb_size" ]]; then
								echo "Error: Tomb size cannot be empty."
							else
								read -rp "Enter GPG key ID (or q to quit): " gpg_key
								if [[ "$gpg_key" =~ ^[qQ]$ ]]; then
									break
								fi
								if [[ -z "$gpg_key" ]]; then
									echo "Error: GPG key ID should not be empty."
									read -rp "Press Enter to return..."
									continue
								fi
								if ! gpg --list-keys "$gpg_key" &>/dev/null; then
									echo "Warning: GPG key '$gpg_key' not found in keyring. Proceeding may fail."
								fi
								tomb_file="$mount_point/vault.tomb"
								tomb_key="$mount_point/vault.tomb.key"

								echo "Step 6/7: Creating Tomb container ($tomb_size) at $tomb_file..."
								size_arg="$tomb_size"
								if [[ "$tomb_size" =~ ^([0-9+)[Gg]$ ]]; then
									size_arg=$(( ${BASH_REMATCH[1]} * 1024 ))
								elif [[ "$tomb_size" =~ ^([0-9+)[Mm]$ ]]; then
									size_arg=${BASHREMATCH[1]}
								elif [[ "$tomb_size" =~ ^[0-9]+$ ]]; then
									size_arg=$tomb_size
								else
									echo "Error: Invalid size format. Use e.g. 4096M or 4G."
									umount "$mount_point"
									read -rp "Press enter to return..."
									continue
								fi

							tomb dig -s "$size_arg" "$tomb_file"

							echo "Forging Tomb keyfile from GPG key '$gpg_key'..."
							tomb forge "$tomb_key" -r "$gpg_key"

							echo "Locking Tomb with keyfile (will prompt for GPG if needed)..."
							echo -n "$passphrase" | tomb lock "$tomb_file" -k "tomb_key" -g -f

							echo "Tomb created at: $tomb_file"
							echo "Tomb keyfile at: $tomb_key"
							fi
						fi
					fi

					echo "Step 7/7: Finalizing..."
					sync

					read -rp "Leave the vault mounted at $mount_point? [Y/n]: " leave_mounted
					leave_mounted=${leave_mounted:-Y}
					if [[ ! "$leave_mounted" =~ ^[Yy]$ ]]; then
						if umount "$mount_point"; then
							echo "Vault unmounted."
						else
							echo "Warning: Failed to unmont $mount_point (it may be busy)."
						fi
						
						if cryptsetup luksClose "$luks_name"; then
							echo "LIKS mapping '$luks_name' closed."
						else
							echo "Warning: Could not close LUKS mapping '$luks_name' (it may still be in use)."
						fi
					else
						echo "Vault remains mounted at $mount_point (mapping: $luks_name)."
					fi

					trap - EXIT
					
					echo "Vault creation complete on $part."
					read -rp "Press enter to return..."
					break
				done
				;;
			"Mount Vault")
				while true; do
					read -rp "Enter device path (e.g., /dev/sdX1 or q to quit): " device
					if [[ "$device" =~ ^[qQ]$ ]]; then
						break
					fi
					if [[ ! -b "$device" ]]; then
						echo "Error: $device is not a valid block device."
						read -rp "Press enter to return..."
						continue
					fi
  
					read -rp "Is this a tomb vault? [y/N]: " is_tomb
					is_tomb=${is_tomb:-N}

					if [[ "$is_tomb" =~ ^[yY]$ ]]; then
						if ! command -v tomb &>/dev/null; then
							echo "The tomb package was not installed due to potential security risks."
							echo "Please install tomb manually if needed."
						else
							read -rp "Enter tomb file path (e.g., /vault.tomb or q to quit): " tomb_file
							if [[ "$tomb_file" =~ ^[qQ]$ ]]; then
								break
							fi
							if [[ ! -f "$tomb_file" || -z "$tomb_file" ]]; then
								echo "Error: Invalid file path."
								read -rp "Press Enter to return..."
								continue
							fi

							read -rp "Enter GPG keyfile path (e.g., /vault.tomb.key or q to quit): " tomb_key
							if [[ "$tomb_key" =~ ^[qQ]$ ]]; then
								break
							fi
							if [[ ! -f "$tomb_key" || -z "$tomb_key" ]]; then
								echo "Error: Invalid GPG keyfile path."
								read -rp "Press Enter to return..."
								continue
							fi
							
							tomb open "$tomb_file" -k "$tomb_key" -g
							echo "Tomb vault opened successfully."
							break
						fi
					else
						read -rsp "Enter LUKS passphrase: " passphrase
						echo

						luks_name=$(basename "$device" | tr -cd '[:alnum:]')

						echo -n "$passphrase" | cryptsetup luksOpen "$device" "$luks_name" -
					
						mount_point="/mnt/vault_$luks_name"
						mkdir -p "$mount_point"

						if mount "/dev/mapper/$luks_name" "$mount_point"; then
							echo "Vault mounted at $mount_point (device mapping: $luks_name)."
						else
							echo "Failed to mount LUKS vault."
						fi
						break
					fi
				done
				echo
				echo
				read -rp "Press enter to return..."
				;;
			"Unmount Vault")
				read -rp "Is this a tomb vault? [y/N]: " is_tomb
				is_tomb=${is_tomb:-N}

				if [[ "$is_tomb" =~ ^[yY]$ ]]; then
					if ! command -v tomb &>/dev/null; then
						echo "The tomb package was not installed due to potential security risks."
						echo "Please install tomb manually if needed."
					else
						echo "Closing tomb vault..."
						echo
						echo
						if tomb close &>/dev/null; then
							echo "Tomb vault successfully closed."
						else
							echo "Failed to close the tomb vault or it was not open."
						fi
					fi
				else
					echo "Unmounting vault..."
					if umount /mnt/vault 2>/dev/null; then
						echo "Vault successfully unmounted."
					else
						echo "Vault was not mounted or could not be unmounted."
					fi

					if cryptsetup luksClose vault 2>/dev/null; then
						echo "LUKS vault successfully closed."
					else
						echo "LIKS vault was not open or could not be closed."
					fi
				fi
				read -rp "Press enter to return..."
				;;
			"Back"|"")
				break
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
