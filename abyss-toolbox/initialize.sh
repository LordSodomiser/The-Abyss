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

if [[ $EUID -ne 0 ]]; then
	echo "Root privileges are required to run this initialization."
	read -rp "Do you want to run it with sudo now? [Y/n]: " ans
	ans=${ans:-Y}

	if [[ "$ans" =~ ^([yY]|[Yy][Ee][Ss])$ ]]; then
		exec sudo "$0" "$@"
	else
		echo "Exiting..."
		exit 1
	fi
fi

source "$(dirname "$0")/.configs/.env"

pkg_log() {
	installed_pkgs+=("$pkg")
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

for pkg_mgr in apk apt conda dnf emerge nix-env pacman pkg pkgin pkg_add slackpkg spack yum zypper; do
	if command -v "$pkg_mgr" &>/dev/null; then

		if ! grep -q "^PKG_MGR=" "$ENV_FILE"; then
		echo "PKG_MGR=$pkg_mgr" >> "$ENV_FILE"
		fi
		echo "Detected $pkg_mgr package manager..."
		case "$pkg_mgr" in
			apk)
				required_tools=(awk cat cd clamscan cifs cp cfdisk df du find free fzf grep hostname htop ifconfig ip less ls lsblk mount mv netstat nmtui nslookup parted ping ps rkhunter rm smbclient service sudo top ufw umount uname uptime vmstat which who)
				pkg_install="sudo apk add"
				;;
			apt)
				required_tools=(awk cat cd clamscan cifs cp cfdisk df du find free fzf grep hostname htop ifconfig ip journalctl less ls lsblk lscpu lsmem mount mv netstat nmtui nslookup parted ping ps rkhunter rm smbclient service sudo systemctl top ufw umount uname uptime vmstat which who)
				pkg_install="sudo apt install -y"
				;;
			conda)
				required_tools=(awk cat cd cp df du find free fzf grep hostname less ls mv netstat ping ps rm top uname uptime vmstat which who)
				pkg_install="conda install -c conda-forge"
				;;
			dnf)
				required_tools=(awk cat cd clamscan cifs cp cfdisk df du find free fzf grep hostname htop ifconfig ip journalctl less ls lsblk lscpu lsmem mount mv netstat nmtui nslookup parted ping ps rkhunter rm smbclient service sudo systemctl top ufw umount uname uptime vmstat which who)
				pkg_install="sudo $pkg_mgr install -y"
				;;
			emerge)
				required_tools=(awk cat cd clamscan cifs cp cfdisk df du find free fzf grep hostname htop ifconfig ip journalctl less ls lsblk lscpu lsmem mount mv netstat nmtui nslookup parted ping ps rkhunter rm smbclient service sudo systemctl top ufw umount uname uptime vmstat which who)
				pkg_install="sudo emerge --ask n"
				;;
			nix-env)
				required_tools=(awk cat cd cifs cp df du find free fzf grep hostname less ls mount mv nslookup parted ping ps smbclient top umount uname uptime vmstat which who)
				pkg_install="nix-env -iA"
				;;
			pacman)
				required_tools=(awk cat cd clamscan cifs cp cfdisk df du find free fzf grep hostname htop ifconfig ip journalctl less ls lsblk lscpu lsmem mount mv netstat nmtui nslookup parted ping ps rkhunter rm smbclient sudo systemctl top ufw umount uname uptime vmstat which who)
				pkg_install="sudo pacman -S --noconfirm"
				;;
			pkg)
				required_tools=(awk cat cd clamscan cp cfdisk df du find free fzf grep hostname htop ifconfig ip less ls lsblk lscpu lsmem mount_smbfs mv netstat nmtui nslookup parted ping ps rkhunter rm smbclient sudo top ufw uname uptime vmstat which who)
				pkg_install="sudo pkg install"
				;;
			pkg_add)
				required_tools=(awk cat cd cp clamscan cfdisk df du find free fzf grep hostname htop ifconfig ip less ls lsblk lscpu lsmem mount_smbfs mv netstat nmtui nslookup parted ping ps rcctl rkhunter rm smbclient sudo top ufw uname uptime vmstat which who)
				pkg_install="sudo pkg_add"
				;;
			pkgin)
				required_tools=(awk cat cd clamscan cp cfdisk df du find free fzf grep hostname htop ifconfig ip less ls lsblk lscpu lsmem mount_smbfs mv netstat nmtui nslookup parted ping ps rkhunter rm smbclient sudo top ufw uname uptime vmstat which who)
				pkg_install="sudo pkgin install"
				;;
			slackpkg)
				required_tools=(awk cat cd cp clamscan cfdisk df du find free fzf grep hostname htop ifconfig ip less lsblk lscpu lsmem mount mv netstat nmtui nslookup parted ping ps rkhunter rm smbclient service sudo top ufw umount uname uptime vmstat which who)
				pkg_install="sudo slackpkg install -batch=on"
				;;
			spack)
				required_tools=(awk cat cd cp df du find free fzf grep hostname less ls mount mv netstat nslookup parted ping ps rm top umount uname uptime vmstat which who)
				pkg_install="spack install"
				;;
			yum)
				required_tools=(awk cat cd clamscan cifs cp cfdisk df du find free fzf grep hostname htop ifconfig ip journalctl less ls lsblk lscpu lsmem mount mv netstat nmtui nslookup parted ping ps rkhunter rm smbclient service sudo systemctl top ufw umount uname uptime vmstat which who)
				pkg_install="sudo yum install -y"
				;;
			zypper)
				required_tools=(awk cat cd clamscan cifs cp cfdisk df du find free fzf grep hostname htop ifconfig ip journalctl less ls lsblk lscpu lsmem mount mv netstat nmtui nslookup parted ping ps rkhunter rm smbclient service sudo systemctl top ufw umount uname uptime vmstat which who)
				pkg_install="sudo zypper install --non-interactive"
				;;
		esac

		missing_tools=()
		missing_packages=()
		declare -A tool_to_package
		case "$pkg_mgr" in
			apk)
				tool_to_package=(
					["awk"]="busybox" ["cat"]="busybox" ["cd"]="busybox" ["clamscan"]="clamav" ["cifs"]="cifs-utils"
					["cp"]="busybox" ["cfdisk"]="util-linux" ["df"]="busybox" ["du"]="busybox" ["find"]="findutils"
					["free"]="procps" ["fzf"]="fzf" ["grep"]="busybox" ["hostname"]="busybox"
					["htop"]="htop" ["ifconfig"]="net-tools" ["ip"]="iproute2" ["less"]="busybox" ["ls"]="busybox" ["lsblk"]="util-linux"
					["mount"]="util-linux"["mv"]="busybox" ["netstat"]="net-tools" ["nmtui"]="networkmanager" ["nslookup"]="bind-tools"
					["parted"]="parted" ["ping"]="busybox" ["ps"]="procps" ["rkhunter"]="rkhunter" ["rm"]="busybox"
					["service"]="initscripts" ["smbclient"]="samba" ["sudo"]="sudo" ["top"]="procps" ["ufw"]="ufw" ["umount"]="util-linux"
					["uname"]="busybox" ["vmstat"]="procps" ["which"]="busybox" ["who"]="busybox"
				)
				;;
			apt)
				tool_to_package=(
					["awk"]="gawk" ["cat"]="coreutils" ["cd"]="coreutils" ["clamscan"]="clamav" ["cifs"]="cifs-utils"
					["cp"]="coreutils" ["cfdisk"]="util-linux" ["df"]="coreutils" ["du"]="coreutils" ["find"]="findutils"
					["free"]="procps" ["fzf"]="fzf" ["grep"]="grep" ["hostname"]="inetutils-tools"
					["htop"]="htop" ["ifconfig"]="net-tools" ["ip"]="iproute2" ["journalctl"]="systemd"
					["less"]="less" ["ls"]="coreutils" ["lsblk"]="util-linux" ["lscpu"]="util-linux" ["lsmem"]="util-linux"
					["mount"]="util-linux" ["mv"]="coreutils" ["netstat"]="net-tools" ["nmtui"]="network-manager" ["nslookup"]="dnsutils"
					["parted"]="parted"
					["ping"]="inetutils" ["ps"]="procps" ["rkhunter"]="rkhunter" ["rm"]="coreutils" ["service"]="initscripts" ["smbclient"]="samba"
					["sudo"]="sudo" ["systemctl"]="systemd" ["top"]="procps" ["ufw"]="ufw" ["umount"]="util-linux"
					["uname"]="coreutils" ["uptime"]="coreutils" ["vmstat"]="procps" ["which"]="coreutils" ["who"]="coreutils"
				)
				;;
			conda)
				tool_to_package=(
					["awk"]="gawk" ["cat"]="coreutils" ["cd"]="coreutils" ["cp"]="coreutils"
					["df"]="coreutils" ["du"]="coreutils" ["find"]="findutils" ["free"]="procps-ng"
					["fzf"]="fzf" ["grep"]="grep" ["hostname"]="coreutils" ["less"]="less"
					["ls"]="coreutils" ["mv"]="coreutils" ["netstat"]="net-tools" ["ping"]="inetutils"
					["ps"]="procps-ng" ["rm"]="coreutils" ["top"]="procps-ng" ["uname"]="coreutils"
					["uptime"]="coreutils" ["vmstat"]="procps-ng" ["which"]="coreutils" ["who"]="coreutils"
				)
				;;
			dnf|yum)
				tool_to_package=(
					["awk"]="gawk" ["cat"]="coreutils" ["cd"]="coreutils" ["clamscan"]="clamav" ["cifs"]="cifs-utils"
					["cp"]="coreutils" ["cfdisk"]="util-linux" ["df"]="coreutils" ["du"]="coreutils" ["find"]="findutils"
					["free"]="procps-ng" ["fzf"]="fzf" ["grep"]="grep" ["hostname"]="hostname"
					["htop"]="htop" ["ifconfig"]="net-tools" ["ip"]="iproute" ["journalctl"]="systemd"
					["less"]="less" ["ls"]="coreutils" ["lsblk"]="util-linux" ["lscpu"]="util-linux" ["lsmem"]="util-linux" ["mount"]="util-linux" 
					["mv"]="coreutils" ["netstat"]="net-tools" ["nmtui"]="NetworkManager-tui" ["nslookup"]="bind-utils" ["parted"]="parted"
					["ping"]="iputils" ["ps"]="procps-ng" ["rkhunter"]="rkhunter" ["rm"]="coreutils" ["service"]="initscripts" ["smbclient"]="samba"
					["sudo"]="sudo" ["systemctl"]="systemd" ["top"]="procps-ng" ["ufw"]="ufw" ["umount"]="util-linux"
					["uname"]="coreutils" ["uptime"]="coreutils" ["vmstat"]="procps-ng" ["which"]="coreutils" ["who"]="coreutils"
				)
				;;
			emerge)
				tool_to_package=(
					["awk"]="sys-apps/gawk" ["cat"]="sys-apps/coreutils" ["cd"]="sys-apps/coreutils" ["clamscan"]="app-antivirus/clamav"
					["cifs"]="net-fs/cifs-utils" ["cp"]="sys-apps/coreutils" ["cfdisk"]="sys-apps/util-linux" ["df"]="sys-apps/coreutils"
					["du"]="sys-apps/coreutils" ["find"]="sys-apps/findutils" ["free"]="sys-process/procps"
					["fzf"]="app-misc/fzf" ["grep"]="sys-apps/grep" ["hostname"]="sys-apps/inetutils"
					["htop"]="sys-process/htop" ["ifconfig"]="sys-apps/net-tools" ["ip"]="sys-apps/iproute2"
					["journalctl"]="sys-apps/systemd" ["less"]="sys-apps/less" ["ls"]="sys-apps/coreutils"
					["lsblk"]="sys-apps/util-linux" ["lscpu"]="sys-apps/util-linux" ["lsmem"]="sys-apps/util-linux" ["parted"]="sys-block/parted"
					["mount"]="sys-apps/util-linux" ["mv"]="sys-apps/coreutils" ["netstat"]="sys-apps/net-tools" ["nmtui"]="net-misc/networkmanager"
					["nslookup"]="net-dns/bind-tools" ["ping"]="sys-apps/inetutils" ["ps"]="sys-process/procps" ["rkhunter"]="app-forensics/rkhunter" ["rm"]="sys-apps/coreutils"
					["service"]="sys-apps/sysvinit" ["smbclient"]="net-fs/samba" ["sudo"]="app-admin/sudo" ["systemctl"]="sys-apps/systemd"
					["top"]="sys-process/procps" ["ufw"]="net-misc/ufw" ["umount"]="sys-apps/util-linux" ["uname"]="sys-apps/coreutils" ["uptime"]="sys-apps/coreutils"
					["vmstat"]="sys-process/procps" ["which"]="sys-apps/coreutils" ["who"]="sys-apps/coreutils"
				)
				;;
			nix-env)
				tool_to_package=(
					["awk"]="nixpkgs.gawk" ["cat"]="nixpkgs.coreutils" ["cd"]="nixpkgs.coreutils" ["cifs"]="nixpkgs.cifs-utils"
					["cp"]="nixpkgs.coreutils" ["df"]="nixpkgs.coreutils" ["du"]="nixpkgs.coreutils"
					["find"]="nixpkgs.findutils" ["free"]="nixpkgs.procps" ["fzf"]="nixpkgs.fzf"
					["grep"]="nixpkgs.grep" ["hostname"]="nixpkgs.coreutils" ["less"]="nixpkgs.less" ["ls"]="nixpkgs.coreutils"
					["mount"]="nixpkgs.util-linux" ["mv"]="nixpkgs.coreutils" ["netstat"]="nixpkgs.net-tools" ["nslookup"]="nixpkgs.bind" ["parted"]="nixpkgs.parted"
					["ping"]="nixpkgs.inetutils" ["ps"]="nixpkgs.procps" ["rm"]="nixpkgs.coreutils" ["smbclient"]="nixpkgs.samba"
					["top"]="nixpkgs.procps" ["umount"]="nixpkgs.util-linux" ["uname"]="nixpkgs.coreutils" ["uptime"]="nixpkgs.coreutils"
					["vmstat"]="nixpkgs.procps" ["which"]="nixpkgs.coreutils" ["who"]="nixpkgs.coreutils"
				)
				;;
			pacman)
				tool_to_package=(
					["awk"]="gawk" ["cat"]="coreutils" ["cd"]="coreutils" ["clamscan"]="clamav" ["cifs"]="cifs-utils"
					["cp"]="coreutils" ["cfdisk"]="util-linux" ["df"]="coreutils" ["du"]="coreutils" ["find"]="findutils"
					["free"]="procps-ng" ["fzf"]="fzf" ["grep"]="grep" ["hostname"]="inetutils"
					["htop"]="htop" ["ifconfig"]="net-tools" ["ip"]="iproute2" ["journalctl"]="systemd"
					["less"]="less" ["ls"]="coreutils" ["lsblk"]="util-linux" ["lscpu"]="util-linux" ["lsmem"]="util-linux" ["mount"]="util-linux" ["mv"]="coreutils"
					["netstat"]="net-tools" ["nmtui"]="networkmanager" ["nslookup"]="bind" ["parted"]="parted"
					["ping"]="inetutils" ["ps"]="procps-ng" ["rkhunter"]="rkhunter" ["rm"]="coreutils" ["smbclient"]="samba" ["sudo"]="sudo" ["systemctl"]="systemd" 
					["top"]="procps-ng" ["ufw"]="ufw" ["umount"]="util-linux" ["uname"]="coreutils" ["uptime"]="coreutils" ["vmstat"]="procps-ng" 
					["which"]="coreutils" ["who"]="coreutils"
				)
				;;
			pkg)
				tool_to_package=(
					["awk"]="gawk" ["cat"]="coreutils" ["cd"]="coreutils" ["clamscan"]="clamav" ["cp"]="coreutils"
					["cfdisk"]="sysutils/cfdisk" ["df"]="coreutils" ["du"]="coreutils" ["find"]="coreutils"
					["free"]="procps" ["fzf"]="fzf" ["grep"]="grep" ["hostname"]="coreutils"
					["htop"]="sysutils/htop" ["ifconfig"]="net-tools" ["ip"]="iproute2" ["less"]="less"
					["ls"]="coreutils" ["lsblk"]="util-linux" ["lscpu"]="util-linux" ["lsmem"]="util-linux" ["mv"]="coreutils"
					["netstat"]="net/libnet" ["nmtui"]="net/networkmanager" ["nslookup"]="bind-tools" ["parted"]="parted" ["ping"]="net/inetutils"
					["ps"]="procps" ["rkhunter"]="rkhunter" ["rm"]="coreutils" ["smbclient"]="samba413" ["sudo"]="sudo" ["top"]="procps"
					["ufw"]="net/ufw" ["uname"]="coreutils" ["uptime"]="coreutils" ["vmstat"]="procps" 
					["which"]="coreutils" ["who"]="coreutils"
				)
				;;
			pkg_add)
				tool_to_package=(
					["awk"]="gawk" ["cat"]="coreutils" ["cd"]="coreutils" ["clamscan"]="clamav" ["cp"]="coreutils"
					["cfdisk"]="sysutils/cfdisk" ["df"]="coreutils" ["du"]="coreutils" ["find"]="coreutils"
					["free"]="procps" ["fzf"]="fzf" ["grep"]="grep" ["hostname"]="coreutils"
					["htop"]="sysutils/htop" ["ifconfig"]="net-tools" ["ip"]="iproute2" ["less"]="less"
					["ls"]="coreutils" ["lsblk"]="util-linux" ["lscpu"]="util-linux" ["lsmem"]="util-linux" ["mv"]="coreutils"
					["netstat"]="net/libnet" ["nmtui"]="net/networkmanager" ["nslookup"]="bind" ["parted"]="parted" ["ping"]="net/inetutils"
					["ps"]="procps" ["rcctl"]="openbsd-base" ["rkhunter"]="rkhunter" ["rm"]="coreutils" ["smbclient"]="samba" ["sudo"]="sudo"
					["top"]="procps" ["ufw"]="net/ufw" ["uname"]="coreutils" ["uptime"]="coreutils"
					["vmstat"]="procps" ["which"]="coreutils" ["who"]="coreutils"
				)
				;;
			pkgin)
				tool_to_package=(
					["awk"]="gawk" ["cat"]="coreutils" ["cd"]="coreutils" ["clamscan"]="clamav" ["cp"]="coreutils"
					["cfdisk"]="sysutils/cfdisk" ["df"]="coreutils" ["du"]="coreutils" ["find"]="coreutils"
					["free"]="procps" ["fzf"]="fzf" ["grep"]="grep" ["hostname"]="coreutils"
					["htop"]="sysutils/htop" ["ifconfig"]="net-tools" ["ip"]="iproute2" ["less"]="less"
					["ls"]="coreutils" ["lsblk"]="util-linux" ["lscpu"]="util-linux" ["lsmem"]="util-linux" ["mv"]="coreutils"
					["netstat"]="net/libnet" ["nmtui"]="net/networkmanager" ["nsloookup"]="bind" ["parted"]="parted" ["ping"]="net/inetutils"
					["ps"]="procps" ["rkhunter"]="rkhunter" ["rm"]="coreutils" ["smbclient"]="samba" ["sudo"]="sudo" ["top"]="procps"
					["ufw"]="net/ufw" ["uname"]="coreutils" ["uptime"]="coreutils"
					["vmstat"]="procps" ["which"]="coreutils" ["who"]="coreutils"
				)
				;;
			slackpkg)
				tool_to_package=(
					["awk"]="gawk" ["cat"]="coreutils" ["cd"]="coreutils" ["clamscan"]="clamav" ["cp"]="coreutils"
					["cfdisk"]="util-linux" ["df"]="coreutils" ["du"]="coreutils" ["find"]="findutils"
					["free"]="procps" ["fzf"]="fzf" ["grep"]="grep" ["hostname"]="net-tools"
					["htop"]="htop" ["ifconfig"]="net-tools" ["ip"]="iproute2" ["less"]="less"
					["ls"]="coreutils" ["lsblk"]="util-linux" ["lscpu"]="util-linux" ["lsmem"]="util-linux" ["mount"]="util-linux" 
					["mv"]="coreutils" ["netstat"]="net-tools" ["nmtui"]="networkmanager" ["nslookup"]="bind" ["parted"]="parted" ["ping"]="net-tools"
					["ps"]="procps" ["rkhunter"]="rkhunter" ["rm"]="coreutils" ["service"]="initscripts" ["smbclient"]="samba" ["sudo"]="sudo"
					["top"]="procps" ["ufw"]="ufw" ["umount"]="util-linux" ["uname"]="coreutils" ["uptime"]="coreutils"
					["vmstat"]="procps" ["which"]="coreutils" ["who"]="coreutils"
				)
				;;
			spack)
				tool_to_package=(
					["awk"]="gawk" ["cat"]="coreutils" ["cd"]="coreutils" ["cp"]="coreutils"
					["df"]="coreutils" ["du"]="coreutils" ["find"]="procps" ["free"]="procps-ng"
					["fzf"]="fzf" ["grep"]="grep" ["hostname"]="coreutils" ["less"]="less" ["ls"]="coreutils"
					["mv"]="coreutils" ["netstat"]="net-tools" ["nslookup"]="bind9" ["parted"]="parted" ["ping"]="inetutils" ["ps"]="procps-ng"
					["rm"]="coreutils" ["top"]="procps-ng" ["uname"]="coreutils" ["uptime"]="coreutils"
					["vmstat"]="procps-ng" ["which"]="coreutils" ["who"]="coreutils"
				)
				;;
			zypper)
				tool_to_package=(
					["awk"]="gawk" ["cat"]="coreutils" ["cd"]="coreutils" ["clamscan"]="clamav" ["cifs"]="cifs-utils"
					["cp"]="coreutils" ["cfdisk"]="util-linux" ["df"]="coreutils" ["du"]="coreutils" ["find"]="findutils"
					["free"]="procps" ["fzf"]="fzf" ["grep"]="grep" ["hostname"]="hostname"
					["htop"]="htop" ["ifconfig"]="net-tools" ["ip"]="iproute2" ["journalctl"]="systemd"
					["less"]="less" ["ls"]="coreutils" ["lsblk"]="util-linux" ["lscpu"]="util-linux"
					["lsmem"]="util-linux" ["mount"]="util-linux" ["mv"]="coreutils" ["netstat"]="net-tools" ["nmtui"]="network-manager"
					["nslookup"]="bind-utils" ["parted"]="parted" ["ping"]="iputils" ["ps"]="procps" ["rkhunter"]="rkhunter" ["rm"]="coreutils" ["service"]="initscripts"
					["smbclient"]="samba" ["sudo"]="sudo" ["systemctl"]="systemd" ["top"]="procps" ["ufw"]="ufw" ["umount"]="util-linux"
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

			if ! grep -q "^HOST=" "$ENV_FILE"; then
				echo "HOST=$(hostname)" | tee -a "$ENV_FILE" > /dev/null
			fi
			
			echo "All required tools are already installed..."
			exit 0
		fi
		
		declare -a installed_pkgs=()

		echo "Missing tools: ${missing_tools[*]}"
		prompt_confirm
		unique_packages=($(echo "${missing_packages[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))

		for pkg in "${unique_packages[@]}"; do
			echo "Installing $pkg..."
			$pkg_install "$pkg"
			pkg_log
		done

		if [ ${#installed_pkgs[@]} -gt 0 ]; then
			: > "$LOG_INSTALLED_PKGS"
			echo "${installed_pkgs[*]}" >> "$LOG_INSTALLED_PKGS"
		fi

		
		if ! grep -q "^HOST=" "$ENV_FILE"; then
			echo "HOST=$(hostname)" | tee -a "$ENV_FILE" > /dev/null
		fi
		echo ""
		echo ""
		echo "All required packages have been installed..."
		echo ""
		echo ""
		exit 0
	fi
done

echo "No supported package manager detected..."
exit 1
