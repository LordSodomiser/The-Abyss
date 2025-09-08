#!/usr/bin/env bash
# The Abyss Sysadmin Toolbox
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

exclaim() { echo -e "\033[1;34m[*]\033[0m $*"; }
warn() { echo -e "\033[1;33m[!]\033[0m $*" >&2; }
die() { echo -e "\033[1;31[x]\033[0m $*" >&2; exit 1; }

ENV_FILE="/opt/The-Abyss/abyss-toolbox/.configs/.env"
if [[ -f "$ENV_FILE" ]]; then
	source "$ENV_FILE"
else
	warn "No .env file found at $ENV_FILE"
fi

: "${SOURCE_SCRIPT:=/opt/The-Abyss/abyss-toolbox/.configs/.env}"

log() {
	echo "$(date '+%Y-%m-%d %H:%M:%S') - $ABYSS_USER - $*" >> "$LOG_FILE"
}

setup_traps() {
	trap  'echo "Interrupted (Ctrl+C)"; exit 1' INT
	trap 'echo "Terminated"; exit 1' TERM
	trap 'echo "Error on line $LINENO"; exit 1' ERR
}

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
				exclaim "$target is a directory, using rm -rf"
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
The Abyss Sysadmin Toolbox

Usage:
	cystoolbox [command] [options]

Commands:
	--help			Show this help message
	--update		Update The Abyss Sysadmin Toolbox
	--uninstall		Uninstall The Abyss Sysadmin Toolbox
EOF
}

update_cystoolbox() {
	exclaim "Updating The Abyss Sysadmin Toolbox"
	log "$ABYSS_USER is attempting to update The Abyss Sysadmin Toolbox"
	local repo_url="https://github.com/LordSodomiser/The-Abyss.git"
	local install_dir="/opt/The-Abyss"
	local toolbox_dir="$install_dir/abyss-toolbox"
	local pkg_file="$toolbox_dir/installed-pkgs.txt"
	local env_file="$toolbox_dir/.configs/.env"
	local default_branch="${DEFAULT_BRANCH:-main}"
	local pkg_mgr_found=""
	local pkg_install=""
	local missing_tools=()
	local missing_packages=()
	local required_tools=(
		awk cat cd clamscan cifs cp cfdisk df du find free fzf git grep hostname
		htop ifconfig ip journalctl less ls lsblk lscpu lsmem mount mv netstat
		nmtui nslookup parted ping ps rkhunter rm smartctl smbclient service shred
		sudo systemctl top ufw umount uname uptime vmstat which who
	)
	declare -A tool_to_package=(
		["awk"]="gawk" ["cat"]="coreutils" ["cd"]="coreutils" ["clamscan"]="clamav" ["cifs"]="cifs-utils"
		["cp"]="coreutils" ["cfdisk"]="util-linux" ["df"]="coreutils" ["du"]="coreutils" ["find"]="findutils"
		["free"]="procps-ng" ["fzf"]="fzf" ["git"]="git" ["grep"]="grep" ["hostname"]="inetutils"
		["htop"]="htop" ["ifconfig"]="net-tools" ["ip"]="iproute2" ["journalctl"]="systemd"
		["less"]="less" ["ls"]="coreutils" ["lsblk"]="util-linux" ["lscpu"]="util-linux" ["lsmem"]="util-linux"
		["mount"]="util-linux" ["mv"]="coreutils" ["netstat"]="net-tools" ["nmtui"]="networkmanager"
		["nslookup"]="bind" ["parted"]="parted" ["ping"]="inetutils" ["ps"]="procps-ng" ["rkhunter"]="rkhunter"
		["rm"]="coreutils" ["service"]="initscripts" ["shred"]="coreutils" ["smartctl"]="smartmontools"
		["smbclient"]="samba" ["sudo"]="sudo" ["systemctl"]="systemd" ["top"]="procps-ng" ["ufw"]="ufw"
		["umount"]="util-linux" ["uname"]="coreutils" ["uptime"]="coreutils" ["vmstat"]="procps-ng"
		["which"]="coreutils" ["who"]="coreutils"
	)

	if [[ -f "$env_file" ]]; then
		source "$env_file"
	else
		warn "No .env file found at $env_file"
	fi

	for mgr in apk apt conda dnf emerge nix-env pacman pkg pkg_add pkgin slackpkg spack yum zypper; do
		if command -v "$mgr" >/dev/null 2>&1; then
			log "Detected $mgr package manager..."
			pkg_mgr_found="$mgr"
			case "$mgr" in
				apk) pkg_install="sudo apk add" ;;
				apt) pkg_install="sudo apt install -y" ;;
				conda) pkg_install="conda install -c conda-forge" ;;
				dnf|yum) pkg_install="sudo $mgr install -y" ;;
				emerge) pkg_install="sudo emerge --ask n" ;;
				nix-env) pkg_install="nix-env -iA" ;;
				pacman) pkg_install="sudo pacman -S --noconfirm" ;;
				pkg) pkg_install="sudo pkg install" ;;
				pkg_add) pkg_install="sudo pkg_add" ;;
				pkgin) pkg_install="sudo pkgin install" ;;
				slackpkg) pkg_install="sudo slackpkg install -batch=on" ;;
				spack) pkg_install="spack install" ;;
				zypper) pkg_install="sudo zypper install --non-interactive" ;;
			esac
			break
		fi
	done

	if [[ -z "$pkg_mgr_found" ]]; then
		die "Unknown package manager. Please install required tools manually."
	fi

	for tool in "${required_tools[@]}"; do
		if [[ "$tool" == "cifs" ]]; then
			if mount --help | grep -q "cifs" || modinfo cifs >/dev/null 2>&1; then
				log "CIFS support is installed"
			else
				log "CIFS support is not installed"
				missing_tools+=("$tool")
				missing_packages+=("${tool_to_package[$tool]}")
			fi
		elif [[ "$tool" == "mount_smbfs" ]]; then
			if command -v mount_smbfs >/dev/null 2>&1 || kldstat | grep -q smbfs >/dev/null 2>&1; then
				log "mount_smbfs support is installed"
			else
				log "mount_smbfs support is not installed"
				missing_tools+=("$tool")
				missing_packages+=("${tool_to_package[$tool]}")
			fi
		elif [[ "$tool" != "rcctl" || "$pkg_mgr_found" == "pkg_add" ]]; then
			if ! command -v "$tool" >/dev/null 2>&1; then
				missing_tools+=("$tool")
				if [[ -n "${tool_to_package[$tool]}" ]]; then
					missing_packages+=("${tool_to_package[$tool]}")
				else
					warn "No package mapping for $tool, skipping"
				fi
			fi
		fi
	done

	if [[ ${#missing_tools[@]} -gt 0 ]]; then
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
				[[ -d "$toolbox_dir" ]] || sudo mkdir -p "$toolbox_dir" || die "Failed to create directory $toolbox_dir"
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
			exclaim "No packages to install."
		fi
	else
		exclaim "All required tools are already installed."
	fi

	if ! command -v git >/dev/null 2>&1; then
		die "git is not installed. Please install git to use the update feature."
	fi

	if [[ ! -d "$install_dir/.git" ]]; then
		die "Toolbox repository not found at $install_dir"
	fi

	exclaim "Marking $install_dir as safe for Git operations..."
	git config --global --add safe.directory "$install_dir" | warn "Failed to mark $install_dir as safe directory, but continuing..."

	cd "$install_dir" || die "Could not access $install_dir"

	if [[ -n "$(git status --porcelain)" ]]; then
		warn "Uncommitted changes detected. They will be overwritten."
		read -rp "Continue with update? [y/N]: " ans
		ans=${ans:-N}
		[[ "$ans" =~ ^[yY]$ ]] || die "Update aborted by user"
	fi

	exclaim "Fetching updates from $repo_url ..."
	git fetch --all || die "Failed to fetch updates"
	git reset --hard origin/$default_branch || die "Failed to reset to origin/$default_branch"

	if [[ -f "$env_file" ]]; then
		source "$env_file"
		log "Re-sourced .env file after update."
	else
		warn "No .env file found at $env_file after update."
	fi

	exclaim "The Abyss Sysadmin Toolbox updated successfully"
	log "$ABYSS_USER successfully updated The Abyss Sysadmin Toolbox"
}

uninstall_cystoolbox() {
	local repo_dir="${TOOLBOX_PATH:-/opt/The-Abyss/abyss-toolbox}"
	local launcher="${LAUNCHER:-/usr/local/bin/cystoolbox}"
	local env_file="${ENV_FILE:-/opt/The-Abyss/abyss-toolbox/.configs/.env}"

	exclaim "Initiating uninstallation of The Abyss Sysadmin Toolbox"
	log "$ABYSS_USER initiated the uninstallation of The Abyss Sysadmin Toolbox"
	read -rp "The tools may be gone, but the stain of the oath remains. Shall we beghin the purge? [y/N]: " ans
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
		die "No installed packages file found at $LOG_INSTALLED_PKGS"
	fi
	
	declare -a INSTALLED_PKG_LIST
	while IFS=read -r pkg; do
		[[ -n "$pkg" ]] && INSTALLED_PKG_LIST+=("$pkg")
	done < "$LOG_INSTALLED_PKGS"

	if pgrep -f "toolbox.sh" >/dev/null; then
		exclaim "Stopping runnning toolbox processes..."
		pkill -f "toolbox.sh" 2>/dev/null || warn "Failed to halt some toolbox processes"
	fi

	secure_shred "$launcher"
	secure_shred "$env_file"

	if [[ -d "$repo_dir" ]]; then
		exclaim "Securely removing repo at $repo_dir ..."
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

	log "All packages that were installed for the toolbox have been uninstalled."
	sleep 1

	log "The Abyss Sysadmin Toolbox has been uninstalled..."

	betrayal_banner

	sleep 2

	log "The Abyss Sysadmin Toolbox has been completely uninstalled."
	log "You may need to manually remove references to cystoolbox from your shell configuration (e.g., .bashrc, .zshrc)."

	exit 0
}

handling() {
	case "${1:-}" in
		--help|-h)
			show_help
			exit 0
			;;
		--update)
			update_cystoolbox
			exit 0
			;;
		--uninstall)
			uninstall_cystoolbox
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

