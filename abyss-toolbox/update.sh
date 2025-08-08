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

if [[ $EUID -ne 0 ]]; then
	echo "Root privileges are required to run this script."
	read -t 30 -rp "Do you want to run it with sudo now? [Y/n]: " ans
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

ENV_FILE="/opt/The-Abyss/abyss-toolbox/.configs/.env"
SRC_DIR=$(cd "$(dirname "$0")" && pwd)
DEST_DIR=/opt/The-Abyss/abyss-toolbox

if [[ ! -f "$ENV_FILE" ]]; then
	echo "Error: .env file not found at $ENV_FILE"
	exit 1
fi

if [[ ! -r "$ENV_FILE" ]]; then
	echo "Error: .env file at $ENV_FILE is not readable"
	exit 1
fi

if ! source "$ENV_FILE"; then
	echo "Error: Failed to source $ENV_FILE"
	exit 1
fi

if [[ ! -w "$ENV_FILE" ]]; then
	echo "Error: Cannot write to $ENV_FILE"
	exit 1
fi

if ! grep -q "^HOST=" "$ENV_FILE"; then
	echo "HOST=$(hostname)" >> "$ENV_FILE"
fi

source "$ENV_FILE"

sed -i "/^SRC_DIR=/d" "$ENV_FILE"
echo "SRC_DIR=\"$SRC_DIR\"" >> "$ENV_FILE"

if ! grep -q "^DEST_DIR=" "$ENV_FILE"; then
	echo "DEST_DIR=\"/opt/The-Abyss/abyss-toolbox\"" >> "$ENV_FILE"
fi

sed -i "/^SRC_TOOLBOX=/d" "$ENV_FILE"
echo "SRC_TOOLBOX=\"$SRC_DIR/toolbox.sh\"" >> "$ENV_FILE"

sed -i "/^SRC_FUNCTIONS=/d" "$ENV_FILE"
echo "SRC_FUNCTIONS=\"$SRC_DIR/functions.sh\"" >> "$ENV_FILE"

if ! grep -q "^DEST_TOOLBOX=" "$ENV_FILE"; then
	echo "DEST_TOOLBOX=\"$DEST_DIR/toolbox.sh\"" >> "$ENV_FILE"
fi

if ! grep -q "^DEST_FUNCTIONS=" "$ENV_FILE"; then
	echo "DEST_FUNCTIONS=\"$DEST_DIR/functions.sh\"" >> "$ENV_FILE"
fi

for pkg_mgr in apk apt conda dnf emerge nix-env pacman pkg pkgin pkg_add slackpkg spack yum zypper; do
	if command -v "$pkg_mgr" &>/dev/null; then
		if ! grep -q "^PKG_MGR=" "$ENV_FILE";then
			echo "PKG_MGR=$pkg_mgr" >> "$ENV_FILE"
		fi
	fi
done

if ! source "$ENV_FILE"; then
	echo "Error: Failed to source $ENV_FILE after updating"
	exit 1
fi

required_vars=(SRC_TOOLBOX SRC_FUNCTIONS DEST_TOOLBOX DEST_FUNCTIONS LOG_FILE)
for var in "${required_vars[@]}"; do
	if [[ -z "${!var:-}" ]]; then
		echo "Error: Required variable $var is not set in .env"
		exit 1
	fi
done

for file in "$SRC_TOOLBOX" "$SRC_FUNCTIONS"; do
    if [[ ! -f "$file" ]]; then
        echo "Source file not found: $file"
        exit 1
    fi
done

if [[ ! -d "$DEST_DIR" ]]; then
	echo "Error: Destination directory $DEST_DIR does not exist"
	exit 1
fi

if [[ ! -w "$DEST_DIR" ]]; then
	echo "Error: Destination directory $DEST_DIR is not writable"
	exit 1
fi

echo "Updating toolbox..."
echo ""
echo ""
sleep 2

install -m 755 "$SRC_TOOLBOX" "$DEST_TOOLBOX"
install -m 755 "$SRC_FUNCTIONS" "$DEST_FUNCTIONS"

echo "$(date '+%Y-%m-%d %H:%M:%S'): Updated toolbox and functions." >> "$LOG_FILE"
echo "Update complete!"
echo""
echo""
echo "Continue using the toolbox by running: cystoolbox"
