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
	echo "Root privileges are required to run this script."
	read -rp "Do you want to run it with sudo now? [y/N]: " answer
	if [[ "$answer" =~ ^[Yy]$ ]]; then
		exec sudo "$0" "$@"
	else
		echo "Exiting..."
		exit 1
	fi
fi
 
source "$(dirname "$0")/.configs/.env"

mv "$DOWNLOAD_PATH" "$TOOLBOX_PATH"

mkdir -p "$LOG_DIR"
touch "$LOG_FILE"
chmod 640 "$LOG_FILE"
chown root:root "$LOG_FILE"

if [[ -e "$INSTALL_PATH" || -L "$INSTALL_PATH" ]]; then
	echo "The Abyss Sysadmin Toolbox is already installed at $INSTALL_PATH"
	read -rp "Do you want to overwrite the link? [y/N]: " ans
	if [[ "$ans" =~ ^[Yy]$ ]]; then
		echo "Overwriting symlink..."
		ln -sf "$SOURCE_SCRIPT" "$INSTALL_PATH"
		chmod +x "$SOURCE_SCRIPT"
		echo "Toolbox symlink updated. You can now run it with: toolbox"
	else
		echo "Installation aborted. You can continue using the existing toolbox command."
		exit 0
	fi
else
	ln -s "$SOURCE_SCRIPT" "$INSTALL_PATH"
	chmod +x "$SOURCE_SCRIPT"
	echo "Toolbox symlink created. You can now run it with: cystoolbox"
fi

echo "Installation complete..."
sleep 2

echo ""

read -rp "Run installation cleanup? [Y/n]: " confirm
[[ "$confirm" =~ ^[Nn]$ ]] || rm -rf /tmp/abyss_toolbox-0.1.0.tar.xz /opt/The-Abyss/abyss-toolbox/initialize.sh /opt/The-Abyss/abyss-toolbox/install.sh

sleep 1

echo ""

sleep 1