check_clamav() {
	if ! command -v clamscan >/dev/null || ! command -v freshclam >/dev/null; then
		echo "ClamAV tools not found. Please install ClamAV before scanning."
		read -rp "Press enter to return..."
		return 1
	fi

	[ ! -d /var/lib/clamav ] && mkdir -p /var/lib/clamav && chown clamav:clamav /var/lib/clamav

	[ ! -d /var/log/The-Abyss ] && mkdir -p /var/log/The-Abyss

	return 0
}

disk_mgmt() {
	while true; do
		choice=$(echo -e "Back\nShow Drive UUID\nRun cfdisk\nManage Partitions\nUnmount SMB or Device\nMount SMB or Device\nList Block Devices\nCheck Disk Usage\nCheck Disk Free Space" | fzf)

		case "$choice" in
			"Check Disk Free Space")
				cmd="df -h"
				log "$ABYSS_USER viewed disk info using '$cmd'"
				echo "[$ABYSS_USER@$HOST]$ $cmd"
				echo
				echo
				$cmd 2>&1 | tee -a "$LOG_FILE"
				sleep 1
				echo
				echo
				read -rp "Press enter to return..."
				;;
			"Check Disk Usage")
				while true; do
					path_choice=$(echo -e "Back\nRoot Disk\nCustom Path\nAll Mounted Filesystems" | fzf)
				
					case "$path_choice" in
						"All Mounted Filesystems")
							cmd="df -h"
							log "$ABYSS_USER viewed disk usage using $cmd"
							echo "[$ABYSS_USER@$HOST]$ $cmd"
							echo
							echo
							$cmd 2>/dev/null | tee -a "$LOG_FILE"
							sleep 1
							echo
							echo
							read -rp "Press enter to return..."
							;;
						"Custom Path")
							while true; do
								read -rp "Enter directory path to check (Press Enter for current directory or q to quit): " path
								if [[ "$path" =~ ^[qQ]$ ]]; then
									break
								fi

								path=${path:-.}
								if [[ -d "$path" ]]; then
									cmd="du -h --max-depth=1"
									log "$ABYSS_USER viewed disk usage using '$cmd'"
									echo "[$ABYSS_USER@$HOST]$ $cmd"
									echo
									echo
									$cmd "$path" 2>/dev/null | sort -h | tee -a "$LOG_FILE"
									sleep 1
									echo
									echo
									read -rp "Press enter to return..."
								else
									echo "Invalid directory: $path"
									sleep 2
								fi
							done
							read -rp "Press enter to return..."
							;;
						"Root Disk")
							path="/"
							cmd="df -h $path"
							log "$ABYSS_USER viewed disk usage using '$cmd'"
							echo "[$ABYSS_USER@$HOST]$ $cmd"
							echo
							echo
							$cmd 2>/dev/null | tee -a "$LOG_FILE"
							sleep 1
							echo
							echo
							read -rp "Press enter to return..."
							;;
						"Back"|"")
							break
							;;
					esac
				done
				;;
			"List Block Devices")
				cmd="lsblk"
				log "$ABYSS_USER viewed disk info using '$cmd'"
				echo "[$ABYSS_USER@$HOST]$ $cmd"
				echo
				echo
				$cmd 2>&1 | tee -a "$LOG_FILE"
				sleep 1
				echo
				echo

				echo "You can either mount a device to an existing mount point,"
				echo "create a new one, or unmount a device."

				read -rp "Would you like to mount or unmount a device? (mount/unmount or q to quit): " mount_ans
				mount_ans=${mount_ans:-q}
				if [[ "$mount_ans" =~ ^[qQ]$ ]]; then
					break
				fi

				if [[ "$mount_ans" == "mount" ]]; then
					read -rp "Do you want to create the mount point in the /mnt dir? (Y/n): " ans
					ans=${ans:-Y}

					if [[ "$ans" =~ ^([yY]|[Yy][Ee][Ss])$ ]]; then
						read -rp "Name the mount point for /mnt/... (e.g., usb, nas): " name
						if [[ -n "$name" ]]; then
							mkdir -p "/mnt/$name"
							mount_target="/mnt/$name"
						else
							echo "No name provided. Please try again..."
							continue
						fi
					elif [[ "$ans" =~ ^[nN]$ ]]; then
						while true; do
							read -rp "Do you want to use an existing mount point? (Y/n): " ans
							ans=${ans:-Y}
							
							if [[ "$ans" =~ ^[yY]$ ]]; then
								read -rp "To use an existing mount point enter it now. (e.g., /mnt/usb): " ex_mount
								if [[ -n "$ex_mount" && -d "$ex_mount" ]]; then
									mount_target="$ex_mount"
									echo "Mount target set to $mount_target"
									skip_new_mount_prompt=true
									break
								else
									echo "Invalid or no path provided. Please try again..."
									continue
								fi		
							else
								echo "Returning to menu..."
								sleep 2
								break
							fi
						done
					fi
					
					if [[ -z "$mount_target" && "$skip_new_mount_prompt" != "true" ]]; then
						read -rp "Do you want to create a new mount point? (y/N): " ans
						if [[ "$ans" =~ ^[yY]$ ]]; then
							read -rp "Enter full path for new mount point (e.g., /new/mount/point): " newmount
							if [[ -n "$newmount" ]]; then
								mkdir -p "$newmount"
								mount_target="$newmount"
							else
								echo "No path provided. Please try again..."
								continue
							fi
						else
							echo "No mount point selected. Please try again..."
							continue
						fi
					fi
				elif [[ "$mount_ans" == "unmount" ]]; then
					read -rp "Enter full path to unmount (e.g., /mnt/usb or q to quit): " unmount_point
					unmount_point=${unmount_point:-q}
					if [[ "$unmount_point" =~ ^[qQ]$ ]]; then
						break
					fi

					if [[ -d "$unmount_point" ]]; then
						cmd="umount $unmount_point"
						log "$ABYSS_USER used '$cmd' to unmount $unmount_point"
						echo
						echo
						echo "[$ABYSS_USER@$HOST]$ $cmd"
						$cmd 2>&1 | tee -a "$LOG_FILE" || true
						sleep 1
						echo
						echo
					else
						echo "Invalid or non-existent path. Please try again..."
						continue
					fi
				fi

				read -rp "Would you like to mount an SMB network share or device? (smb/device or q to quit): " mount_type
				mount_type=${mount_type:-q}
				if [[ "$mount_type" =~ ^[qQ] ]]; then
					break
				fi

				if [[ "$mount_type" == "smb" ]]; then
					read -rp "Do you have an existing SMB credential file? [y/N]: " ans
					ans=${ans:-N}

					if [[ "$ans" =~ ^[nN]$ ]]; then

					echo "Please create your credential file..."
					read -rp "Please enter your SMB share UID (default uid=${SUDO_UID:-$(id -u)}): " uid
					uid=${uid:-${SUDO_UID:-$(id -u)}}

					read -rp "Please enter your SMB share GID (default gid=${SUDO_GID:-$(id -g)}): " gid
					gid=${SUDO_GID:-$(id -g)}

					read -rp "Please enter your SMB share username: " username
					while true; do
						read -rsp "Please enter your SMB share password: " password; echo
						read -rsp "Please confirm your SMB share password: " conf_pass; echo
						if [[ ! "$password" == "$conf_pass" ]]; then
							echo "Warning: Passwords do not match. Please try again..."
							continue
						else
							break
						fi
					done
					read -rp "Please enter your SMB share domain (optional): " domain
					read -rp "Where would you like to put the credentials file? (default /home/$ABYSS_USER/.smbcred): " smb_cred_loc
					smb_cred_loc=${smb_cred_loc:-/home/$ABYSS_USER/.smbcred}
		
					if [[ -n "$username" && -n "$password" && -n "$smb_cred_loc" ]]; then
						cat <<EOF | tee "$smb_cred_loc" > /dev/null
