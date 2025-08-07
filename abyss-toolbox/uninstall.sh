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

source "$(dirname "$0")/.configs/.env"
source "$FUNC_FILE"

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

read -p "The tools may be gone, but the stain of the oath remains. Shall we begin the purge? [y/N]: " ans
ans=${ans:-N}

if [[ "$ans" =~ ^[nN]$ ]]; then
	oath_banner
	sleep 1
	echo ""
	echo "Wise... few who sever the oath ever find peace again."
	sleep 1
	exit 1
fi

if [[ -z "$PKG_MGR" ]]; then
	echo "No package manager defined in PKG_MGR."
	exit 1
fi

if [[ ! -f "$LOG_INSTALLED_PKGS" ]]; then
	echo "No installed packages log found at $LOG_INSTALLED_PKGS."
	exit 1
fi

read -ra INSTALLED_PKG_LIST < "$LOG_INSTALLED_PKGS"

case "$PKG_MGR" in
	apk)
		for pkg in "${INSTALLED_PKG_LIST[@]}"; do
			echo "Uninstalling $pkg with apk..."
			apk del "$pkg"
		done
		;;
	apt)
		for pkg in "${INSTALLED_PKG_LIST[@]}"; do
			echo "Uninstalling $pkg with apt..."
			apt remove --yes "$pkg"
		done
		;;
	conda)
		for pkg in "${INSTALLED_PKG_LIST[@]}"; do
			echo "Uninstalling $pkg with conda..."
			conda remove --yes "$pkg"
		done
		;;
	dnf)
		for pkg in "${INSTALLED_PKG_LIST[@]}"; do
			echo "Uninstalling $pkg with dnf..."
			dnf remove --assumeyes "$pkg"
		done
		;;
	emerge)
		for pkg in "${INSTALLED_PKG_LIST[@]}"; do
			echo "Uninstalling $pkg with emerge..."
			emerge --unmerge --quiet "$pkg"
		done
		;;
	nix-env)
		for pkg in "${INSTALLED_PKG_LIST[@]}"; do
			echo "Uninstalling $pkg with nix-env..."
			nix-env --uninstall "$pkg"
		done
		;;
	pacman)
		for pkg in "${INSTALLED_PKG_LIST[@]}"; do
			echo "Uninstalling $pkg with pacman..."
			pacman -R --noconfirm "$pkg"
		done
		;;
	pkg)
		for pkg in "${INSTALLED_PKG_LIST[@]}"; do
			echo "Uninstalling $pkg with pkg..."
			pkg delete -y "$pkg"
		done
		;;
	pkgin)
		for pkg in "${INSTALLED_PKG_LIST[@]}"; do
			echo "Uninstalling $pkg with pkgin..."
			pkgin -y remove "$pkg"
		done
		;;
	pkg_add)
		for pkg in "${INSTALLED_PKG_LIST[@]}"; do
			echo "Uninstalling $pkg with pkg_add..."
			pkg_delete -q "$pkg"
		done
		;;
	slackpkg)
		for pkg in "${INSTALLED_PKG_LIST[@]}"; do
			echo "Uninstalling $pkg with slackpkg..."
			slackpkg remove -batch=on "$pkg"
		done
		;;
	spack)
		for pkg in "${INSTALLED_PKG_LIST[@]}"; do
			echo "Uninstalling $pkg with spack..."
			spack uninstall -y "$pkg"
		done
		;;
	yum)
		for pkg in "${INSTALLED_PKG_LIST[@]}"; do
			echo "Uninstalling $pkg with yum..."
			yum remove -y "$pkg"
		done
		;;
	zypper)
		for pkg in "${INSTALLED_PKG_LIST[@]}"; do
			echo "Uninstalling $pkg with zypper..."
			zypper remove --non-interactive "$pkg"
		done
		;;
	*)
		echo "Unsupported package manager: $PKG_MGR"
		exit 1
		;;
esac

echo "All packages that were installed for the toolbox have been uninstalled."
sleep 1

rm -rf /opt/The-Abyss/abyss-toolbox

echo "Toolbox directory removed"
sleep 1

echo "The Abyss Sysadmin Toolbox has been uninstall..."

betrayal_banner

sleep 2

exit 0
