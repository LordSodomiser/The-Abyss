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

set -euo pipefail

if [[ $EUID -ne 0 ]]; then
	echo "Root privileges are required to run this initialization."
	read -rp "Do you want to run it with sudo now? [y/N]: " ans
	if [[ "$ans" =~ ^[Yy]$ ]]; then
		exec sudo "$0" "$@"
	else
		echo "Exiting..."
		exit 1
	fi
fi

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
		echo "Detected $pkg_mgr package manager..."
		case "$pkg_mgr" in
			apk)
				required_tools=(awk cat cd cp cfdisk df du find free fzf grep hostname htop ifconfig ip less ls lsblk mv netstat nmtui ping ps rm service sudo top ufw uname uptime vmstat which who)
				pkg_install="sudo apk add -y"
				;;
			apt)
				required_tools=(awk cat cd cp cfdisk df du find free fzf grep hostname htop ifconfig ip journalctl less ls lsblk lscpu lsmem mv netstat nmtui ping ps rm service sudo systemctl top ufw uname uptime vmstat which who)
				pkg_install="sudo apt install -y"
				;;
			conda)
				required_tools=(awk cat cd cp df du find free fzf grep hostname less ls mv netstat ping ps rm top uname uptime vmstat which who)
				pkg_install="conda install -c conda-forge"
				;;
			dnf)
				required_tools=(awk cat cd cp cfdisk df du find free fzf grep hostname htop ifconfig ip journalctl less ls lsblk lscpu lsmem mv netstat nmtui ping ps rm service sudo systemctl top ufw uname uptime vmstat which who)
				pkg_install="sudo $pkg_mgr install -y"
				;;
			emerge)
				required_tools=(awk cat cd cp cfdisk df du find free fzf grep hostname htop ifconfig ip journalctl less ls lsblk lscpu lsmem mv netstat nmtui ping ps rm service sudo systemctl top ufw uname uptime vmstat which who)
				pkg_install="sudo emerge --ask n"
				;;
			nix-env)
				required_tools=(awk cat cd cp df du find free fzf grep hostname less ls mv ping ps top uname uptime vmstat which who)
				pkg_install="nix-env -iA"
				;;
			pacman)
				required_tools=(awk cat cd cp cfdisk df du find free fzf grep hostname htop ifconfig ip journalctl less ls lsblk lscpu lsmem mv netstat nmtui ping ps rm sudo systemctl top ufw uname uptime vmstat which who)
				pkg_install="sudo pacman -S --noconfirm"
				;;
			pkg)
				required_tools=(awk cat cd cp cfdisk df du find free fzf grep hostname htop ifconfig ip less ls lsblk lscpu lsmem mv netstat nmtui ping ps rm sudo top ufw uname uptime vmstat which who)
				pkg_install="sudo pkg install"
				;;
			pkg_add)
				required_tools=(awk cat cd cp cfdisk df du find free fzf grep hostname htop ifconfig ip less ls lsblk lscpu lsmem mv netstat nmtui ping ps rcctl rm sudo top ufw uname uptime vmstat which who)
				pkg_install="sudo pkg_add"
				;;
			pkgin|pkgin_add)
				required_tools=(awk cat cd cp cfdisk df du find free fzf grep hostname htop ifconfig ip less ls lsblk lscpu lsmem mv netstat nmtui ping ps rm sudo top ufw uname uptime vmstat which who)
				pkg_install="sudo pkgin install"
				;;
			slackpkg)
				required_tools=(awk cat cd cp cfdisk df du find free fzf grep hostname htop ifconfig ip less lsblk lscpu lsmem mv netstat nmtui ping ps rm service sudo top ufw uname uptime vmstat which who)
				pkg_install="sudo slackpkg install -batch=on"
				;;
			spack)
				required_tools=(awk cat cd cp df du find free fzf grep hostname less ls mv netstat ping ps rm top uname uptime vmstat which who)
				pkg_install="spack install"
				;;
			yum)
				required_tools=(awk cat cd cp cfdisk df du find free fzf grep hostname htop ifconfig ip journalctl less ls lsblk lscpu lsmem mv netstat nmtui ping ps rm service sudo systemctl top ufw uname uptime vmstat which who)
				pkg_install="sudo yum install -y"
				;;
			zypper)
				required_tools=(awk cat cd cp cfdisk df du find free fzf grep hostname htop ifconfig ip journalctl less ls lsblk lscpu lsmem mv netstat nmtui ping ps rm service sudo systemctl top ufw uname uptime vmstat which who)
				pkg_install="sudo zypper install --non-interactive"
				;;
		esac

		missing_tools=()
		missing_packages=()
		declare -A tool_to_package
		case "$pkg_mgr" in
			apk)
				tool_to_package=(
					["awk"]="busybox" ["cat"]="busybox" ["cd"]="busybox" ["cp"]="busybox"
					["cfdisk"]="util-linux" ["df"]="busybox" ["du"]="busybox" ["find"]="findutils"
					["free"]="procps" ["fzf"]="fzf" ["grep"]="busybox" ["hostname"]="busybox"
					["htop"]="htop" ["ifconfig"]="net-tools" ["ip"]="iproute2" ["less"]="busybox"
					["ls"]="busybox" ["lsblk"]="util-linux" ["mv"]="busybox" ["netstat"]="net-tools"
					["nmtui"]="networkmanager" ["ping"]="busybox" ["ps"]="procps" ["rm"]="busybox"
					["service"]="initscripts" ["sudo"]="sudo" ["top"]="procps" ["ufw"]="ufw"
					["uname"]="busybox" ["vmstat"]="procps" ["which"]="busybox" ["who"]="busybox"
				)
				;;
			apt)
				tool_to_package=(
					["awk"]="gawk" ["cat"]="coreutils" ["cd"]="coreutils" ["cp"]="coreutils"
					["cfdisk"]="util-linux" ["df"]="coreutils" ["du"]="coreutils" ["find"]="findutils"
					["free"]="procps" ["fzf"]="fzf" ["grep"]="grep" ["hostname"]="inetutils-tools"
					["htop"]="htop" ["ifconfig"]="net-tools" ["ip"]="iproute2" ["journalctl"]="systemd"
					["less"]="less" ["ls"]="coreutils" ["lsblk"]="util-linux" ["lscpu"]="util-linux"
					["lsmem"]="util-linux" ["mv"]="coreutils" ["netstat"]="net-tools" ["nmtui"]="network-manager"
					["ping"]="inetutils" ["ps"]="procps" ["rm"]="coreutils" ["service"]="initscripts"
					["sudo"]="sudo" ["systemctl"]="systemd" ["top"]="procps" ["ufw"]="ufw"
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
					["awk"]="gawk" ["cat"]="coreutils" ["cd"]="coreutils" ["cp"]="coreutils"
					["cfdisk"]="util-linux" ["df"]="coreutils" ["du"]="coreutils" ["find"]="findutils"
					["free"]="procps-ng" ["fzf"]="fzf" ["grep"]="grep" ["hostname"]="hostname"
					["htop"]="htop" ["ifconfig"]="net-tools" ["ip"]="iproute" ["journalctl"]="systemd"
					["less"]="less" ["ls"]="coreutils" ["lsblk"]="util-linux" ["lscpu"]="util-linux"
					["lsmem"]="util-linux" ["mv"]="coreutils" ["netstat"]="net-tools" ["nmtui"]="NetworkManager-tui"
					["ping"]="iputils" ["ps"]="procps-ng" ["rm"]="coreutils" ["service"]="initscripts"
					["sudo"]="sudo" ["systemctl"]="systemd" ["top"]="procps-ng" ["ufw"]="ufw"
					["uname"]="coreutils" ["uptime"]="coreutils" ["vmstat"]="procps-ng" ["which"]="coreutils" ["who"]="coreutils"
				)
				;;
			emerge)
				tool_to_package=(
					["awk"]="sys-apps/gawk" ["cat"]="sys-apps/coreutils" ["cd"]="sys-apps/coreutils"
					["cp"]="sys-apps/coreutils" ["cfdisk"]="sys-apps/util-linux" ["df"]="sys-apps/coreutils"
					["du"]="sys-apps/coreutils" ["find"]="sys-apps/findutils" ["free"]="sys-process/procps"
					["fzf"]="app-misc/fzf" ["grep"]="sys-apps/grep" ["hostname"]="sys-apps/inetutils"
					["htop"]="sys-process/htop" ["ifconfig"]="sys-apps/net-tools" ["ip"]="sys-apps/iproute2"
					["journalctl"]="sys-apps/systemd" ["less"]="sys-apps/less" ["ls"]="sys-apps/coreutils"
					["lsblk"]="sys-apps/util-linux" ["lscpu"]="sys-apps/util-linux" ["lsmem"]="sys-apps/util-linux"
					["mv"]="sys-apps/coreutils" ["netstat"]="sys-apps/net-tools" ["nmtui"]="net-misc/networkmanager"
					["ping"]="sys-apps/inetutils" ["ps"]="sys-process/procps" ["rm"]="sys-apps/coreutils"
					["service"]="sys-apps/sysvinit" ["sudo"]="app-admin/sudo" ["systemctl"]="sys-apps/systemd"
					["top"]="sys-process/procps" ["ufw"]="net-misc/ufw" ["uname"]="sys-apps/coreutils" ["uptime"]="sys-apps/coreutils"
					["vmstat"]="sys-process/procps" ["which"]="sys-apps/coreutils" ["who"]="sys-apps/coreutils"
				)
				;;
			nix-env)
				tool_to_package=(
					["awk"]="nixpkgs.gawk" ["cat"]="nixpkgs.coreutils" ["cd"]="nixpkgs.coreutils"
					["cp"]="nixpkgs.coreutils" ["df"]="nixpkgs.coreutils" ["du"]="nixpkgs.coreutils"
					["find"]="nixpkgs.findutils" ["free"]="nixpkgs.procps" ["fzf"]="nixpkgs.fzf"
					["grep"]="nixpkgs.grep" ["hostname"]="nixpkgs.coreutils" ["less"]="nixpkgs.less"
					["ls"]="nixpkgs.coreutils" ["mv"]="nixpkgs.coreutils" ["netstat"]="nixpkgs.net-tools"
					["ping"]="nixpkgs.inetutils" ["ps"]="nixpkgs.procps" ["rm"]="nixpkgs.coreutils"
					["top"]="nixpkgs.procps" ["uname"]="nixpkgs.coreutils" ["uptime"]="nixpkgs.coreutils"
					["vmstat"]="nixpkgs.procps" ["which"]="nixpkgs.coreutils" ["who"]="nixpkgs.coreutils"
				)
				;;
			pacman)
				tool_to_package=(
					["awk"]="gawk" ["cat"]="coreutils" ["cd"]="coreutils" ["cp"]="coreutils"
					["cfdisk"]="util-linux" ["df"]="coreutils" ["du"]="coreutils" ["find"]="findutils"
					["free"]="procps-ng" ["fzf"]="fzf" ["grep"]="grep" ["hostname"]="inetutils"
					["htop"]="htop" ["ifconfig"]="net-tools" ["ip"]="iproute2" ["journalctl"]="systemd"
					["less"]="less" ["ls"]="coreutils" ["lsblk"]="util-linux" ["lscpu"]="util-linux"
					["lsmem"]="util-linux" ["mv"]="coreutils" ["netstat"]="net-tools" ["nmtui"]="networkmanager"
					["ping"]="inetutils" ["ps"]="procps-ng" ["rm"]="coreutils" ["sudo"]="sudo" ["systemctl"]="systemd" 
					["top"]="procps-ng" ["ufw"]="ufw" ["uname"]="coreutils" ["uptime"]="coreutils" ["vmstat"]="procps-ng" 
					["which"]="coreutils" ["who"]="coreutils"
				)
				;;
			pkg)
				tool_to_package=(
					["awk"]="gawk" ["cat"]="coreutils" ["cd"]="coreutils" ["cp"]="coreutils"
					["cfdisk"]="sysutils/cfdisk" ["df"]="coreutils" ["du"]="coreutils" ["find"]="coreutils"
					["free"]="procps" ["fzf"]="fzf" ["grep"]="grep" ["hostname"]="coreutils"
					["htop"]="sysutils/htop" ["ifconfig"]="net-tools" ["ip"]="iproute2" ["less"]="less"
					["ls"]="coreutils" ["lsblk"]="util-linux" ["lscpu"]="util-linux" ["lsmem"]="util-linux"
					["mv"]="coreutils" ["netstat"]="net/libnet" ["nmtui"]="net/networkmanager" ["ping"]="net/inetutils"
					["ps"]="procps" ["rm"]="coreutils" ["sudo"]="sudo" ["top"]="procps"
					["ufw"]="net/ufw" ["uname"]="coreutils" ["uptime"]="coreutils" ["vmstat"]="procps" 
					["which"]="coreutils" ["who"]="coreutils"
				)
				;;
			pkg_add)
				tool_to_package=(
					["awk"]="gawk" ["cat"]="coreutils" ["cd"]="coreutils" ["cp"]="coreutils"
					["cfdisk"]="sysutils/cfdisk" ["df"]="coreutils" ["du"]="coreutils" ["find"]="coreutils"
					["free"]="procps" ["fzf"]="fzf" ["grep"]="grep" ["hostname"]="coreutils"
					["htop"]="sysutils/htop" ["ifconfig"]="net-tools" ["ip"]="iproute2" ["less"]="less"
					["ls"]="coreutils" ["lsblk"]="util-linux" ["lscpu"]="util-linux" ["lsmem"]="util-linux"
					["mv"]="coreutils" ["netstat"]="net/libnet" ["nmtui"]="net/networkmanager" ["ping"]="net/inetutils"
					["ps"]="procps" ["rcctl"]="openbsd-base" ["rm"]="coreutils" ["sudo"]="sudo"
					["top"]="procps" ["ufw"]="net/ufw" ["uname"]="coreutils" ["uptime"]="coreutils"
					["vmstat"]="procps" ["which"]="coreutils" ["who"]="coreutils"
				)
				;;
			pkgin|pkgin_add)
				tool_to_package=(
					["awk"]="gawk" ["cat"]="coreutils" ["cd"]="coreutils" ["cp"]="coreutils"
					["cfdisk"]="sysutils/cfdisk" ["df"]="coreutils" ["du"]="coreutils" ["find"]="coreutils"
					["free"]="procps" ["fzf"]="fzf" ["grep"]="grep" ["hostname"]="coreutils"
					["htop"]="sysutils/htop" ["ifconfig"]="net-tools" ["ip"]="iproute2" ["less"]="less"
					["ls"]="coreutils" ["lsblk"]="util-linux" ["lscpu"]="util-linux" ["lsmem"]="util-linux"
					["mv"]="coreutils" ["netstat"]="net/libnet" ["nmtui"]="net/networkmanager" ["ping"]="net/inetutils"
					["ps"]="procps" ["rm"]="coreutils" ["sudo"]="sudo" ["top"]="procps"
					["ufw"]="net/ufw" ["uname"]="coreutils" ["uptime"]="coreutils"
					["vmstat"]="procps" ["which"]="coreutils" ["who"]="coreutils"
				)
				;;
			slackpkg)
				tool_to_package=(
					["awk"]="gawk" ["cat"]="coreutils" ["cd"]="coreutils" ["cp"]="coreutils"
					["cfdisk"]="util-linux" ["df"]="coreutils" ["du"]="coreutils" ["find"]="findutils"
					["free"]="procps" ["fzf"]="fzf" ["grep"]="grep" ["hostname"]="net-tools"
					["htop"]="htop" ["ifconfig"]="net-tools" ["ip"]="iproute2" ["less"]="less"
					["ls"]="coreutils" ["lsblk"]="util-linux" ["lscpu"]="util-linux" ["lsmem"]="util-linux"
					["mv"]="coreutils" ["netstat"]="net-tools" ["nmtui"]="networkmanager" ["ping"]="net-tools"
					["ps"]="procps" ["rm"]="coreutils" ["service"]="initscripts" ["sudo"]="sudo"
					["top"]="procps" ["ufw"]="ufw" ["uname"]="coreutils" ["uptime"]="coreutils"
					["vmstat"]="procps" ["which"]="coreutils" ["who"]="coreutils"
				)
				;;
			spack)
				tool_to_package=(
					["awk"]="gawk" ["cat"]="coreutils" ["cd"]="coreutils" ["cp"]="coreutils"
					["df"]="coreutils" ["du"]="coreutils" ["find"]="procps" ["free"]="procps-ng"
					["fzf"]="fzf" ["grep"]="grep" ["hostname"]="coreutils" ["less"]="less" ["ls"]="coreutils"
					["mv"]="coreutils" ["netstat"]="net-tools" ["ping"]="inetutils" ["ps"]="procps-ng"
					["rm"]="coreutils" ["top"]="procps-ng" ["uname"]="coreutils" ["uptime"]="coreutils"
					["vmstat"]="procps-ng" ["which"]="coreutils" ["who"]="coreutils"
				)
				;;
			zypper)
				tool_to_package=(
					["awk"]="gawk" ["cat"]="coreutils" ["cd"]="coreutils" ["cp"]="coreutils"
					["cfdisk"]="util-linux" ["df"]="coreutils" ["du"]="coreutils" ["find"]="findutils"
					["free"]="procps" ["fzf"]="fzf" ["grep"]="grep" ["hostname"]="hostname"
					["htop"]="htop" ["ifconfig"]="net-tools" ["ip"]="iproute2" ["journalctl"]="systemd"
					["less"]="less" ["ls"]="coreutils" ["lsblk"]="util-linux" ["lscpu"]="util-linux"
					["lsmem"]="util-linux" ["mv"]="coreutils" ["netstat"]="net-tools" ["nmtui"]="network-manager"
					["ping"]="iputils" ["ps"]="procps" ["rm"]="coreutils" ["service"]="initscripts"
					["sudo"]="sudo" ["systemctl"]="systemd" ["top"]="procps" ["ufw"]="ufw"
					["uname"]="coreutils" ["vmstat"]="procps" ["which"]="coreutils" ["who"]="coreutils"
				)
				;;
		esac

		missing_tools=()
		missing_packages=()
		for tool in "${required_tools[@]}"; do
			if ! command -v "$tool" &>/dev/null && [[ "$tool" != "rcctl" || "$pkg_mgr" == "pkg_add" ]]; then
			missing_tools+=("$tool")
			missing_packages+=("${tool_to_package[$tool]}")
			fi
		done

		if [ ${#missing_tools[@]} -eq 0 ]; then
			echo "All required tools are already installed..."
			exit 0
		fi
prompt_confirm
		echo "Missing tools: ${missing_tools[*]}"
		unique_packages=($(echo "${missing_packages[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
		for pkg in "${unique_packages[@]}"; do
			echo "Installing $pkg..."
			$pkg_install "$pkg"
		done
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