username=$username
password=$password
$( [[ -n "$domain" ]] && echo "domain=$domain" )
EOF
							chown $ABYSS_USER:$ABYSS_USER "$smb_cred_loc"	
							chmod 600 "$smb_cred_loc"
						
							read -rp "Enter SMB share path (e.g., //server/share): " smb_share
							if [[ -n "$smb_share" && -d "$mount_target" ]]; then
								cmd="mount -t cifs $smb_share $mount_target -o credentials=$smb_cred_loc,uid=$uid,gid=$gid,rw,vers=3.0"
								log "$ABYSS_USER mounted SMB share using $cmd"
								echo
								echo "[$ABYSS_USER@$HOST]$ $cmd"
								$cmd 2>&1 | tee -a "$LOG_FILE"
								sleep 1
								echo
								echo

								read -rp "Do you want to add this SMB mount to fstab? (y/N): " fstab
								if [[ "$fstab" =~ ^[yY]$ ]]; then
									entry="$smb_share $mount_target cifs credentials=$smb_cred_loc,uid=$uid,gid=$gid,x-systemd.automount 0 0"
									echo "$entry" | tee -a /etc/fstab
									log "$ABYSS_USER added SMB mount to fstab"
									systemctl daemon-reload
									mount -a
									echo
									echo
								fi
							else
								echo "Invalid SMB share or mount point. Please try again..."
								continue
							fi
						else
							echo "Missing credentials info. Please try again..."
							continue
						fi
					elif [[ "$ans" =~ ^[yY]$ ]]; then
						read -rp "Please enter the correct existing SMB credential file now (or q to quit): " ex_creds
						ex_creds=${ex_creds=:-q}
						if [[ "$ex_creds" =~ ^[qQ]$ ]]; then
							break
						fi

						if [[ -n "$ex_creds" && -f "$ex_creds" ]]; then
							read -rp "Please enter your SMB share UID (default uid=${SUDO_UID:-$(id -u)}): " uid
							uid=${uid:-${SUDO_UID:-$(id -u)}}
							read -rp "Please enter your SMB share GID (default gid=${SUDO_GID:-$(id -g)}): " gid
							gid=${gid:-${SUDO_GID:-$(id -g)}}
							read -rp "Enter SMB share path (e.g., //server/share): " smb_share
							if [[ -n "$smb_share" && -d "$mount_target" ]]; then
							cmd="mount -t cifs $smb_share $mount_target -o credentials=$ex_creds,uid=$uid,gid=$gid,rw,vers=3.0"
							       log "$ABYSS_USER mounted SMB share using $cmd"
							       echo
							       echo "[$ABYSS_USER@$HOST]$ $cmd"
							       $cmd 2>&1 | tee -a "$LOG_FILE"
							       sleep 1
							       echo
							       echo
						
							       read -rp "Do you want to add this SMB mount to fstab? (y/N): " fstab
							       if [[ "$fstab" =~ ^[yY]$ ]]; then
								       entry="$smb_share $mount_target cifs credentials=$ex_creds,uid=$uid,gid=$gid,x-systemd.automount 0 0"
								       echo "$entry" | tee -a /etc/fstab
								       log "$ABYSS_USER added SMB mount to fstab"
								       systemctl daemon-reload
								       mount -a
								       echo
								       echo
							       fi
						       else
							       echo "Invalid SMB share or mount point. Please try again..."
							       continue
						       fi
					       else
						       echo "Invalid SMB share, mount point or credential file path. Please try again...."
						       continue
						fi
					fi
				elif [[ "$mount_type" == "device" ]]; then
				       	read -rp "Enter device path (e.g., /dev/sda1, /dev/nvme0n1 or q to quit): " device
					device=${device:-q}
					if [[ "$device" =~ ^[qQ]$ ]]; then
						break
					fi

					if [[ -b "$device" && -d "$mount_target" ]]; then
						cmd="mount $device $mount_target"
						log "$ABYSS_USER mounted drive using $cmd"
						echo -e "\n[$ABYSS_USER@$HOST]$ $cmd"
						$cmd 2>&1 | tee -a "$LOG_FILE"
						sleep 1
						echo

						read -rp "Do you want to add the mount point to your fstab? (y/N): " fstab
						if [[ "$fstab" =~ ^[yY]$ ]]; then
							uuid=$(blkid -s UUID -o value "$device")
							fs_type=$(blkid -s TYPE -o value "$device")
							if [[ -n "$uuid" && -n "$fs_type" ]]; then
								entry="UUID=$uuid $mount_target $fs_type defaults 0 2"
								echo "$entry" | tee -a /etc/fstab
								log "$ABYSS_USER added $device mount to fstab"
								systemctl daemon-reload
								mount -a
								echo
								echo
							else
								echo "Could not retrieve UUID or filesystem type. Please try again..."
								continue
							fi
						fi
					else
						echo "Invalid device or mount point. Please try again..."
						continue
					fi
				else
					echo "Invalid mount point. Please try again..."
					continue
				fi

				echo
				echo
				read -rp "Press enter to return..."
				;;
			"Manage Partitions")
				while true; do
					read -rp "Enter device path (e.g., /dev/sda, /dev/nvme0n1 or q to quit): " device
					device=${device:-q}
					if [[ "$device" =~ ^[qQ]$ ]]; then
						break
					fi
					if mount | grep -q "^$device[0-9]"; then
						echo "Warning: $device is mounted. Please unmount $device before managing partitions..."
						read -rp "Press Enter to return..."
						break
					fi

					if [[ -b "$device" ]]; then
						cmd="parted \"$device\""
						log "$ABYSS_USER managed partitions using '$cmd'"
						echo
						echo
						echo "[$ABYSS_USER@$HOST]$ $cmd"
						$cmd
						sleep 1
						echo
						echo
						read -rp "Press enter to return..."
					else
						echo "Invalid device: $device"
						sleep 2
					fi
				done
				;;
			"Mount SMB or Device")
				while true; do
					unset skip_new_mount_prompt
					mount_target=""

					read -rp "Would you like to mount an SMB share or device? [Y/n] (or q to quit): " choice
					if [[ "$choice" =~ ^[qQ]$ ]]; then
						break
					fi

					choice=${choice:-Y}
					if [[ "$choice" =~ ^([yY]|[Yy][Ee][Ss])$ ]]; then
						read -rp "Do you want to create the mount point in the /mnt dir? [Y/n]: " ans
						ans=${ans:-Y}

						if [[ "$ans" =~ ^([yY]|[Yy][Ee][Ss])$ ]]; then
							read -rp "Name the mount point for /mnt/... (e.g., usb, nas or q to quit): " name
							name=${name:-q}
							if [[ "$name" =~ ^[qQ]$ ]]; then
								break
							fi

							if [[ -n "$name" ]]; then
								mkdir -p "/mnt/$name"
								mount_target="/mnt/$name"
							else
								echo "No name provided. Please try again..."
								continue
							fi
						elif [[ "$ans" =~ ^[nN]$ ]]; then
							while true; do
								read -rp "Do you want to use an existing mount point? [Y/n] (or q to quit): " ans
								if [[ "$ans" =~ ^[qQ]$ ]]; then
									break
								fi
								ans=${ans:-Y}
	
								if [[ "$ans" =~ ^[yY]$ ]]; then
									read -rp "To use an existing mount point enter it now. (e.g., /mnt/usb or q to quit): " ex_mount
									ex_mount=${ex_mount:-q}
									if [[ "$ex_mount" =~ ^[qQ]$ ]]; then
										break
									fi

									if [[ -n "$ex_mount" && -d "$ex_mount" ]]; then
										mount_target="$ex_mount"
										echo "Mount target set to $mount_target"
										skip_new_mount_prompt=true
										break
									else
										echo "Invalid or no path provided. Please try again..."
										continue
									fi
								else
									echo "Returning to menu..."
									sleep 2
									break
								fi
							done
						fi

						if [[ -z "$mount_target" && "$skip_new_mount_prompt" != "true" ]]; then
							read -rp "Do you want to create a new mount point? [y/N] (or q to quit): " ans
							if [[ "$ans" =~ ^[qQ]$ ]]; then
								break
							fi
							ans=${ans:-N}

							if [[ "$ans" =~ ^[yY]$ ]]; then
								read -rp "Enter full path for new mount point (e.g., /new/mount/point): " newmount
								if [[ -n "$newmount" ]]; then
									mkdir -p "$newmount"
									mount_target="$newmount"
								else
									echo "No path provided. Please try again..."
									continue
								fi
							else
								echo "No mount point selected. Please try again..."
								continue
							fi
						fi
					fi
	
						read -rp "Would you like to mount an SMB network share or device? (smb/device or q to quit): " mount_type
					mount_type=${mount_type:-q}
					if [[ "$mount_type" =~ ^[qQ]$ ]]; then
						break
					fi

					if [[ "$mount_type" == "smb" ]]; then
						read -rp "Do you have an existing SMB credential file? [y/N]: " ans
						ans=${ans:-N}
	
						if [[ "$ans" =~ ^[nN]$ ]];then
							echo "Please create your credential file..."
							read -rp "Please enter your SMB share UID (default uid=${SUDO_UID:-$(id -u)}): " uid
							uid=${uid:-${SUDO_UID:-$(id -u)}}
	
							read -rp "Please enter your SMB share GID (default gid=${SUDO_GID:-$(id -g)}): " gid
							gid=${gid:-${SUDO_GID:-$(id -g)}}

							read -rp "Please enter your SMB share username: " username
							while true; do
								read -rsp "Please enter your SMB share password: " password; echo
								read -rsp "Please confirm your SMB share password: " conf_pass; echo
								if [[ ! "$password" == "$conf_pass" ]]; then
									echo "Warning: Passwords do not match. Please try again..."
									continue
								else
									break
								fi
							done

							read -rp "Please enter your SMB share domain (optional): " domain
							read -rp "Where would you like to put the credentials file? (default /home/$ABYSS_USER/.smbcred): " smb_cred_loc
							smb_cred_loc=${smb_cred_loc:-/home/$ABYSS_USER/.smbcred}

							if [[ -n "$username" && -n "$password" && -n "$smb_cred_loc" ]]; then
								cat <<EOF | tee "$smb_cred_loc" > /dev/null
