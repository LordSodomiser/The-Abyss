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

ENV_FILE=".configs/.env"

if [[ ! -f "$ENV_FILE" ]]; then
	echo "Error: .env file not found at $ENV_FILE"
	exit 1
fi
source "$ENV_FILE"

if ! grep -q "^HOST=" "$ENV_FILE"; then
	echo "HOST=$(hostname)" >> "$ENV_FILE"
fi

if ! source "$ENV_FILE"; then
	echo "Error: Failed to source $ENV_FILE after updating"
	exit 1
fi

for var in INSTALL_PATH SOURCE_SCRIPT FUNC_FILE ENV_FILE DOWNLOAD_PATH TOOLBOX_PATH LOG_DIR LOG_FILE; do
	if [[ -z "${!var}" ]]; then
		echo "Error: Required variable $var is not defined in .env file."
		exit 1
	fi
done

for file in toolbox.sh functions.sh; do
	if [[ ! -f "$file" ]]; then
		echo "Error: $file not found in the current directory."
		exit 1
	fi
done

mkdir -p "$LOG_DIR"
touch "$LOG_FILE"
chmod 644 "$LOG_FILE"
chown root:root "$LOG_FILE"

mv "$DOWNLOAD_PATH" "$INIT_PATH"
ln -sf "$SOURCE_SCRIPT" "$INSTALL_PATH"
chmod +x "$SOURCE_SCRIPT"


echo "$(date): Toolbox installed at $INSTALL_PATH" >> "$LOG_FILE"
echo "Installation complete. You can now run: cystoolbox"
echo ""

read -rp "Run installation cleanup? [Y/n]: " confirm
if [[ ! "$confirm" =~ ^[Nn]$ ]]; then
    shopt -s nullglob
    for file in "$OG_FILE" "$INIT_FILE" "$INST_FILE"; do
        if [[ -e "$file" ]]; then
            rm -f "$file" || echo "Warning: Failed to remove $file" >&2
        fi
    done
    shopt -u nullglob
fi

echo "Installation complete..."
echo "$(date): Installation completed" >> "$LOG_FILE"