username=$username
password=$password
$( [[ -n "$domain" ]] && echo "domain=$domain" )
EOF
									chown $ABYSS_USER:$ABYSS_USER "$smb_cred_loc"
									chmod 600 "$smb_cred_loc"

									read -rp "Enter SMB share path (e.g., //server/share or q to quit): " smb_share
									smb_share=${smb_share:-q}
									if [[ "$smb_share" =~ ^[qQ]$ ]]; then
										break
									fi

									if [[ -n "$smb_share" && -d "$mount_target" ]]; then
										cmd="mount -t cifs $smb_share $mount_target -o credentials=$smb_cred_loc,uid=$uid,gid=$gid,rw,vers=3.0"
										log "$ABYSS_USER mounted SMB share using $cmd"
										echo
										echo "[$ABYSS_USER@$HOST]$ $cmd"
										$cmd
										sleep 1
										echo
										echo
	
										read -rp "Do you want to add this SMB mount to fstab? (y/N): " fstab
										if [[ "$fstab" =~ ^[yY]$ ]]; then
											entry="$smb_share $mount_target cifs credentials=$smb_cred_loc,uid=$uid,gid=$gid,x-systemd.automount 0 0"
											echo "$entry" | tee -a /etc/fstab
											log "$ABYSS_USER added SMB mount to fstab"
											systemctl daemon-reload
											mount -a
											echo
											echo
										fi
									else
										echo "Invalid SMB share or mount point. Please try again..."
										continue
									fi
								else
									echo "Missing credentials info. Please try again..."
									continue
								fi
							elif [[ "$ans" =~ ^[yY]$ ]]; then
								read -rp "Please enter the correct existing SMB credential file now (or q to quit): " ex_creds
								ex_creds=${ex_creds:-q}
								if [[ "$ex_creds" =~ ^[qQ]$ ]]; then
									break
								fi

								if [[ -n "$ex_creds" && -f "$ex_creds" ]]; then
									read -rp "Please enter your SMB share UID (default uid=${SUDO_UID:-$(id -u)}): " uid
									uid=${uid:-${SUDO_UID:-$(id -u)}}
									read -rp "Please enter your SMB share GID (default gid=${SUDO_GID:-$(id -g)}): " gid
									gid=${gid:-${SUDO_GID:-$(id -g)}}
									read -rp "Enter SMB share path (e.g., //server/share): " smb_share
									if [[ -n "$smb_share" && -d "$mount_target" ]]; then
										cmd="mount -t cifs $smb_share $mount_target -o credentials=$ex_creds,uid=$uid,gid=$gid,rw,vers=3.0"
										log "$ABYSS_USER mounted SMB share using $cmd"
										echo ""
										echo "[$ABYSS_USER@$HOST]$ $cmd"
										$cmd
										sleep 1
										echo
										echo
									
										read -rp "Do you want to add this SMB mount to /etc/fstab? (y/N): " fstab
										if [[ "$fstab" =~ ^[yY]$ ]]; then
											entry="$smb_share $mount_target cifs credentials=$ex_creds,uid=$uid,gid=$gid,x-systemd.automount 0 0"
											echo "$entry" | tee -a /etc/fstab
											log "$ABYSS_USER added SMB mount to fstab"
											systemctl daemon-reload
											mount -a
											echo
											echo
										fi
									else
										echo "Invalid SMB share or mount point. Please try again..."
										continue
									fi
								else
									echo "Invalid SMB share, mount point, or credential file path. Please try again..."
									continue
								fi
						fi
					elif [[ "$mount_type" == "device" ]]; then
						read -rp "Enter device path (e.g., /dev/sda1, /dev/nvme0n1 or q to quit): " device
						device=${device:-q}
						if [[ "$device" =~ ^[qQ]$ ]]; then
							break
						fi

						if [[ -b "$device" && -d "$mount_target" ]]; then
							cmd="mount $device $mount_target"
							log "$ABYSS_USER mounted drive using $cmd"
							echo -e "\n[$ABYSS_USER@$HOST]$ $cmd"
							$cmd 2>&1 | tee -a "$LOG_FILE"
							sleep 1
							echo
	
							read -rp "Do you want to add the mount point to your fstab? (y/N): " fstab
							if [[ "$fstab" =~ ^[yY]$ ]]; then
								uuid=$(blkid -s UUID -o value "$device")
								fs_type=$(blkid -s TYPE -o value "$device")
								if [[ -n "$uuid" && -n "$fs_type" ]]; then
									entry="UUID=$uuid $mount_target $fs_type defaults 0 2"
									echo "$entry" | tee -a /etc/fstab
									log "$ABYSS_USER added $device mount to fstab"
									systemctl daemon-reload
									mount -a
									echo
									echo
								else
									echo "Could not retrieve UUID or filesystem type. Please try again..."
									continue
								fi
							fi
						else
							echo "Invalid device or mount point. Please try again..."
							continue
						fi
					else
						echo "Invalid mount point. Please try again..."
						continue
					fi

					echo
					echo
					read -rp "Press enter to return..."
				done
				;;
			"Unmount SMB or Device")
				while true; do
					read -rp "Do you want to unmount an SMB share or device? (Y/n): " ans
					ans=${ans:-Y}
				
					if [[ "$ans" =~ ^([yY]|[Yy][Ee][Ss])?$ ]]; then
						read -rp "Enter full path to unmount (e.g., /mnt/usb or q to quit): " unmount_point
						unmount_point=${unmount_point:-q}
						if [[ "$unmount_point" =~ ^[qQ]$ ]]; then
							break
						fi

						if [[ -d "$unmount_point" ]];then
							cmd="umount"
							log "$ABYSS_USER used '$cmd' to unmount '$unmount_point'"
							echo
							echo
							echo "[$ABYSS_USER@$HOST]$ $cmd $unmount_point"
							$cmd "$unmount_point" 2>&1 | tee -a "$LOG_FILE" || true
							sleep 1
							echo
							echo
						else
							echo "Invalid or non-existent path..."
							sleep 2
							echo
							echo
						fi
					fi
					echo
					echo
				done
				read -rp "Press enter to return..."
				;;
			"Run cfdisk")
				while true; do
					read -rp "Enter device path (e.g., /dev/sda, /dev/nvme0n1 or q to quit): " device
					device=${device:-q}
					if [[ "$device" =~ ^[qQ]$ ]]; then
						break
					fi

					if [[ -b "$device" ]]; then
						cmd="cfdisk $device"
						log "$ABYSS_USER managed partitions using '$cmd'"
						echo
						echo
						echo "[$ABYSS_USER@$HOST]$ $cmd"
						$cmd 2>&1
						sleep 1
						echo
						echo
						read -rp "Press enter to return..."
					else
						echo "Invalid device: $device"
						sleep 2
					fi
				done
				;;
			"Show Drive UUID")
				while true; do
					read -rp "Entire device path (e.g., /dev/sda, /dev/nvme0n1 or q to quit): " device
					device=${device:-q}
					if [[ "$device" =~ ^[qQ]$ ]]; then
						break
					fi

					if [[ -b "$device" ]]; then 
						cmd="blkid -s UUID -o value $device"
						log "$ABYSS_USER viewed drive UUID using '$cmd'"
						echo
						echo
						echo "[$ABYSS_USER@$HOST]$ $cmd"
						eval $cmd | tee -a "$LOG_FILE"
						sleep 1
						echo
						echo
						read -rp "Press enter to return..."
					else
						echo "Invalid device: $device"
						sleep 2
					fi
				done
				;;
			"Back")
				echo "Returning to main menu..."
				echo
				echo
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

		case "$choice" in
			"Change Ownership")
				read -rp "Enter file or directory path: " path
				read -rp "Enter owner (user:group): " owner
				if [[ -e "$path" && -n "$owner" ]]; then
					cmd="chown $owner $path"
					log "$ABYSS_USER changed ownership using '$cmd'"
					echo
					echo
					echo "[$ABYSS_USER@$HOST]$ $cmd"
					$cmd 2>&1 | tee -a "$LOG_FILE"
					sleep 1
					echo
					echo
					read -rp "Press enter to return..."
				else
					echo "Invalid path or owner."
					sleep 2
				fi
				;;
			"Change Permissions")
				read -rp "Enter file or directory path: " path
				read -rp "Enter permissions (e.g., octal like 755, 0755, or symbolic like u+rwx,g-w): " perms
				if [[ -e "$path" && ( "$perms" =~ ^0?[0-7]{3,4}$ || "$perms" =~ ^([ugoa]*[+=-][rwxXst]*)+(,[ugoa]*[+=-][rwxXst]*)*$ ) ]]; then
					cmd="chmod $perms \"$path\""
					log "$ABYSS_USER changed permissions using '$cmd'"
					echo
					echo
					echo "[$ABYSS_USER@$HOST]$ $cmd"
					$cmd 2>&1 | tee -a "$LOG_FILE"
					sleep 1
					echo
					echo
					read -rp "Press enter to return..."
				else
					echo "Invalid path or permissions format."
					sleep 2
				fi
				;;
			"Copy File")
				read -rp "Enter source file path: " src
				read -rp "Enter destination path: " dest
				if [[ -f "$src" && -d "$(dirname "$dest")" ]]; then
					cmd="cp \"$src\" \"$dest\""
					log "$ABYSS_USER copied file using '$cmd'"
					echo
					echo
					echo "[$ABYSS_USER@$HOST]$ $cmd"
					eval $cmd 2>&1 | tee -a "$LOG_FILE"
					sleep 1
					echo
					echo
					read -rp "Press enter to return..."
				else
					echo "Invalid source file or destination directory."
					sleep 2
				fi
				;;
			"List Files")
				read -rp "Enter directory path to list (or press Enter for current directory): " path
				path=${path:-.}  # Default to current directory if empty
				if [[ -d "$path" ]]; then
					cmd="ls -lah \"$path\""
					log "$ABYSS_USER listed files using '$cmd'"
					echo
					echo
					echo "[$ABYSS_USER@$HOST]$ $cmd"
					$cmd 2>&1 | tee -a "$LOG_FILE"
					sleep 1
					echo
					echo
					read -rp "Press enter to return..."
				else
					echo "Invalid directory: $path"
					sleep 2
				fi
				;;
			"Move File")
				read -rp "Enter source file path: " src
				read -rp "Enter destination path: " dest
				if [[ -f "$src" && -d "$(dirname "$dest")" ]]; then
					cmd="mv $src $dest"
					log "$ABYSS_USER moved file using '$cmd'"
					echo
					echo
					echo "[$ABYSS_USER@$HOST]$ $cmd"
					$cmd 2>&1 | tee -a "$LOG_FILE"
					sleep 1
					echo
					echo
					read -rp "Press enter to return..."
				else
					echo "Invalid source file or destination directory."
					sleep 2
				fi
				;;
			"Remove File")
				read -rp "Enter file path to remove: " file
				if [[ -f "$file" ]]; then
					cmd="rm -i \"$file\""
					log "$ABYSS_USER removed file using '$cmd'"
					echo
					echo
					echo "[$ABYSS_USER@$HOST]$ $cmd"
					$cmd 2>&1 | tee -a "$LOG_FILE"
					sleep 1
					echo
					echo
					read -rp "Press enter to return..."
				else
					echo "Invalid file: $file"
					sleep 2
				fi
				;;
			"View File")
				read -rp "Enter file path to view: " file
				if [[ -f "$file" ]]; then
					cmd="less \"$file\""
					log "$ABYSS_USER viewed $file contents"
					echo
					echo
					echo "[$ABYSS_USER@$HOST]$ less $file"
					$cmd 2>&1
					sleep 1
					echo
					echo
					read -rp "Press enter to return..."
				else
					echo "Invalid file: $file"
					sleep 2
				fi
				;;
			"Back")
				echo "Returning to main menu..."
				echo
				echo
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
		choice=$(echo -e "Back\nView SMART Self-Test Results\nRun SMART Health Check\nRun fsck\nFind Files" | fzf)

		case "$choice" in
			"Find Files")
				while true; do
					read -rp "Enter search path (or press Enter for current directory or q to quit): " path
					if [[ "$path" =~ ^[qQ]$ ]]; then
						break
					fi
					path=${path:-.}  # Default to current directory

					if [[ ! -d "$path" ]]; then
						echo "Invalid directory: $path"
						sleep 2
						continue
					fi

					read -rp "Enter file name or pattern to search (default '*'): " pattern
					pattern=${pattern:-*}

					read -rp "Enter file type (f=file, d=dir, l=link, leave empty for all): " ftype

					cmd="find $path ${ftype:+-type $ftype} -name \"pattern\""
					log "$ABYSS_USER searched files using '$cmd'"
					echo
					echo
					echo "[$ABYSS_USER@$HOST]$ $cmd"
					eval $cmd 2>&1 | tee -a "$LOG_FILE"
					sleep 1
					echo
					echo
					read -rp "Press enter to return..."
				done
				;;
			"Run fsck")
				while true; do
					read -rp "Enter device path (e.g., /dev/sda1 /dev/nvme0n1p1 or q to quit): " device
					device=${device:-q}
					if [[ "$device" =~ ^[qQ]$ ]]; then
						break
					fi

					if [[ ! -b "$device" ]]; then
						echo "Invalid device: $device"
						sleep 2
						continue
					fi

					echo
					echo "Disk usage for $device:"
					df -h | grep "$device" || echo "No mounted filesystem detected for $device."
					echo

					if command -v smartctl &>/dev/null; then
						echo "SMART healtch check for $device:"
						smartctl -H "$device"
						echo
					fi

					if mount | grep -q "$device"; then
						echo "Warning: $device is mounted! Running fsck may corrupt data."
						read -rp "Proceed anyway? [y/N] " confirm
						confirm=${confirm:-N}
						[[ ! "$confirm" =~ ^[yY]$ ]] && continue
					fi

					read -rp "Enter fsck options (e.g., -n, -y, leave empty for default): " fsck_opts

					cmd="fsck $fsck_opts $device"
					log "$ABYSS_USER checked filesystem using '$cmd'"
					echo
					echo
					echo "[$ABYSS_USER@$HOST]$ $cmd"
					$cmd 2>&1 | tee -a "$LOG_FILE"
					sleep 1
					echo
					echo
					read -rp "Press enter to return..."
				done
				;;
			"Run SMART Health Check")
				while true; do
					read -rp "Enter device path for SMART check (or q to quit): " device
					device=${device:-q}
					if [[ "$device" =~ ^[qQ] ]]; then
						break
					fi

					if [[ -b "$device" ]];then
						echo -e "\nDevice info:"
						smartctl -i "$device"

						echo -e "\nOverall SMART Health:"
						smartctl -H "$device"

						read -rp "View detailed SMART attributes? [y/N]: " view_attr
						view_attr=${view_attr:-N}
						if [[ "$view_attr" =~ ^[yY]$ ]]; then
							smartctl -A "$device"
						fi

						read -rp "Run short SMART self-test? [y/N]: " run_test
						run_test=${run_test:-N}
						if [[ "$run_test" =~ ^[yY]$ ]]; then
							smartctl -t short "$device"
							echo "Short self-test started. Check results with:"
							echo "sudo smartctl -l selftest $device"
						fi

						log "$ABYSS_USER performed SMART health check on $device"
						read -rp "Press Enter to return..."
					else
						eacho "Invalid device: $device"
						sleep 2
					fi
				done
				;;
			"View SMART Self-Test Results")
				while true; do
					read -rp "Enter device path to check SMART self-test results (or q to quit): " device
					device=${device:-q}
					if [[ "$device" =~ ^[qQ]$ ]]; then
						break
					fi

					if [[ -b "$device" ]]; then
						echo -e "\nSMART self-test log for $device:"
						smartctl -l selftest "$device"
						log "$ABYSS_USER viewed SMART self-test results for $device"
						read -rp "Press Enter to return..."
					else
						echo "Invalid device: $device"
						sleep 2
					fi
				done
				;;
			"Back")
				echo "Returning to main menu..."
				echo
				echo
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
		choice=$(echo -e "Back\nView System Logs\nView Log File\nView File Content\nTail Log File\nSearch Logs" | fzf)

		case "$choice" in
			"Search Logs")
				while true; do
					read -rp "Enter full path of the log file (or q to quit): " file
					file=${file:-q}
					if [[ "$file" =~ ^[qQ]$ ]]; then
						break
					fi

					if [[ ! -f "$file" ]]; then
						echo "Invalid file: $file"
						sleep 2
						continue
					fi

					read -rp "Enter search pattern (keywork, phrase, or regex): " pattern
					if [[ -z "$pattern" ]]; then
						echo "Search pattern cannot be empty."
						sleep 1
						continue
					fi

					read -rp "Use case-insensitive search? [y/N]: " ignore_case
					ignore_case_flag=""
					[[ "$ignore_case" =~ ^[yY]$ ]] && ignore_case_flag="-i"
				
					echo
					echo
					echo "[$ABYSS_USER@$HOST]$ grep $ignore_case_flag \"$pattern\" \"$file\""
					log "$ABYSS_USER searched logs in '$file' for '$pattern' (ignore_case=${ignore_case_flag:-false})"
				
					grep $ignore_case_flag "$pattern" "$file" | tee -a "$LOG_FILE"
					echo
					echo
					read -rp "Search again in this file? [y/N]: " repeat_search
					[[ ! "$repeat_search" =~ ^[yY]$ ]] && break
				done
				;;
			"Tail Log File")
				read -rp "Enter full path of the log file: " file
				read -rp "Enter number of lines to tail (default 10): " lines
				lines=${lines:-10}

				if [[ -f "$file" && "$lines" =~ ^[0-9]+$ ]]; then
					cmd="tail -n $lines \"$file\""
					log "$ABYSS_USER tailed log file '$file' ($lines lines)"
					echo
					echo
					echo "[$ABYSS_USER@$HOST]$ $cmd"
					tail -n "$lines" "$file" 2>&1 | tee -a "$LOG_FILE"
					sleep 1
					echo
					echo
				else
					echo "Invalid file or number of lines."
					sleep 2
				fi
				read -rp "Press Enter to return..."
				;;
			"View File Content"|"View Log File")
				read -rp "Enter file path to view: " file
				if [[ -f "$file" ]]; then
					log "$ABYSS_USER viewed the contents of '$file'"
					echo
					echo
					echo "[$ABYSS_USER@$HOST]$ less \"$file\""
					less "$file"
					sleep 1
					echo
					echo
				else
					echo "Invalid file: $file"
					sleep 2
				fi
				read -rp "Press Enter to return..."
				;;
			"View System Logs")
				line=$(journalctl -xe --output=short-iso --reverse | fzf --reverse --border --prompt="Select a log line: ")
				if [[ -n "$line" ]]; then
					echo "$line" | awk '{print $1, $2, substr($0, index($0,$3))}'
				else
					echo "No log line selected."
				fi
				log "$ABYSS_USER viewed system logs"
				echo 
				echo
				sleep 1
				read -rp "Press enter to return..."
				;;
			"Back")
				echo "Returning to main menu..."
				echo
				echo
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
run_and_log() {
	local cmd="$1"
	local filter

	read -rp "Enter optional grep filter (press Enter to skip): " filter

	log "$ABYSS_USER ran '$cmd'${filter:+ | grep '$filter'}"
	echo
	echo
	echo "[$ABYSS_USER@$HOST]$ "$cmd" "${filter:+ | grep '$filter'}""
	
	if [[ -n "$filter" ]]; then
		eval "$cmd" 2>&1 | grep --color=auto -i "$filter" | tee -a "$LOG_FILE"
		echo
		echo
	else
		eval "$cmd" | tee -a "$LOG_FILE"
		echo
		echo
	fi
	read -rp "Press Enter to return..."
}

net_config() {
	while true; do
		choice=$(echo -e "Back\nSocket Statistics\nNetwork Statistics" | fzf)
		[[ -z "$choice" || "$choice" == "Back" ]] && break

		case "$choice" in
			"Network Statistics")
				stat_type=$(echo -e "Back\nRouting Table\nListening TCP/UDP\nInterface Stats\nAll Connections" | fzf)
				[[ -z "$stat_type" || "$stat_type" == "Back" ]] && continue

				case "$stat_type" in
					"Listening TCP/UDP")
						command -v netstat >/dev/null 2>&1 && run_and_log "netstat -tulnp" || echo "netstat not found."
						;;
					"Routing Table")
						command -v netstat >/dev/null 2>&1 && run_and_log "netstat -r" || echo "netstat not found."
						;;
					"All Connections")
						command -v netstat >/dev/null 2>&1 && run_and_log "netstat -anp" || echo "netstat not found."
						;;
					"Interface Stats")
						command -v netstat >/dev/null 2>&1 && run_and_log "netstat -i" || echo "netstat not found."
						;;
					"Back")
						echo
						echo
						break
						;;
				esac
				;;
			"Socket Statistics")
				stat_type=$(echo -e "Back\nSocket Summary\nIPv6 TCP/UDP\nIPv4 TCP/UDP\nListening TCP/UDP\nAll Sockets" | fzf)
				[[ -z "$stat_type" || "$stat_type" == "Back" ]] && continue
				case "$stat_type" in
					"Listening TCP/UDP")
						command -v ss >/dev/null 2>&1 && run_and_log "ss -tulnp" || echo "ss not found."
						;;
					"Socket Summary")
						command -v ss >/dev/null 2>&1 && run_and_log "ss -s" || echo "ss not found."
						;;
					"All Sockets")
						command -v ss >/dev/null 2>&1 && run_and_log "ss -anp" || echo "ss not found."
						;;
					"IPv4 TCP/UDP")
						command -v ss >/dev/null 2>&1 && run_and_log "ss -tunp4" || echo "ss not found."
						;;
					"IPv6 TCP/UDP")
						command -v ss >/dev/null 2>&1 && run_and_log "ss -tunp6" || echo "ss not found."
						;;
					"Back")
						echo
						echo
						break
						;;
				esac
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
				read -rp "Enter domain or IP for lookup: " domain
				if [[ -n "$domain" ]]; then
					cmd="nslookup $domain"
					log "$ABYSS_USER performed DNS lookup using '$cmd'"
					echo
					echo
					echo "[$ABYSS_USER@$HOST]$ $cmd"
					$cmd 2>&1 | tee -a "$LOG_FILE"
					sleep 1
					echo
					echo
					read -rp "Press enter to return..."
				else
					echo "No domain or IP specified."
					sleep 2
				fi
				;;
			"Network Management UI")
				cmd="nmtui"
				log "$ABYSS_USER launched network management UI using '$cmd'"
				echo
				echo
				echo "[$ABYSS_USER@$HOST]$ $cmd"
				$cmd 2>&1 | tee -a "$LOG_FILE"
				sleep 1
				echo
				echo
				;;
			"Ping Host")
				read -rp "Enter host to ping (e.g., 8.8.8.8): " host
				if [[ -n "$host" ]]; then
					cmd="ping -c 5 -O $host"
					log "$ABYSS_USER pinged $host using '$cmd'"
					echo
					echo
					echo "[$ABYSS_USER@$HOST]$ $cmd"
					$cmd 2>&1 | tee -a "$LOG_FILE"
					sleep 1
					echo
					echo
					read -rp "Press enter to return..."
				else
					echo "No host specified."
					sleep 2
				fi
				;;
			"Show Interface Configuration")
				cmd="ifconfig"
				log "$ABYSS_USER viewed interface configuration using '$cmd'"
				echo
				echo
				echo "[$ABYSS_USER@$HOST]$ $cmd"
				$cmd 2>&1 | tee -a "$LOG_FILE"
				sleep 1
				echo
				echo
				read -rp "Press enter to return..."
				;;
			"Show IP Configuration")
				cmd="ip addr"
				log "$ABYSS_USER viewed IP configuration using '$cmd'"
				echo
				echo
				echo "[$ABYSS_USER@$HOST]$ $cmd"
				$cmd | tee -a "$LOG_FILE"
				sleep 1
				echo
				echo
				read -rp "Press enter to return..."
				;;
			"Back")
				echo "Returning to main menu..."
				echo
				echo
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

	run_and_log() {
		local cmd="$1"
		local ts
		ts=$(date +"%Y-%m-%d %H:%M:%S")
		echo -e "[$ABYSS_USER@$HOST]$ $cmd"
		{
			echo "[$ts] CMD: $cmd"
			eval "$cmd"
			ec=$?
			if [[ $ec -eq 0 ]]; then
				echo "[$ts] Success"
			else
				echo "[$ts] Failed with exit code $status"
			fi
		} 2>&1 | tee -a "$LOG_FILE"
		echo
	}

	confirm_action() {
		local prompt="$1"
		read -rp "$prompt [y/N]: " confirm
		confirm=${confirm:-N}
		[[ "$confirm" =~ ^[yY]$ ]]
	}
	validate_ip() {
		local ip="$1"
		if [[ "$ip" =~ ^([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})(/([0-9]{1,2}))?$ ]]; then
			local o1=${BASH_REMATCH[1]} o2=${BASH_REMATCH[2]} o3=${BASH_REMATCH[3]} o4=${BASH_REMATCH[4]} cidr=${BASH_REMATCH[6]}
			[[ $o1 -le 255 && $o2 -le 255 && $o3 -le 255 && $o4 -le 255 && ( -z "$cidr" || ( $cidr -ge 0 && $cidr -le 32 ) ) ]]
		else
			return 1
		fi
	}

	allow_traffic() {
		local choice
		choice=$(echo -e "Back\nAllow Specific Port\nAllow Specific IP Address\nAllow Specific IP Address & Port\nAllow All Outgoing\nAllow All Incoming" | fzf)

		case "$choice" in
			"Allow All Incoming")
				if confirm_action "Allow all incoming traffic?"; then
					run_and_log "ufw default allow incoming"
				else
					echo "Action cancelled."
				fi
				;;
			"Allow All Outgoing")
				if confirm_action "Allow all outgoing traffic?"; then
					run_and_log "ufw default allow outgoing"
				else
					echo "Action cancelled."
				fi
				;;
			"Allow Specific IP Address")
				read -rp "Enter IP address (CIDR allowed): " ip
				if validate_ip "$ip"; then
					run_and_log "ufw allow from \"$ip\""
				else
					echo "Invalid IP address format."
				fi
				;;
			"Allow Specific IP Address & Port")
				read -rp "Enter IP address or CIDR: " ip
				read -rp "Enter port number: " port
				read -rp "Enter protocol (tcp/udp): " proto
				if validate_ip "$ip" && [[ "$port" =~ ^[0-9]+$ ]] && (( port >= 1 && port <= 65535 )) && [[ "$proto" =~ ^(tcp|udp)$ ]]; then
				run_and_log "ufw allow from \"$ip\" to any port \"$port\" proto \"$proto\""
			else
				echo "Invalid IP/port/protocol."
				fi
				;;
			"Allow Specific Port")
				read -rp "Enter port and protocol (e.g., 22/tcp): " port
				if [[ "$port" =~ ^[0-9]+/(tcp|udp)$ ]]; then
					run_and_log "ufw allow \"$port\""
				else
					echo "Invalid port/protocol format."
				fi
				;;
			"Back"|*) return ;;
		esac
		read -rp "Press enter to return..."
	}

	deny_traffic() {
		local choice
		choice=$(echo -e "Back\nDeny Specific IP Address & Port\nDeny Specific Port\nDeny Specific IP Address\nDeny All Outgoing\nDeny All Incoming" | fzf)

		case "$choice" in
			"Deny All Incoming")
				if confirm_action "Deny all incoming traffic?"; then
					run_and_log "ufw default deny incoming"
				else
					echo "Action cancelled."
				fi
				;;
			"Deny All Outgoing")
				if confirm_action "Deny all outgoing traffic?"; then
					run_and_log "ufw default deny outgoing"
				else
					echo "Action cancelled."
				fi
				;;
			"Deny Specific IP Address")
				read -rp "Enter IP address (CIDR allowed): " ip
				if validate_ip "$ip"; then
					run_and_log "ufw deny from \"$ip\""
				else
					echo "Invalid IP address format."
				fi
				;;
			"Deny Specific IP Address & Port")
				read -rp "Enter IP address or CIDR: " ip
				read -rp "Enter port number: " port
				read -rp "Enter protocol (tcp/udp): " proto
				if validate_ip "$ip" && [[ "$port" =~ ^[0-9]+$ ]] && (( port >= 1 && port <= 65535 )) && [[ "$proto" =~ ^(tcp|udp)$ ]]; then
					run_and_log "ufw deny from \"$ip\" to any port \"$port\" proto \"$proto\""
				else
					echo "Invalid IP/port/protocol."
				fi
				;;
			"Deny Specific Port")
				read -rp "Enter port and protocol (e.g., 22/tcp): " port
				if [[ "$port" =~ ^[0-9]+/(tcp|udp)$ ]]; then
					run_and_log "ufw deny \"$port\""
				else
					echo "Invalid port/protocol format."
				fi
				;;
			"Back"|*) return ;;
		esac
		read -rp "Press enter to return..."
	}

	antivirus_scan() {
		local path="$1"
		check_clamav || return
		local sig_file="/var/lib/clamav/daily.cld"
		if [[ -f "$sig_file" ]] && [[ $(find "$sig_file" -mtime -1) ]]; then
			echo "Signatures up to date. Skipping freshclam."
		else
			run_and_log "freshclam"
		fi
		run_and_log "nohup clamscan -r --bell -i \"$path\" > /var/log/The-Abyss/.logs/clamscan.log 2>&1 &"
		echo "Scan initiated. Check progress with: tail -f /var/log/The-Abyss/.logs/clamscan.log"
		if confirm_action "View scan progress now?"; then
			tail -f /var/log/The-Abyss/.logs/clamscan.log
		fi
	}

	prompt_reboot() {
		if confirm_action "Reboot system?"; then
			echo "System reboot initiated..."
			sleep 2
			reboot
		fi
	}
	
	full_system_update() {
		if [[ -z "${PKG_UPDATE_CMDS[$PKG_MGR]}" ]]; then
			echo "Unsupported package manager: $PKG_MGR"
			return 1
		fi
		run_and_log "${PKG_UPDATE_CMDS[$PKG_MGR]}"
		prompt_reboot
	}

	package_update() {
		get_outdated_packages() {
			local refresh=1
			case $PKG_MGR in
				apk)
					if [[ $refresh -eq 1 ]] && [[ ! -f /var/cache/apk/APKINDEX.* || $(find /var/cache/apk/APKINDEX.* -mtime +1 2>/dev/null) ]]; then
						apk update >/dev/null 2>&1
					fi
					apk upgrade --simulate | awk '/Upgrading/ {print $2}' | sort -u
					;;
				apt)
					if [[ $refresh -eq 1 ]] && [[ ! -f /var/cache/apt/pkgcache.bin || $(find /var/cache/apt/pkgcache.bin -mtime +1 2>/dev/null) ]]; then
						apt update >/dev/null 2>&1
					fi
					apt list --upgradable 2>/dev/null | awk -F/ '!/^Listing/ {print $1}' | sort -u
					;;
				conda)
					conda list --outdated 2>/dev/null | awk '!/^#/ {print $1}' | sort -u
					;;
				dnf)
					if [[ $refresh -eq 1 ]] && [[ ! -f /var/cache/dnf/packages.db || $(find /var/cache/dnf/packages.db -mtime +1 2>/dev/null) ]]; then
						dnf check-update --refresh >/dev/null 2>&1
					fi
					dnf check-update | awk '/^[a-zA-Z0-9]/ {print $1}' | sort -u
					;;
				emerge)
					if [[ $refresh -eq 1 ]] && [[ ! -f /var/db/repos/gentoo/metadata/timestamp.chk || $(find /var/db/repos/gentoo/metadata/timestamp.chk -mtime +1 2>/dev/null) ]]; then
						emerge --sync >/dev/null 2>&1
					fi
					emerge -puD @world | awk '/^\[ebuild/ {print $3}' | sort -u
					;;
				nix-env)
					if [[ $refresh -eq 1 ]] && [[ ! -f ~/.nix-defexpr/channels/manifest.nix || $(find ~/.nix-defexpr/channels/manifest.nix -mtime +1 2>/dev/null) ]]; then
						nix-channel --update >/dev/null 2>&1
					fi
					nix-env --upgrade --dry-run | awk '/upgrading/ {gsub(/'\''/, "", $2); print $2}' | sort -u
					;;
				pacman)
					if [[ $refresh -eq 1 ]] && [[ ! -f /var/lib/pacman/sync/*.db || $(find /var/lib/pacman/sync/*.db -mtime +1 2>/dev/null) ]]; then
						pacman -Sy >/dev/null 2>&1
					fi
					pacman -Syup --print-format %n 2>/dev/null | grep -E '^[a-zA-Z0-9._+-]+$' | sort -u
					;;
				pkg)
					if [[ $refresh -eq 1 ]] && [[ ! -f /var/db/pkg/repo-*.sqlite || $(find /var/db/pkg/repo-*.sqlite -mtime +1 2>/dev/null) ]]; then
						pkg update >/dev/null 2>&1

					fi
					pkg version -l '<' | awk '{print $1}' | sed 's/-.*$//' | sort -u
					;;
				pkgin)
					if [[ $refresh -eq 1 ]] && [[ ! -f /opt/local/pkg_summary.gz || $(find /opt/local/pkg_summary.gz -mtime +1 2>/dev/null) ]]; then
						pkgin -y update >/dev/null 2>&1
					fi
					pkgin avail -u | awk '{print $1}' | sed 's/-.*$//' | sort -u
					;;
				pkg_add)
					pkg_info -u | awk '{print $1}' | sed 's/-.*$//'
					;;
				slackpkg)
					if [[ $refresh -eq 1 ]] && [[ ! -f /var/slackpkg/CHECKSUMS.md5 || $(find /var/slackpkg/CHECKSUMS.md5 -mtime +1 2>/dev/null) ]]; then
						slackpkg update >/dev/null 2>&1
					fi
					slackpkg upgrade --dry-run | awk '/Upgrading/ {print $2}' | sort -u
					;;
				spack)
					spack list --outdated 2>/dev/null | awk '{print $1}' | sort -u
					;;
				yum)
					if [[ $refresh -eq 1 ]] && [[ ! -f /var/cache/yum/*/gen/primary_db.sqlite || $(find /var/cache/yum/*/gen/primary_db.sqlite -mtime +1 2>/dev/null) ]]; then
						yum check-update >/dev/null 2>&1
					fi
					yum check-update | awk '/^[a-zA-Z0-9]/ {print $1}' | sort -u
					;;
				zypper)
					if [[ $refresh -eq 1 ]] && [[ ! -f /var/cache/zypp/raw/* || $(find /var/cache/zypp/raw/* -mtime +1 2>/dev/null) ]]; then
						zypper refresh >/dev/null 2>&1
					fi
					zypper list-updates | awk '$1 == "v" {print $3}' | sort -u
					;;
				*)
					echo "Unsupported package manager: $PKG_MGR" >&2
					return 1
					;;
			esac
		}
	
	OUTDATED=$(get_outdated_packages || true)
	
	if [[ -z "$OUTDATED" ]]; then
		echo "No packages available for update."
		sleep 2
		return
	fi

	readarray -t OUTDATED_ARRAY <<<"$OUTDATED"	
	mapfile -t PACKAGES < <(printf "%s\n" "${OUTDATED_ARRAY[@]}" | fzf --multi --prompt="Select packages to update: " --border)
					
	if [[ ${#PACKAGES[@]} -eq 0 ]]; then
		echo "No packages selected."
		sleep 2
		return
	fi

	declare -a installed_pkgs=()
					
	local update_cmd
	case $PKG_MGR in
		apk)
			update_cmd="apk upgrade ${PACKAGES[*]}"
			;;
		apt)
			update_cmd="apt install --only-upgrade ${PACKAGES[*]} -y"
			;;
		conda)
			update_cmd="conda install ${PACKAGES[*]} -y"
			;;
		dnf)
			update_cmd="dnf upgrade ${PACKAGES[*]} -y"
			;;
		emerge)
			update_cmd="emerge ${PACKAGES[*]} --ask=n"
			;;
		nix-env)
			update_cmd="nix-env --upgrade ${PACKAGES[*]}"
			;;
		pacman)
			update_cmd="pacman -S ${PACKAGES[*]} --noconfirm"
			;;
		pkg)
			update_cmd="pkg upgrade ${PACKAGES[*]} -y"
			;;
		pkgin)
			update_cmd="pkgin -y upgrade ${PACKAGES[*]}"
			;;
		pkg_add)
			update_cmd="pkg_add -u ${PACKAGES[*]}"
			;;
		slackpkg)
			update_cmd="slackpkg upgrade ${PACKAGES[*]} -batch=on"
			;;
		spack)
			update_cmd="spack install ${PACKAGES[*]} -y"
			;;
		yum)
			update_cmd="yum upgrade ${PACKAGES[*]} -y"
			;;
		zypper)
			update_cmd="zypper install --no-recommends ${PACKAGES[*]} -y"
			;;
		*)
			echo "Unsupported package manager: $PKG_MGR"
			return 1
			;;
	esac
	log "$ABYSS_USER is updating ${PACKAGES[*]} using $PKG_MGR"
	if [[ -n "$update_cmd" ]]; then
		if run_and_log "$update_cmd"; then
			echo "Update succeeded."
		else
			echo "Update failed."
		fi
	fi
	
	if [[ "${PACKAGES[*]}" =~ clamav ]]; then
		command -v freshclam &>/dev/null && freshclam
	fi
}


	while true; do
		choice=$(echo -e "Back\nSystem Update\nShow Last Logins\nShow Active Users\nRootkit Check\nShow Firewall Status\nDeny Traffic\nAllow Traffic\nAntivirus Scan" | fzf)
       
		if [[ -z "$choice" ]]; then
			echo "No selection made. Returning..."
			sleep 2
			break
		fi

		case "$choice" in
			"Allow Traffic") allow_traffic ;;
			"Deny Traffic") deny_traffic ;;
			"Show Active Users")
				run_and_log "who"
				echo
				echo
				read -rp "Press enter to return..."
				;;
			"Show Firewall Status")
				run_and_log "ufw status"
				ans=$(echo -e "Cancel\nON\nOFF" | fzf --prompt="Toggle firewall: ")
				case "$ans" in
					"ON")  run_and_log "ufw enable" ;;
					"OFF") run_and_log "ufw disable" ;;
					*)     echo "No changes made." ;;
				esac
				read -rp "Press enter to return..."
				;;
			"Show Last Logins")
				run_and_log "last"
				echo
				echo
				read -rp "Press enter to return..."
				;;
			"Antivirus Scan")
				scan_type=$(echo -e "Back\nScan Specific Directory\nFull System Scan" | fzf)
				
				case "$scan_type" in
					"Full System Scan") antivirus_scan "/" ;;
					"Scan Specific Directory")
						read -rp "Enter path to be scanned (default: /home/$ABYSS_USER): " path
						path=${path:-/home/$ABYSS_USER}
						[[ -d "$path" ]] && antivirus_scan "$path" || echo "Invalid path: $path"
						;;
					"Back"|*) continue ;;
				esac
				read -rp "Press Enter to return..."
				;;
			"Rootkit Check")
				rkh_prop="/var/lib/rkhunter/db/rkhunter.prop"
				if [[ -f "$rkh_prop" ]] && [[ $(find "$rkh_prop" -mtime -1) ]]; then
					echo "Rootkit Hunter properties are up to date. Skipping update."
				else
					run_and_log "rkhunter --update"
				fi
				run_and_log "rkhunter --check --sk"
				echo
				echo
				echo "Rootkit check initiated. Review /var/log/rkhunter.log for details."
				echo
				echo
				read -rp "Press enter to return..."
				;;
			"System Update")
				update_choice=$(echo -e "Back\nUpdate by Package\nFull System Update" | fzf)

				case "$update_choice" in
					"Full System Update") full_system_update ;;
					"Update by Package") package_update ;;
					"Back") continue ;;
					*) echo "Invalid update choice." ;;
				esac
				read -rp "Press Enter to return..."
				;;
			"Back")
				echo "Returning to main menu..."
				break
				;;
			*) echo "Invalid selection." ;;
		esac
	done
					
}

# System Monitoring Submenu
sys_mon() {
	run_and_log() {
		local cmd="$1"
		log "$ABYSS_USER executed '$cmd'"
		echo "[$ABYSS_USER@$HOST]$ $cmd"
		echo
		eval "$cmd" | tee -a "$LOG_FILE"
		echo
		read -rp "Press Enter to return..."
	}
	while true; do
		choice=$(echo -e "Back\nView Memory Info\nShow Virtual Memory Stats\nShow Last Boot Time\nShow Free Memory\nMonitor Processes (top)\nMonitor Processes (htop)\nList Processes" | fzf)
        
		if [[ -z "$choice" ]]; then
			echo "No selection made. Returning to main menu..."
			sleep 2
			break
		fi
		case "$choice" in
			"List Processes")
				read -rp "Enter process filter (e.g., aux, -ef) [default: aux]: " opts
				opts=${opts:-aux}
				read -rp "Enter user to filter (or press Enter for none): " user
				if [[ -n "$user" ]]; then
					run_and_log "pgrep -u \"$user\" -a || echo 'No processes found for user $user'"
				else
					run_and_log "ps $opts"
				fi
				;;
			"Monitor Processes (htop)")
				htop
				log "$ABYSS_USER monitored processes using htop"
				;;
			"Monitor Processes (top)")
				top
				log "$ABYSS_USER monitored processes using top"
				;;
			"Show Free Memory")
				run_and_log "free -hwt"
				;;
			"Show Last Boot Time")
				run_and_log "who -b"
				;;
			"Show Virtual Memory Stats")
				run_and_log "vmstat -sw"
				;;
			"View Memory Info")
				log "$ABYSS_USER viewed memory info"
				echo
				echo
				echo "[$ABYSS_USER@$HOST]$ less /proc/meminfo"
				less /proc/meminfo
				echo
				echo
				read -rp "Press enter to return..."
				;;
			"Back")
				echo "Returning to main menu..."
				echo
				echo
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
	run_and_log() {
		local cmd="$1"
		log "$ABYSS_USER executed '$cmd'"
		echo "[$ABYSS_USER@$HOST]$ $cmd"
		echo
		eval "$cmd" | tee -a "$LOG_FILE"
		echo
		read -rp "Press Enter to return..."
	}

	while true; do
		choice=$(echo -e "Back\nManage Service\nList Services\nList Processes" | fzf)
        
		if [[ -z "$choice" ]]; then
			echo "No selection made. Returning to main menu..."
			sleep 2
			break
		fi

		case "$choice" in
			"List Processes")
				read -rp "Enter ps options (default: aux): " opts
				opts={$opts:-aux}
				read -rp "Enter user to filter (or press Enter for none): " user
				if [[ -n "$user" ]]; then
					run_and_log "pgrep -u \"$user\" -a || echo 'No processes found for user $user'"
				else
					run_and_log "ps $opts"
				fi
				;;
			"List Services")
				service=$(systemctl list-units --type=service --all --no-legend | fzf | awk '{print $1}')
				if [[ -z "$service" ]]; then
					echo "No service selected."
					sleep 2
				else
					echo "Selected service: $service" | tee -a "$LOG_FILE"
					read -rp "Press enter to return..."
				fi
				;;
			"Manage Service")
				read -rp "Enter service name: " service
				action=$(echo -e "start\nstop\nrestart\nstatus" | fzf)
				if [[ -n "$service" && -n "$action" ]]; then
					run_and_log "systemctl $action $service"
				else
					echo "Invalid service or action."
					sleep 2
				fi
				;;
			"Back")
				echo "Returning to main menu..."
				echo
				echo
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
	run_and_log() {
		local cmd="$1"
		local ts status
		echo "[$ABYSS_USER@$HOST]$ $cmd"
		ts=$(date +"%Y-%m-%d %H:%M:%S")
		printf "[%s] CMD: %s\n" "$ts" "$cmd" | tee -a "$LOG_FILE" >/dev/null
		eval "$cmd" 2>&1 | tee -a "$LOG_FILE"
		status=${PIPESTATUS[0]}
		ts=$(date +"%Y-%m-%d %H:%M:%S")
		if (( status == 0 )); then
			printf "[%s] Result: success (exit 0)\n" "$ts" | tee -a "$LOG_FILE" >/dev/null
		else
			printf "[%s] Result: failed (exit %d)\n" "$ts" "$status" | tee -a "$LOG_FILE" >/dev/null
		fi
		
		echo
		return $status
	}

	while true; do
		choice=$(echo -e "Back\nShow Uptime (pretty)\nShow System Uptime (since)\nShow System Uptime\nShow Memory Info\nShow Kernel Info\nShow CPU Info" | fzf)
        
		if [[ -z "$choice" ]]; then
			echo "No selection made. Returning to main menu..."
			sleep 2
			break
		fi

		case "$choice" in
			"Show CPU Info")
				run_and_log "lscpu"
				;;
			"Show Kernel Info")
				run_and_log "uname -a"
				;;
			"Show Memory Info")
				if command -v lsmem &>/dev/null; then
					run_and_log "lsmem"
				else
					run_and_log "cat /proc/meminfo"
				fi
				;;
			"Show System Uptime")
				run_and_log "uptime"
				;;
			"Show System Uptime (since)")
				run_and_log "uptime -s"
				;;
			"Show Uptime (pretty)")
				run_and_log "uptime -p"
			;;
		"Back")
			echo "Returning to main menu..."
			echo
			echo
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

