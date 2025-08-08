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

source "$(dirname "$(readlink -f "$0")")/.configs/.env"
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
ENV_FILE="$SCRIPT_DIR/.configs/.env"

log() {
	echo "$(date '+%Y-%m-%d %H:%M:%S') - $TOOLBOX_USER - $*" >> "$LOG_FILE"
}

setup_traps() {
	trap  'echo "Interrupted (Ctrl+C)"; exit 1' INT
	trap 'echo "Terminated"; exit 1' TERM
	trap 'echo "Error on line $LINENO"; exit 1' ERR
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

		if [[ -z "$choice" ]]; then
			echo "No selection made. Returning to main menu..."
			sleep 2
			break
		fi

		case "$choice" in
			"Check Disk Free Space")
				cmd="df -h"
				log "$TOOLBOX_USER viewed disk info using '$cmd'"
				echo "[$TOOLBOX_USER@$HOST]$ $cmd"
				echo ""
				echo ""
				$cmd | tee -a "$LOG_FILE"
				sleep 1
				echo ""
				echo ""
				read -rp "Press enter to return..."
				;;
			"Check Disk Usage")
				path_choice=$(echo -e "Back\nRoot Disk\nCustom Path\nAll Mounted Filesystems" | fzf)
				if [[ -z "$path_choice" ]]; then
					echo "No path selected. Returning to disk management menu..."
					sleep 2
					continue
				fi
				case "$path_choice" in
					"All Mounted Filesystems")
						cmd="df -h"
						log "$TOOLBOX_USER viewed disk usage using $cmd"
						echo "[$TOOLBOX_USER@$HOST]$ $cmd"
						echo ""
						echo ""
						$cmd 2>/dev/null | tee -a "$LOG_FILE"
						sleep 1
						echo ""
						echo ""
						read -rp "Press enter to return..."
						;;
					"Custom Path")
						read -p "Enter directory path to check (or press Enter for current directory): " path
						path=${path:-.}
						if [[ -d "$path" ]]; then
							cmd="du -h --max-depth=1 $path"
							log "$TOOLBOX_USER viewed disk usage using '$cmd'"
							echo "[$TOOLBOX_USER@$HOST]$ $cmd"
							echo ""
							echo ""
							$cmd 2>/dev/null | tee -a "$LOG_FILE"
							sleep 1
							echo ""
							echo ""
							read -rp "Press enter to return..."
						else
							echo "Invalid directory: $path"
							sleep 2
						fi
						;;
					"Root Disk")
						path="/"
						cmd="df -h $path"
						log "$TOOLBOX_USER viewed disk usage using '$cmd'"
						echo "[$TOOLBOX_USER@$HOST]$ $cmd"
						echo ""
						echo ""
						$cmd 2>/dev/null | tee -a "$LOG_FILE"
						sleep 1
						echo ""
						echo ""
						read -rp "Press enter to return..."
						;;
					"Back")
						continue
						;;
				esac
				;;
			"List Block Devices")
				cmd="lsblk"
				log "$TOOLBOX_USER viewed disk info using '$cmd'"
				echo "[$TOOLBOX_USER@$HOST]$ $cmd"
				echo ""
				echo ""
				$cmd | tee -a "$LOG_FILE"
				sleep 1
				echo ""
				echo ""

				echo "You can either mount a device to an existing mount point,"
				echo "create a new one, or unmount a device."

				read -p "Would you like to mount or unmount a device? (mount/unmount, n/N): " mount_ans
				mount_ans=${mount_ans:-N}
				if [[ "$mount_ans" =~ ^[nN]$ ]]; then
					echo "Returning to menu..."
					echo ""
					echo ""
					sleep 2
					continue
				fi

				if [[ "$mount_ans" == "mount" ]]; then
					read -p "Do you want to create the mount point in the /mnt dir? (Y/n): " ans
					ans=${ans:-Y}

					if [[ "$ans" =~ ^([yY]|[Yy][Ee][Ss])$ ]]; then
						read -p "Name the mount point for /mnt/... (e.g., usb, nas): " name
						if [[ -n "$name" ]]; then
							mkdir -p "/mnt/$name"
							mount_target="/mnt/$name"
						else
							echo "No name provided. Skipping ..."
							sleep 2
						fi
					elif [[ "$ans" =~ ^[nN]$ ]]; then
						while true; do
							read -p "Do you want to use an existing mount point? (Y/n): " ans
							ans=${ans:-Y}
							
							if [[ "$ans" =~ ^[yY]$ ]]; then
								read -p "To use an existing mount point enter it now. (e.g., /mnt/usb): " ex_mount
								if [[ -n "$ex_mount" && -d "$ex_mount" ]]; then
									mount_target="$ex_mount"
									echo "Mount target set to $mount_target"
									skip_new_mount_prompt=true
									break
								else
									echo "Invalid or no path provided. Please try again..."
									sleep 2
								fi		
							else
								echo "Returning to menu..."
								sleep 2
								break
							fi
						done
					fi
					
					if [[ -z "$mount_target" && "$skip_new_mount_prompt" != "true" ]]; then
						read -p "Do you want to create a new mount point? (y/N): " ans
						if [[ "$ans" =~ ^[yY]$ ]]; then
							read -p "Enter full path for new mount point (e.g., /new/mount/point): " newmount
							if [[ -n "$newmount" ]]; then
								mkdir -p "$newmount"
								mount_target="$newmount"
							else
								echo "No path provided. Skipping..."
								sleep 2
							fi
						else
							echo "No mount point selected. Skipping..."
							sleep 2
						fi
					fi
				elif [[ "$mount_ans" == "unmount" ]]; then
					read -p "Enter full path to unmount (e.g., /mnt/usb): " unmount_point
					if [[ -d "$unmount_point" ]]; then
						cmd="umount $unmount_point"
						log "$TOOLBOX_USER used '$cmd' to unmount $unmount_point"
						echo ""
						echo ""
						echo "[$TOOLBOX_USER@$HOST]$ $cmd"
						$cmd | tee -a "$LOG_FILE" || true
						sleep 1
						echo ""
						echo ""
					else
						echo "Invalid or non-existent path..."
						sleep 2
					fi
				fi

				read -p "Would you like to mount an SMB network share or device? (smb/device): " mount_type
					
				if [[ "$mount_type" == "smb" ]]; then
					read -p "Do you have an existing SMB credential file? [y/N]: " ans
					ans=${ans:-N}

					if [[ "$ans" =~ ^[nN]$ ]]; then

					echo "Please create your credential file..."
					read -p "Please enter your SMB share UID (default uid=${SUDO_UID:-$(id -u)}): " uid
					uid=${uid:-${SUDO_UID:-$(id -u)}}

					read -p "Please enter your SMB share GID (default gid=${SUDO_GID:-$(id -g)}): " gid
					gid=${SUDO_GID:-$(id -g)}

					read -p "Please enter your SMB share username: " username
					read -p "Please enter your SMB share password: " password
					read -p "Please enter your SMB share domain (optional): " domain
					read -p "Where would you like to put the credentials file? (default /home/$TOOLBOX_USER/.smbcred): " smb_cred_loc
					smb_cred_loc=${smb_cred_loc:-/home/$TOOLBOX_USER/.smbcred}
		
					if [[ -n "$username" && -n "$password" && -n "$smb_cred_loc" ]]; then
						cat <<EOF | tee "$smb_cred_loc" > /dev/null
username=$username
password=$password
$( [[ -n "$domain" ]] && echo "domain=$domain" )
EOF
							chown $TOOLBOX_USER:$TOOLBOX_USER "$smb_cred_loc"	
							chmod 600 "$smb_cred_loc"
						
							read -p "Enter SMB share path (e.g., //server/share): " smb_share
							if [[ -n "$smb_share" && -d "$mount_target" ]]; then
								cmd="mount -t cifs $smb_share $mount_target -o credentials=$smb_cred_loc,uid=$uid,gid=$gid,rw,vers=3.0"
								log "$TOOLBOX_USER mounted SMB share using $cmd"
								echo ""
								echo "[$TOOLBOX_USER@$HOST]$ $cmd"
								$cmd
								sleep 1
								echo ""
								echo ""

								read -p "Do you want to add this SMB mount to fstab? (y/N): " fstab
								if [[ "$fstab" =~ ^[yY]$ ]]; then
									entry="$smb_share $mount_target cifs credentials=$smb_cred_loc,uid=$uid,gid=$gid,x-systemd.automount 0 0"
									echo "$entry" | tee -a /etc/fstab
									log "$TOOLBOX_USER added SMB mount to fstab"
									systemctl daemon-reload
									mount -a
									echo ""
									echo ""
								fi
							else
								echo "Invalid SMB share or mount point..."
								sleep 2
							fi
						else
							echo "Missing credentials info. Skipping..."
							sleep 2
						fi
					elif [[ "$ans" =~ ^[yY]$ ]]; then
						read -p "Please enter the correct existing SMB credential file now: " ex_creds
						if [[ -n "$ex_creds" && -f "$ex_creds" ]]; then
							read -p "Please enter your SMB share UID (default uid=${SUDO_UID:-$(id -u)}): " uid
							uid=${uid:-${SUDO_UID:-$(id -u)}}
							read -p "Please enter your SMB share GID (default gid=${SUDI_GID:-$(id -g)}): " gid
							gid=${gid:-${SUDO_GID:-$(id -g)}}
							read -p "Enter SMB share path (e.g., //server/share): " smb_share
							if [[ -n "$smb_share" && -d "$mount_target" ]]; then
							cmd="mount -t cifs $smb_share $mount_target -o credentials=$ex_creds,uid=$uid,gid=$gid,rw,vers=3.0"
							       log "$TOOLBOX_USER mounted SMB share using $cmd"
							       echo ""
							       echo "[$TOOLBOX_USER@$HOST]$ $cmd"
							       $cmd
							       sleep 1
							       echo ""
							       echo ""
						
							       read -p "Do you want to add this SMB mount to fstab? (y/N): " fstab
							       if [[ "$fstab" =~ ^[yY]$ ]]; then
								       entry="$smb_share $mount_target cifs credentials=$ex_creds,uid=$uid,gid=$gid,x-systemd.automount 0 0"
								       echo "$entry" | tee -a /etc/fstab
								       log "$TOOLBOX_USER added SMB mount to fstab"
								       systemctl daemon-reload
								       mount -a
								       echo ""
								       echo ""
							       fi
						       else
							       echo "Invalid SMB share or mount point..."
							       sleep 2
							       echo ""
							       echo""
						       fi
					       else
						       echo "Invalid SMB share, mount point or credential file path..."
						       sleep 2
						       echo ""
						       echo ""
						       read -rp "Press enter to return..."
						fi
					fi
				elif [[ "$mount_type" == "device" ]]; then
				       	read -p "Enter device path (e.g., /dev/sda1, /dev/nvme0n1): " device
					if [[ -b "$device" && -d "$mount_target" ]]; then
						cmd="mount $device $mount_target"
						log "$TOOLBOX_USER mounted drive using $cmd"
						echo -e "\n[$TOOLBOX_USER@$HOST]$ $cmd"
						$cmd | tee -a "$LOG_FILE"
						sleep 1
						echo ""

						read -p "Do you want to add the mount point to your fstab? (y/N): " fstab
						if [[ "$fstab" =~ ^[yY]$ ]]; then
							uuid=$(blkid -s UUID -o value "$device")
							fs_type=$(blkid -s TYPE -o value "$device")
							if [[ -n "$uuid" && -n "$fs_type" ]]; then
								entry="UUID=$uuid $mount_target $fs_type defaults 0 2"
								echo "$entry" | tee -a /etc/fstab
								log "$TOOLBOX_USER added $device mount to fstab"
								systemctl daemon-reload
								mount -a
								echo ""
								echo ""
							else
								echo "Could not retrieve UUID or filesystem type. Skipping fstab entry."
							fi
						fi
					else
						echo "Invalid device or mount point..."
						sleep 2
					fi
				else
					echo "Invalid mount point..."
					sleep 2
				fi

				echo ""
				echo ""
				read -rp "Press enter to return..."
				;;
			"Manage Partitions")
				read -p "Enter device path (e.g., /dev/sda, /dev/nvme0n1): " device
				if [[ -b "$device" ]]; then
					cmd="parted $device"
					log "$TOOLBOX_USER managed partitions using '$cmd'"
					echo ""
					echo ""
					echo "[$TOOLBOX_USER@$HOST]$ $cmd"
					$cmd | tee -a "$LOG_FILE"
					sleep 1
					echo ""
					echo ""read -rp "Press enter to return..."
				else
					echo "Invalid device: $device"
					sleep 2
				fi
				;;
			"Mount SMB or Device")
				read -p "Would you like to mount an SMB share or device? (Y/n): " choice
				choice=${choice:-Y}
					if [[ "$choice" =~ ^([yY]|[Yy][Ee][Ss])$ ]]; then
						read -p "Do you want to create the mount point in the /mnt dir? (Y/n): " ans
					ans=${ans:-Y}

					if [[ "$ans" =~ ^([yY]|[Yy][Ee][Ss])$ ]]; then
						read -p "Name the mount point for /mnt/... (e.g., usb, nas): " name
						if [[ -n "$name" ]]; then
							mkdir -p "/mnt/$name"
							mount_target="/mnt/$name"
						else
							echo "No name provided. Skipping ..."
							sleep 2
						fi
					elif [[ "$ans" =~ ^[nN]$ ]]; then
						while true; do
							read -p "Do you want to use an existing mount point? (Y/n): " ans
							ans=${ans:-Y}

							if [[ "$ans" =~ ^[yY]$ ]]; then
								read -p "To use an existing mount point enter it now. (e.g., /mnt/usb): " ex_mount
								if [[ -n "$ex_mount" && -d "$ex_mount" ]]; then
									mount_target="$ex_mount"
									echo "Mount target set to $mount_target"
									skip_new_mount_prompt=true
									break
								else
									echo "Invalid or no path provided. Please try again..."
									sleep 2
								fi
							else
								echo "Returning to menu..."
								sleep 2
								break
							fi
						done
					fi

					if [[ -z "$mount_target" && "$skip_new_mount_prompt" != "true" ]]; then
						read -p "Do you want to create a new mount point? (y/N): " ans
						if [[ "$ans" =~ ^[yY]$ ]]; then
							read -p "Enter full path for new mount point (e.g., /new/mount/point): " newmount
							if [[ -n "$newmount" ]]; then
								mkdir -p "$newmount"
								mount_target="$newmount"
							else
								echo "No path provided. Skipping..."
								sleep 2
							fi
						else
							echo "No mount point selected. Skipping..."
							sleep 2
						fi
					fi
				elif [[ "$mount_ans" == "unmount" ]]; then
					read -p "Enter full path to unmount (e.g., /mnt/usb): " unmount_point
					if [[ -d "$unmount_point" ]]; then
						cmd="umount \"$unmount_point\""
						log "$TOOLBOX_USER used '$cmd' to unmount $unmount_point"
						echo ""
						echo ""
						echo "[$TOOLBOX_USER@$HOST]$ $cmd"
						$cmd | tee -a "$LOG_FILE"
						sleep 1
						echo ""
						echo ""
					else
						echo "Invalid or non-existent path..."
						sleep 2
					fi
				fi

				read -p "Would you like to mount an SMB network share or device? (smb/device): " mount_type

				if [[ "$mount_type" == "smb" ]]; then
					read -p "Do you have an existing SMB credential file? [y/N]: " ans
					ans=${ans:-N}

					if [[ "$ans" =~ ^[nN]$ ]];then
						echo "Please create your credential file..."
						read -p "Please enter your SMB share UID (default uid=${SUDO_UID:-$(id -u)}): " uid
						uid=${uid:-${SUDO_UID:-$(id -u)}}

						read -p "Please enter your SMB share GID (default gid=${SUDO_GID:-$(id -g)}): " gid
						gid=${SUDO_GID:-$(id -g)}

						read -p "Please enter your SMB share username: " username
						read -p "Please enter your SMB share password: " password
						read -p "Please enter your SMB share domain (optional): " domain
						read -p "Where would you like to put the credentials file? (default /home/$TOOLBOX_USER/.smbcred): " smb_cred_loc
						smb_cred_loc=${smb_cred_loc:-/home/$TOOLBOX_USER/.smbcred}

						if [[ -n "$username" && -n "$password" && -n "$smb_cred_loc" ]]; then
							cat <<EOF | tee "$smb_cred_loc" > /dev/null
username=$username
password=$password
$( [[ -n "$domain" ]] && echo "domain=$domain" )
EOF
								chown $TOOLBOX_USER:$TOOLBOX_USER "$smb_cred_loc"
								chmod 600 "$smb_cred_loc"

								read -p "Enter SMB share path (e.g., //server/share): " smb_share
								if [[ -n "$smb_share" && -d "$mount_target" ]]; then
									cmd="mount -t cifs $smb_share $mount_target -o credentials=$smb_cred_loc,uid=$uid,gid=$gid,rw,vers=3.0"
									log "$TOOLBOX_USER mounted SMB share using $cmd"
									echo ""
									echo "[$TOOLBOX_USER@$HOST]$ $cmd"
									$cmd
									sleep 1
									echo ""
									echo ""

									read -p "Do you want to add this SMB mount to fstab? (y/N): " fstab
									if [[ "$fstab" =~ ^[yY]$ ]]; then
										entry="$smb_share $mount_target cifs credentials=$smb_cred_loc,uid=$uid,gid=$gid,x-systemd.automount 0 0"
										echo "$entry" | tee -a /etc/fstab
										log "$TOOLBOX_USER added SMB mount to fstab"
										systemctl daemon-reload
										mount -a
										echo ""
										echo ""
									fi
								else
									echo "Invalid SMB share or mount point..."
									sleep 2
								fi
							else
								echo "Missing credentials info. Skipping..."
								sleep 2
							fi
						elif [[ "$ans" =~ ^[yY]$ ]]; then
							read -p "Please enter the correct existing SMB credential file now: " ex_creds
							if [[ -n "$ex_creds" && -f "$ex_creds" ]]; then
								read -p "Please enter your SMB share UID (default uid=${SUDO_UID:-$(id -u)}): " uid
								uid=${uid:-${SUDO_UID:-$(id -u)}}
								read -p "Please enter your SMB share GID (default gid=${SUDO_GID:-$(id -g)}): " gid
								gid=${gid:-${SUDO_GID:-$_id -g)}}
								read -p "Enter SMB share path (e.g., //server/share): " smb_share
								if [[ -n "$smb_share" && -d "$mount_target" ]]; then
									cmd="mount -t cifs $smb_share $mount_target -o credentials=$ex_creds,uid=$uid,gid=$gid,rw,vers=3.0"
									log "$TOOLBOX_USER mounted SMB share using $cmd"
									echo ""
									echo "[$TOOLBOX_USER@$HOST]$ $cmd"
									$cmd
									sleep 1
									echo ""
									echo ""
									
									read -p "Do you want to add this SMB mount to /etc/fstab? (y/N): " fstab
									if [[ "$fstab" =~ ^[yY]$ ]]; then
										entry="$smb_share $mount_target cifs credentials=$ex_creds,uid=$uid,gid=$gid,x-systemd.automount 0 0"
										echo "$entry" | tee -a /etc/fstab
										log "$TOOLBOX_USER added SMB mount to fstab"
										systemctl daemon-reload
										mount -a
										echo ""
										echo ""
									fi
								else
									echo "Invalid SMB share or mount point..."
									sleep 2
									echo ""
									echo ""
									read -rp "Press enter to return..."
								fi
							else
								echo "Invalid SMB share, mount point, or credential file path..."
								sleep 2
								echo ""
								echo ""
								read -rp "Press enter to return..."
							fi
					fi
				elif [[ "$mount_type" == "device" ]]; then
					read -p "Enter device path (e.g., /dev/sda1, /dev/nvme0n1): " device
					if [[ -b "$device" && -d "$mount_target" ]]; then
						cmd="mount $device $mount_target"
						log "$TOOLBOX_USER mounted drive using $cmd"
						echo -e "\n[$TOOLBOX_USER@$HOST]$ $cmd"
						$cmd | tee -a "$LOG_FILE"
						sleep 1
						echo ""

						read -p "Do you want to add the mount point to your fstab? (y/N): " fstab
						if [[ "$fstab" =~ ^[yY]$ ]]; then
							uuid=$(blkid -s UUID -o value "$device")
							fs_type=$(blkid -s TYPE -o value "$device")
							if [[ -n "$uuid" && -n "$fs_type" ]]; then
								entry="UUID=$uuid $mount_target $fs_type defaults 0 2"
								echo "$entry" | tee -a /etc/fstab
								log "$TOOLBOX_USER added $device mount to fstab"
								systemctl daemon-reload
								mount -a
								echo ""
								echo ""
							else
								echo "Could not retrieve UUID or filesystem type. Skipping fstab entry."
							fi
						fi
					else
						echo "Invalid device or mount point..."
						sleep 2
					fi
				else
					echo "Invalid mount point..."
					sleep 2
				fi

				echo ""
				echo ""
				read -rp "Press enter to return..."
				;;
			"Unmount SMB or Device")
				read -p "Do you want to unmount an SMB share or device? (Y/n): " ans
				ans=${ans:-Y}
				
				if [[ "$ans" =~ ^([yY]|[Yy][Ee][Ss])?$ ]]; then
					read -p "Enter full path to unmount (e.g., /mnt/usb): " unmount_point
					if [[ -d "$unmount_point" ]];then
						cmd="umount $unmount_point"
						log "$TOOLBOX_USER used '$cmd' to unmount $unmount_point"
						echo ""
						echo ""
						echo "[$TOOLBOX_USER@$HOST]$ $cmd"
						$cmd | tee -a "$LOG_FILE" || true
						sleep 1
						echo ""
						echo ""
					else
						echo "Invalid or non-existent path..."
						sleep 2
						echo ""
						echo ""
					fi
				fi
				echo ""
				echo ""
				read -rp "Press enter to return..."
				;;
			"Run cfdisk")
				read -p "Enter device path (e.g., /dev/sda, /dev/nvme0n1): " device

				if [[ -b "$device" ]]; then
					cmd="cfdisk $device"
					log "$TOOLBOX_USER managed partitions using '$cmd'"
					echo ""
					echo ""
					echo "[$TOOLBOX_USER@$HOST]$ $cmd"
					$cmd | tee -a "$LOG_FILE"
					sleep 1
					echo ""
					echo ""
					read -rp "Press enter to return..."
				else
					echo "Invalid device: $device"
					sleep 2
				fi
				;;
			"Show Drive UUID")
				read -p "Entire device path (e.g., /dev/sda, /dev/nvme0n1): " device
				if [[ -b "$device" ]]; then 
					cmd="blkid $device"
					log "$TOOLBOX_USER viewed drive UUID using '$cmd'"
					echo ""
					echo ""
					echo "[$TOOLBOX_USER@$HOST]$ $cmd"
					$cmd | tee -a "$LOG_FILE"
					sleep 1
					echo ""
					echo ""
					read -rp "Press enter to return..."
				else
					echo "Invalid device: $device"
					sleep 2
				fi
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

# File Management Submenu
file_mgmt() {
	while true; do
		choice=$(echo -e "Back\nView File\nRemove File\nMove File\nList Files\nCopy File\nChange Permissions\nChange Ownership" | fzf)
		
		if [[ -z "$choice" ]]; then
			echo "No selection made. Returning to main menu..."
			sleep 2
			break
		fi

		case "$choice" in
			"Change Ownership")
				read -p "Enter file or directory path: " path
				read -p "Enter owner (user:group): " owner
				if [[ -e "$path" && -n "$owner" ]]; then
					cmd="chown $owner $path"
					log "$TOOLBOX_USER changed ownership using '$cmd'"
					echo ""
					echo ""
					echo "[$TOOLBOX_USER@$HOST]$ $cmd"
					$cmd | tee -a "$LOG_FILE"
					sleep 1
					echo ""
					echo ""
					read -rp "Press enter to return..."
				else
					echo "Invalid path or owner."
					sleep 2
				fi
				;;
			"Change Permissions")
				read -p "Enter file or directory path: " path
				read -p "Enter permissions (e.g., 755): " perms
				if [[ -e "$path" && "$perms" =~ ^[0-7]{3}$ ]]; then
					cmd="chmod $perms $path"
					log "$TOOLBOX_USER changed permissions using '$cmd'"
					echo ""
					echo ""
					echo "[$TOOLBOX_USER@$HOST]$ $cmd"
					$cmd | tee -a "$LOG_FILE"
					sleep 1
					echo ""
					echo ""
					read -rp "Press enter to return..."
				else
					echo "Invalid path or permissions format."
					sleep 2
				fi
				;;
			"Copy File")
				read -p "Enter source file path: " src
				read -p "Enter destination path: " dest
				if [[ -f "$src" && -d "$(dirname "$dest")" ]]; then
					cmd="cp $src $dest"
					log "$TOOLBOX_USER copied file using '$cmd'"
					echo ""
					echo ""
					echo "[$TOOLBOX_USER@$HOST]$ $cmd"
					$cmd | tee -a "$LOG_FILE"
					sleep 1
					echo ""
					echo ""
					read -rp "Press enter to return..."
				else
					echo "Invalid source file or destination directory."
					sleep 2
				fi
				;;
			"List Files")
				read -p "Enter directory path to list (or press Enter for current directory): " path
				path=${path:-.}  # Default to current directory if empty
				if [[ -d "$path" ]]; then
					cmd="ls -la $path"
					log "$TOOLBOX_USER listed files using '$cmd'"
					echo ""
					echo ""
					echo "[$TOOLBOX_USER@$HOST]$ $cmd"
					$cmd | tee -a "$LOG_FILE"
					sleep 1
					echo ""
					echo ""
					read -rp "Press enter to return..."
				else
					echo "Invalid directory: $path"
					sleep 2
				fi
				;;
			"Move File")
				read -p "Enter source file path: " src
				read -p "Enter destination path: " dest
				if [[ -f "$src" && -d "$(dirname "$dest")" ]]; then
					cmd="mv $src $dest"
					log "$TOOLBOX_USER moved file using '$cmd'"
					echo ""
					echo ""
					echo "[$TOOLBOX_USER@$HOST]$ $cmd"
					$cmd | tee -a "$LOG_FILE"
					sleep 1
					echo ""
					echo ""
					read -rp "Press enter to return..."
				else
					echo "Invalid source file or destination directory."
					sleep 2
				fi
				;;
			"Remove File")
				read -p "Enter file path to remove: " file
				if [[ -f "$file" ]]; then
					cmd="rm $file"
					log "$TOOLBOX_USER removed file using '$cmd'"
					echo ""
					echo ""
					echo "[$TOOLBOX_USER@$HOST]$ $cmd"
					$cmd | tee -a "$LOG_FILE"
					sleep 1
					echo ""
					echo ""
					read -rp "Press enter to return..."
				else
					echo "Invalid file: $file"
					sleep 2
				fi
				;;
			"View File")
				read -p "Enter file path to view: " file
				if [[ -f "$file" ]]; then
					log "$TOOLBOX_USER viewed $file contents"
					echo ""
					echo ""
					echo "[$TOOLBOX_USER@$HOST]$ less $file"
					less "$file"
					sleep 1
					echo ""
					echo ""
					read -rp "Press enter to return..."
				else
					echo "Invalid file: $file"
					sleep 2
				fi
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

# File System Checks Submenu
file_sys_chks() {
	while true; do
		choice=$(echo -e "Back\nRun fsck\nFind Files" | fzf)
        
		if [[ -z "$choice" ]]; then
			echo "No selection made. Returning to main menu..."
			sleep 2
			break
		fi

		case "$choice" in
			"Find Files")
				read -p "Enter search path (or press Enter for current directory): " path
				path=${path:-.}  # Default to current directory
				read -p "Enter file name or pattern to search: " pattern
				if [[ -d "$path" ]]; then
					cmd="find $path -name $pattern"
					log "$TOOLBOX_USER searched files using '$cmd'"
					echo ""
					echo ""
					echo "[$TOOLBOX_USER@$HOST]$ $cmd"
					$cmd | tee -a "$LOG_FILE"
					sleep 1
					echo ""
					echo ""
					read -rp "Press enter to return..."
				else
					echo "Invalid directory: $path"
					sleep 2
				fi
				;;
			"Run fsck")
				read -p "Enter device path (e.g., /dev/sda1 /dev/nvme0n1p1): " device
				if [[ -b "$device" ]]; then
					cmd="fsck $device"
					log "$TOOLBOX_USER checked filesystem using '$cmd'"
					echo ""
					echo ""
					echo "[$TOOLBOX_USER@$HOST]$ $cmd"
					$cmd | tee -a "$LOG_FILE"
					sleep 1
					echo ""
					echo ""
					read -rp "Press enter to return..."
				else
					echo "Invalid device: $device"
					sleep 2
				fi
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

# Log Viewing Submenu
log_viewing() {
	while true; do
		choice=$(echo -e "Back\nView System Logs\nView Log File\nView File Content\nTail Log File\nSearch Logs" | fzf)
        
		if [[ -z "$choice" ]]; then
			echo "No selection made. Returning to main menu..."
			sleep 2
			break
		fi

		case "$choice" in
			"Search Logs")
				echo "Enter the full path of the log file you want to search..."
				echo " e.g., /var/log/syslog, /var/log/auth.log"
				read -rp "Log file path: " file

				echo "Enter the search pattern (a keywork, phrase, or regex)."
				echo " e.g., error, failed login, systemd, ^Aug"
				read -rp "Search pattern: " pattern

				read -rp "Use case-insensitive search? [y/N]: " ignore_case

				if [[ -f "$file" ]]; then
					echo ""
					echo ""
					echo "[$TOOLBOX_USER@$HOST]$ grep ${ignore_case,,} \"$pattern\" \"$file\""
					log "$TOOLBOX_USER searched logs using: grep \"$pattern\" \"$file\" (ignore_case=${ignore_case,,})"

					if [[ "$ignore_case" =~ ^[yY]$ ]]; then
						grep -i "$pattern" "$file" | tee -a "$LOG_FILE"
					else
						grep "$pattern" "$file" | tee -a "$LOG_FILE"
					fi

					echo ""
					echo ""
					read -rp "Press enter to return..."
				else
					echo "Invalid file: $file"
					sleep 2
				fi
				;;
			"Tail Log File")
				echo "Enter the full path of the log file you want to search..."
				echo " e.g., /var/log/syslog, /var/log/auth.log"
				read -rp "Log file path: " file
				
				read -p "Enter number of lines to tail (default 10): " lines
				lines=${lines:-10}
				if [[ -f "$file" && "$lines" =~ ^[0-9]+$ ]]; then
					cmd="tail -n $lines $file"
					log "$TOOLBOX_USER tailed log file using '$cmd'"
					echo ""
					echo ""
					echo "[$TOOLBOX_USER@$HOST]$ $cmd"
					$cmd | tee -a "$LOG_FILE"
					sleep 1
					echo ""
					echo ""
					read -rp "Press enter to return..."
				else
					echo "Invalid file or number of lines."
					sleep 2
				fi
				;;
			"View File Content")
				read -p "Enter file path to view: " file
				if [[ -f "$file" ]]; then
					log "$TOOLBOX_USER viewed the contents of $file"
					echo ""
					echo ""
					echo "[$TOOLBOX_USER@$HOST]$ less $file"
					less "$file"
					sleep 1
					echo ""
					echo ""
					read -rp "Press enter to return..."
				else
					echo "Invalid file: $file"
					sleep 2
				fi
				;;
			"View Log File")
				read -p "Enter log file path: " file
				if [[ -f "$file" ]]; then
					log "$TOOLBOX_USER viewed log file using '$cmd'"
					echo ""
					echo ""
					echo "[$TOOLBOX_USER@$HOST]$ $cmd"
					less $file
					sleep 1
					echo ""
					echo ""
					read -rp "Press enter to return..."
				else
					echo "Invalid file: $file"
					sleep 2
				fi
				;;
			"View System Logs")
				line=$(journalctl -xe --output=short-iso --reverse | fzf)
				if [[ -n "$line" ]]; then
					echo "$line" | awk '{print $1, $2, substr($0, index($0,$3))}'
				else
					echo "No log line selected."
				fi
				log "$TOOLBOX_USER viewed system logs"
				echo ""
				echo ""
				sleep 1
				echo ""
				echo ""
				read -rp "Press enter to return..."
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

# Network Configuration Submenu
net_config() {
	while true; do
		choice=$(echo -e "Back\nSocket Statistics\nNetwork Statistics" | fzf)
        
		if [[ -z "$choice" ]]; then
			echo "No selection made. Returning to main menu..."
			sleep 2
			break
		fi

		case "$choice" in
			"Network Statistics")
				stat_type=$(echo -e "Back\nRouting Table\nListening TCP/UDP\nInterface Stats\nAll Connections" | fzf)
				
				if [[ -z "$stat_type" ]]; then
					echo "No choice selected. Returning..."
					sleep 2
					continue
				fi

				case "$stat_type" in
					"Listening TCP/UDP")
						cmd="netstat -tulnp"
						log "$TOOLBOX_USER viewed listening server sockets using '$cmd'"
						echo ""
						echo ""
						echo "[$TOOLBOX_USER@$HOST]$ $cmd"
						$cmd | tee -a "$LOG_FILE"
						sleep 1
						echo ""
						echo ""
						read -rp "Press enter to return..."
						;;
					"Routing Table")
						cmd="netstat -r"
						log "$TOOLBOX_USER displayed the routing table using '$cmd'"
						echo ""
						echo ""
						echo "[$TOOLBOX_USER@$HOST]$ $cmd"
						$cmd | tee -a "$LOG_FILE"
						sleep 1
						echo ""
						echo ""
						read -rp "Press enter to return..."
						;;
					"All Connections")
						cmd="netstat -anp"
						log "$TOOLBOX_USER displayed all connections using '$cmd'"
						echo ""
						echo ""
						echo "[$TOOLBOX_USER@$HOST]$ $cmd"
						$cmd | tee -a "$LOG_FILE"
						sleep 1 
						echo ""
						echo ""
						read -rp "Press enter to return..."
						;;
					"Interface Stats")
						cmd="netstat -i"
						log "$TOOLBOX_USER displayed the interface table using '$cmd'"
						echo ""
						echo ""
						echo "[$TOOLBOX_USER@$HOST]$ $cmd"
						$cmd | tee -a "$LOG_FILE"
						sleep 1 
						echo ""
						echo ""
						read -rp "Press enter to return..."
						;;
					"Back")
						echo ""
						echo ""
						break
						;;
				esac
				;;
			"Socket Statistics")
				stat_type=$(echo -e "Back\nSocket Summary\nIPv6 TCP/UDP\nIPv4 TCP/UDP\nListening TCP/UDP\nAll Sockets" | fzf)
				
				if [[ -z "$stat_type" ]]; then
					echo "No choice selected. Returning..."
					sleep 2
					continue
				fi
				
				case "$stat_type" in
					"Listening TCP/UDP")
						cmd="ss -tulnp"
						log "$TOOLBOX_USER viewed listening server sockets using '$cmd'"
						echo ""
						echo ""
						echo "[$TOOLBOX_USER@$HOST]$ $cmd"
						$cmd | tee -a "$LOG_FILE"
						sleep 1
						echo ""
						echo ""
						read -rp "Press enter to return..."
						;;
					"Socket Summary")
						cmd="ss -s"
						log "$TOOLBOX_USER displayed the socket summary using '$cmd'"
						echo ""
						echo ""
						echo "[$TOOLBOX_USER@$HOST]$ $cmd"
						$cmd | tee -a "$LOG_FILE"
						sleep 1
						echo ""
						echo ""
						read -rp "Press enter to return..."
						;;
					"All Sockets")
						cmd="ss -anp"
						log "$TOOLBOX_USER displayed all sockets using '$cmd'"
						echo ""
						echo ""
						echo "[$TOOLBOX_USER@$HOST]$ $cmd"
						$cmd | tee -a "$LOG_FILE"
						sleep 1 
						echo ""
						echo ""
						read -rp "Press enter to return..."
						;;
					"IPv4 TCP/UDP")
						cmd="ss -tunp4"
						log "$TOOLBOX_USER displayed the IPv4 sockets using '$cmd'"
						echo ""
						echo ""
						echo "[$TOOLBOX_USER@$HOST]$ $cmd"
						$cmd | tee -a "$LOG_FILE"
						sleep 1 
						echo ""
						echo ""
						read -rp "Press enter to return..."
						;;
					"IPv6 TCP/UDP")
						cmd="ss -tunp6"
						log "$TOOLBOX_USER displayed the IPv6 sockets using '$cmd'"
						echo ""
						echo ""
						echo "[$TOOLBOX_USER@$HOST]$ $cmd"
						$cmd | tee -a "$LOG_FILE"
						sleep 1 
						echo ""
						echo ""
						read -rp "Press enter to return..."
						;;
					"Back")
						echo ""
						echo ""
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
				read -p "Enter domain or IP for lookup: " domain
				if [[ -n "$domain" ]]; then
					cmd="nslookup $domain"
					log "$TOOLBOX_USER performed DNS lookup using '$cmd'"
					echo ""
					echo ""
					echo "[$TOOLBOX_USER@$HOST]$ $cmd"
					$cmd | tee -a "$LOG_FILE"
					sleep 1
					echo ""
					echo ""
					read -rp "Press enter to return..."
				else
					echo "No domain or IP specified."
					sleep 2
				fi
				;;
			"Network Management UI")
				cmd="nmtui"
				log "$TOOLBOX_USER launched network management UI using '$cmd'"
				echo ""
				echo ""
				echo "[$TOOLBOX_USER@$HOST]$ $cmd"
				$cmd | tee -a "$LOG_FILE"
				sleep 1
				echo ""
				echo ""
				;;
			"Ping Host")
				read -p "Enter host to ping (e.g., 8.8.8.8): " host
				if [[ -n "$host" ]]; then
					cmd="ping -c 5 -O $host"
					log "$TOOLBOX_USER pinged $host using '$cmd'"
					echo ""
					echo ""
					echo "[$TOOLBOX_USER@$HOST]$ $cmd"
					$cmd | tee -a "$LOG_FILE"
					sleep 1
					echo ""
					echo ""
					read -rp "Press enter to return..."
				else
					echo "No host specified."
					sleep 2
				fi
				;;
			"Show Interface Configuration")
				cmd="ifconfig"
				log "$TOOLBOX_USER viewed interface configuration using '$cmd'"
				echo ""
				echo ""
				echo "[$TOOLBOX_USER@$HOST]$ $cmd"
				$cmd | tee -a "$LOG_FILE"
				sleep 1
				echo ""
				echo ""
				read -rp "Press enter to return..."
				;;
			"Show IP Configuration")
				cmd="ip addr"
				log "$TOOLBOX_USER viewed IP configuration using '$cmd'"
				echo ""
				echo ""
				echo "[$TOOLBOX_USER@$HOST]$ $cmd"
				$cmd | tee -a "$LOG_FILE"
				sleep 1
				echo ""
				echo ""
				read -rp "Press enter to return..."
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

# Security Management Submenu
sec_mgmt() {
	while true; do
		choice=$(echo -e "Back\nSystem Update\nShow Last Logins\nShow Active Users\nRootkit Check\nShow Firewall Status\nDeny Traffic\nAllow Traffic\nAntivirus Scan" | fzf)
       
		if [[ -z "$choice" ]]; then
			echo "No selection made. Returning to main menu..."
			sleep 2
			break
		fi

		case "$choice" in
			"Allow Traffic")
				echo "Select traffic type to allow:"
				traffic_type=$(echo -e "Back\nAllow Specific Port\nAllow Specific IP Address\nAllow Specific IP Address & Port\nAllow All Outgoing\nAllow All Incoming" | fzf)
				if [[ -z "$traffic_type" ]]; then
					echo "No traffic type selected."
					sleep 2
					continue
				fi

				case "$traffic_type" in
					"Allow All Incoming")
						echo "Allowing all incoming traffic (requires sudo)..."
						read -p "Are you sure? (y/N): " confirm
						if [[ "$confirm" =~ ^[yY]$ ]]; then
							cmd="ufw default allow incoming"
							log "$TOOLBOX_USER allowed all incoming traffic using '$cmd'"
							echo ""
							echo ""
							echo "[$TOOLBOX_USER@$HOST]$ $cmd"
							$cmd | tee -a "$LOG_FILE"
							sleep 1
							echo ""
							echo ""
							read -rp "Press enter to return..."
						else
							echo "Action cancelled."
							sleep 2
						fi
						;;
					"Allow All Outgoing")
						echo "Allowing all outgoing traffic (requires sudo)..."
						read -p "Are you sure? (y/N): " confirm
						if [[ "$confirm" =~ ^[yY]$ ]]; then
							cmd="ufw default allow outgoing"
							log "$TOOLBOX_USER allowed all outgoing traffic using '$cmd'"
							echo ""
							echo ""
							echo "[$TOOLBOX_USER@$HOST]$ $cmd"
							$cmd | tee -a "$LOG_FILE"
							sleep 1
							echo ""
							echo ""
							read -rp "Press enter to return..."
						else
							echo "Action cancelled."
							sleep 2
						fi
						;;
					"Allow Specific IP Address")
						read -p "Enter IP address: " ip
						if [[ "$ip" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}(/[0-9]{1,2})?$ ]]; then
							cmd="ufw allow from $ip"
							log "$TOOLBOX_USER allowed traffic from IP using '$cmd'"
							echo ""
							echo ""
							echo "[$TOOLBOX_USER@$HOST]$ $cmd"
							$cmd | tee -a "$LOG_FILE"
							sleep 1
							echo ""
							echo ""
							read -rp "Press enter to return..."
						else
							echo "Invalid IP address format."
							sleep 2
						fi
						;;
					"Allow Specific IP Address & Port")
						read -p "Enter IP address or CIDR block (e.g., 192.168.1.2 or 192.168.1.2/0): " ip
						read -p "Enter port number (e.g., 22): " port
						read -p "Enter protocol (tcp/udp): " proto
						
						if [[ "$ip" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}(/[0-9]{1,2})?$ ]] && [[ "$port" =~ ^[0-9]+$ ]] && [[ "$proto" =~ ^(tcp|udp)$ ]]; then
							cmd="ufw allow from $ip to any port $port proto $proto"
							log "$TOOLBOX_USER allowed traffic from '$ip' to port '$port/$proto' using '$cmd'"
							echo ""
							echo ""
							echo -e "\n[$TOOLBOX_USER@$HOST]$ $cmd\n"
							$cmd | tee -a "$LOG_FILE"
							sleep 1
							echo ""
							echo ""
							read -rp "Press enter to return..."
						else
							echo "Invalid input. Please check the IP/CIDR, port, and protocol format."
							sleep 2
						fi
						;;
					"Allow Specific Port")
						read -p "Enter port and protocol (e.g., 22/tcp): " port
						if [[ "$port" =~ ^[0-9]+/(tcp|udp)$ ]]; then
							cmd="ufw allow $port"
							log "$TOOLBOX_USER allowed traffic on port using '$cmd'"
							echo ""
							echo ""
							echo "[$TOOLBOX_USER@$HOST]$ $cmd"
							$cmd | tee -a "$LOG_FILE"
							sleep 1
							echo ""
							echo ""
							read -rp "Press enter to return..."
						else
							echo "Invalid port/protocol format."
							sleep 2
						fi
						;;
					"Back")
						continue
						;;
				esac
				;;
			"Deny Traffic")
				echo "Select traffic type to deny:"
				traffic_type=$(echo -e "Back\nDeny Specific IP Address & Port\nDeny Specific Port\nDeny Specific IP Address\nDeny All Outgoing\nDeny All Incoming" | fzf)
				if [[ -z "$traffic_type" ]]; then
					echo "No traffic type selected."
					sleep 2
					continue
				fi
				case "$traffic_type" in
					"Deny All Incoming")
						echo "Denying all incoming traffic (requires sudo)..."
						read -p "Are you sure? (y/N): " confirm
						if [[ "$confirm" =~ ^[yY]$ ]]; then
							cmd="ufw default deny incoming"
							log "$TOOLBOX_USER denied all incoming traffic using '$cmd'"
							echo ""
							echo ""
							echo "[$TOOLBOX_USER@$HOST]$ $cmd"
							$cmd | tee -a "$LOG_FILE"
							sleep 1
							echo ""
							echo ""
							read -rp "Press enter to return..."
						else
							echo "Action cancelled."
							sleep 2
						fi
						;;
					"Deny All Outgoing")
						echo "Denying all outgoing traffic (requires sudo)..."
						read -p "Are you sure? (y/N): " confirm
						if [[ "$confirm" =~ ^[yY]$ ]]; then
							cmd="ufw default deny outgoing"
							log "$TOOLBOX_USER denied all outgoing traffic using '$cmd'"
							echo ""
							echo ""
							echo "[$TOOLBOX_USER@$HOST]$ $cmd"
							$cmd | tee -a "$LOG_FILE"
							sleep 1
							echo ""
							echo ""
							read -rp "Press enter to return..."
						else
							echo "Action cancelled."
							sleep 2
						fi
						;;
					"Deny Specific IP Address")
						read -p "Enter IP address: " ip
						if [[ "$ip" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}(/[0-9]{1,2})?$ ]]; then
							cmd="ufw deny from $ip"
							log "$TOOLBOX_USER denied traffic from IP using '$cmd'"
							echo ""
							echo ""
							echo "[$TOOLBOX_USER@$HOST]$ $cmd"
							$cmd | tee -a "$LOG_FILE"
							sleep 1
							echo ""
							echo ""
							read -rp "Press enter to return..."
						else
							echo "Invalid IP address format."
							sleep 2
						fi
						;;
					"Deny Specific IP Address & Port")
						read -p "Enter IP address or CIDR block (e.g., 192.168.1.2 or 10.0.0.0/8): " ip
						read -p "Enter port number (e.g., 22): " port
						read -p "Enter protocol (tcp/udp): " proto
						
						if [[ "$ip" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}(/[0-9]{1,2})?$ ]] && [[ "$port" =~ ^[0-9]+$ ]] && [[ "$proto" =~ ^(tcp|udp)$ ]]; then
							cmd="ufw deny from $ip to any port $port proto $proto"
							log "$TOOLBOX_USER denied traffic from '$ip' to port '$port/$proto' using '$cmd'"
							echo ""
							echo ""
							echo -e "\n[$TOOLBOX_USER@$HOST]$ $cmd\n"
							$cmd | tee -a "$LOG_FILE"
							sleep 1
							echo ""
							echo ""
							read -rp "Press enter to return..."
						else
							echo "Invalid input. Please check the IP/CIDR, port, and protocol format."
							sleep 2
						fi
						;;
					"Deny Specific Port")
						read -p "Enter port and protocol (e.g., 22/tcp): " port
						if [[ "$port" =~ ^[0-9]+/(tcp|udp)$ ]]; then
							cmd="ufw deny $port"
							log "$TOOLBOX_USER denied traffic on port using '$cmd'"
							echo ""
							echo ""
							echo "[$TOOLBOX_USER@$HOST]$ $cmd"
							$cmd | tee -a "$LOG_FILE"
							sleep 1
							echo ""
							echo ""
							read -rp "Press enter to return..."
						else
							echo "Invalid port/protocol format."
							sleep 2
						fi
						;;
					"Back")
						continue
						;;
				esac
				;;
			"Show Active Users")
				cmd="who"
				log "$TOOLBOX_USER viewed active users using '$cmd'"
				echo "[$TOOLBOX_USER@$HOST]$ $cmd"
				echo ""
				echo ""
				$cmd | tee -a "$LOG_FILE"
				sleep 1
				echo ""
				echo ""
				read -rp "Press enter to return..."
				;;
			"Show Firewall Status")
				cmd1="ufw status"
				cmd2="ufw enable"
				cmd3="ufw disable"
				log "$TOOLBOX_USER viewed firewall status using '$cmd1'"
				echo ""
				echo ""
				echo "[$TOOLBOX_USER@$HOST]$ $cmd1"
				$cmd1 | tee -a "$LOG_FILE"
				sleep 1
				read -p "Would you like to turn the firewall ON or OFF? (e.g., ON, OFF, n/N) " ans
				if [[ "$ans" == "ON" ]]; then
					echo "[$TOOLBOX_USER@$HOST]$ $cmd2"
					$cmd2 | tee -a "$LOG_FILE"
					log "$TOOLBOX_USER enabled the firewall using '$cmd2'"
				elif [[ "$ans" == "OFF" ]]; then
					echo "[$TOOLBOX_USER@$HOST]$ $cmd3"
					$cmd3 | tee -a "$LOG_FILE"
					log "$TOOLBOX_USER disabled the firewall using '$cmd3'"
				else
					echo "No changes made."
				fi
				echo ""
				echo ""
				read -rp "Press enter to return..."
				;;
			"Show Last Logins")
				cmd="last"
				log "$TOOLBOX_USER viewed last logins using '$cmd'"
				echo ""
				echo ""
				echo "[$TOOLBOX_USER@$HOST]$ $cmd"
				$cmd | tee -a "$LOG_FILE"
				sleep 1
				echo ""
				echo ""
				read -rp "Press enter to return..."
				;;
			"Antivirus Scan")
				scan_type=$(echo -e "Back\nScan Specific Directory\nFull System Scan" | fzf)
				
				case "$scan_type" in
					"Full System Scan")
						if check_clamav; then
							log "$TOOLBOX_USER started a full system clamscan"
							echo ""
							echo ""
							echo "[$TOOLBOX_USER@$HOST]$ sudo freshclam"
							freshclam
							echo ""
							echo ""
							echo "[$TOOLBOX_USER@$HOST]$ sudo nohup clamscan -r --bell -i / > /var/The-Abyss/.logs/clamscan.log"
							nohup clamscan -r --bell -i / > /var/log/The-Abyss/.logs/clamscan.log 2>&1 &
							echo ""
							echo ""
							echo "Full system clamscan initiated..."
							echo "You can check the progress using: sudo cat /var/log/The-Abyss/.logs/clamscan.log"
							sleep 2
							echo ""
							echo ""
							read -rp "Press enter to return..."
						fi
						;;
					"Scan Specific Directory")
						read -p "Enter path to be scanned (e.g., /home/$TOOLBOX_USER): " path
						if [[ -d "$path" ]]; then
							echo "Invalid path: $path"
							sleep 2
						elif check_clamav; then
							log "$TOOLBOX_USER initiated a clamscan on $path"
							echo ""
							echo ""
							echo "[$TOOLBOX_USER@$HOST]$ sudo freshclam"
							freshclam 
							echo ""
							echo ""
							echo "[$TOOLBOX_USER@$HOST]$ sudo nohup clamscan -r --bell -i $path > /var/log/The-Abyss/.logs/clamscan.log 2>&1 &"
							nohup clamscan -r --bell -i "$path" > /var/log/The-Abyss/.logs/clamscan.log 2>&1 &
							echo ""								
							echo ""
							echo "Clamscan initiated for $path..."
							echo "You can check the progress using: sudo cat /var/log/The-Abyss/.logs/clamscan.log"
							sleep 2
							echo ""
							echo ""
							read -rp "Press enter to return..."
						fi
						;;
						"Back")
						continue
						;;
				esac
				;;
			"Rootkit Check")
				log "$TOOLBOX_USER started a rootkit check (with output filtered to hide obsolete warnings)"
				echo ""
				echo ""
				echo "[$TOOLBOX_USER@$HOST]$ sudo rkhunter --update"
				sleep 1
				nohup rkhunter --update &
				sleep 2
				echo "[$TOOLBOX_USER@$HOST]$ sudo rkhunter --check --sk"
				sleep 1
				nohup rkhunter --check --sk &
				sleep 2
				echo ""
				echo ""
				echo "Rootkit check initiated..."
				echo ""
				sleep 1
				echo ""
				echo "Please check the log file (/var/log/rkhunter.log)"
				sleep 1
				echo ""
				echo ""
				read -rp "Press enter to return..."
				;;
			"System Update")
				update_choice=$(echo -e "Back\nUpdate by Package\nFull System Update" | fzf)

				case "$update_choice" in
					"Full System Update")
						if ! command -v "$PKG_MGR" &> /dev/null; then
							echo "Error: Package manager $PKG_MGR not found on this system."
							exit 1
						fi
						
						if [[ $PKG_MGR == "apk" ]]; then
							apk update && apk upgrade --no-interactive || { echo "apk update failed"; exit 1; }
							read -p "Reboot system? [y/N]: " ans
							if [[ "$ans" =~ ^[yY]$ ]]; then
								echo "System reboot initiated..."
								sleep 2
								reboot
							else
								read -rp "Press enter to return..."
							fi
						elif [[ $PKG_MGR == "apt" ]]; then
							apt update && apt full-upgrade -y || { echo "apt update failed"; exit 1; }
							read -p "Reboot system? [y/N]: " ans
							if [[ "$ans" =~ ^[yY]$ ]]; then
								echo "System reboot initiated..."
								sleep 2
								reboot
							else
								read -rp "Press enter to return..."
							fi
						elif [[ $PKG_MGR == "conda" ]]; then
							conda update -n base conda -y && conda update --all -y || { echo "conda update failed"; exit 1; }
							read -p "Reboot system? [y/N]: " ans
							if [[ "$ans" =~ ^[yY]$ ]]; then
								echo "System reboot initiated..."
								sleep 2
								reboot
							else
								read -rp "Press enter to return..."
							fi
						elif [[ $PKG_MGR == "dnf" ]]; then
							dnf upgrade --refresh -y || { echo "dnf update failed"; exit 1; }
							read -p "Reboot system? [y/N]: " ans
							if [[ "$ans" =~ ^[yY]$ ]]; then
								echo "System reboot initiated..."
								sleep 2
								reboot
							else
								read -rp "Press enter to return..."
							fi
						elif [[ $PKG_MGR == "emerge" ]]; then
							emerge --sync && emerge -uD --ask=n @world || { echo "emerge update failed"; exit 1; }
							read -p "Reboot system? [y/N]: " ans
							if [[ "$ans" =~ ^[yY]$ ]]; then
								echo "System reboot initiated..."
								sleep 2
								reboot
							else
								read -rp "Press enter to return..."
							fi
						elif [[ $PKG_MGR == "nix-env" ]]; then
							nix-channel --update && nix-env -u '*' --always || { echo "nix-env update failed"; exit 1; }
							read -p "Reboot system? [y/N]: " ans
							if [[ "$ans" =~ ^[yY]$ ]]; then
								echo "System reboot initiated..."
								sleep 2
								reboot
							else
								read -rp "Press enter to return..."
							fi
						elif [[ $PKG_MGR == "pacman" ]]; then
							pacman -Syu --noconfirm || { echo "pacman update failed"; exit 1; }
							read -p "Reboot system? [y/N]: " ans
							if [[ "$ans" =~ ^[yY]$ ]]; then
								echo "System reboot initiated..."
								sleep 2
								reboot
							else
								read -rp "Press enter to return..."
							fi
						elif [[ $PKG_MGR == "pkg" ]]; then
							pkg update && pkg upgrade -y || { echo "pkg update failed"; exit 1; }
							read -p "Reboot system? [y/N]: " ans
							if [[ "$ans" =~ ^[yY]$ ]]; then
								echo "System reboot initiated..."
								sleep 2
								reboot
							else
								read -rp "Press enter to return..."
							fi
						elif [[ $PKG_MGR == "pkgin" ]]; then
							pkgin -y update && pkgin -y full-upgrade || { echo "pkgin update failed"; exit 1; }
							read -p "Reboot system? [y/N]: " ans
							if [[ "$ans" =~ ^[yY]$ ]]; then
								echo "System reboot initiated..."
								sleep 2
								reboot
							else
								read -rp "Press enter to return..."
							fi
						elif [[ $PKG_MGR == "pkg_add" ]]; then
							#[ -z "$PKG_PATH" ] && export PKG_PATH="https://ftp.openbsd.org/pub/OpenBSD/$(uname -r)/packages/$(uname -m)/"
							pkg_add -u || { echo "pkg_add update failed"; exit 1; }
							read -p "Reboot system? [y/N]: " ans
							if [[ "$ans" =~ ^[yY]$ ]]; then
								echo "System reboot initiated..."
								sleep 2
								reboot
							else
								read -rp "Press enter to return..."
							fi
						elif [[ $PKG_MGR == "slackpkg" ]]; then
							slackpkg update && slackpkg upgrade-all -batch=on || { echo "slackpkg update failed"; exit 1;}
							read -p "Reboot system? [y/N]: " ans
							if [[ "$ans" =~ ^[yY]$ ]]; then
								echo "System reboot initiated..."
								sleep 2
								reboot
							else
								read -rp "Press enter to return..."
							fi
						elif [[ $PKG_MGR == "spack" ]]; then
							echo "Spack does not support system-wide updates. Use Update by Package instead."
							read -rp "Press enter to return..."
						elif [[ $PKG_MGR == "yum" ]]; then
							yum update -y || { echo "yum update failed"; exit 1; }
							read -p "Reboot system? [y/N]: " ans
							if [[ "$ans" =~ ^[yY]$ ]]; then
								echo "System reboot initiated..."
								sleep 2
								reboot
							else
								read -rp "Press enter to return..."
							fi
						elif [[ $PKG_MGR == "zypper" ]]; then
							zypper refresh && zypper update -y || { echo "zypper update failed"; exit 1; }
							read -p "Reboot system? [y/N]: " ans
							if [[ "$ans" =~ ^[yY]$ ]]; then
								echo "System reboot initiated..."
								sleep 2
								reboot
							else
								read -rp "Press enter to return..."
							fi
						else
							echo "Unsupported package manager: $PKG_MGR"
							exit 1
						fi
						;;
					"Update by Package")
						get_outdated_packages() {
							case $PKG_MGR in
								apk)
									apk update >/dev/null 2>&1 && apk upgrade --simulate | awk '/Upgrading/ {print $2}' | sort -u
									;;
								apt)
									apt update >/dev/null 2>&1 && apt list --upgradable 2>/dev/null | awk -F/ '!/^Listing/ {print $1}' | sort -u
									;;
								conda)
									conda list --outdated 2>/dev/null | awk '!/^#/ {print $1}' | sort -u
									;;
								dnf)
									dnf check-update --refresh 2>/dev/null | awk '/^[a-zA-Z0-9]/ {print $1}' | sort -u
									;;
								emerge)
									emerge --sync >/dev/null 2>&1 && emerge -puD @world | awk '/^\[ebuild/ {print $3}' | sort -u
									;;
								nix-env)
									nix-channel --update >/dev/null 2>&1 && nix-env --upgrade --dry-run | awk '/upgrading/ {gsub(/'\''/, "", $2); print $2}' | sort -u
									;;
								pacman)
									pacman -Syup --print-format %n 2>/dev/null | grep -E '^[a-zA-Z0-9._+-]+$' | sort -u
									;;
								pkg)
									pkg update >/dev/null 2>&1 && pkg version -l '<' | awk '{print $1}' | sed 's/-.*$//' | sort -u
									;;
								pkgin)
									pkgin -y update >/dev/null 2>&1 && pkgin avail -u | awk '{print $1}' | sed 's/-.*$//' | sort -u
									;;
								pkg_add)
									pkg_info -u | awk '{print $1}' | sed 's/-.*$//'
									;;
								slackpkg)
									slackpkg update >/dev/null 2>&1 && slackpkg upgrade --dry-run | awk '/Upgrading/ {print $2}' | sort -u
									;;
								spack)
									spack list --outdated 2>/dev/null | awk '{print $1}' | sort -u
									;;
								yum)
									yum check-update 2>/dev/null | awk '/^[a-zA-Z0-9]/ {print $1}' | sort -u
									;;
								zypper)
									zypper refresh >/dev/null 2>&1 && zypper list-updates | awk '$1 == "v" {print $3}' | sort -u
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
						continue
					fi
					readarray -t OUTDATED_ARRAY <<<"$OUTDATED"	
					PACKAGES=($(echo "${OUTDATED_ARRAY[@]}" | fzf --multi --prompt="Select packages to update: " --height=20 --border))
					
					if [[ ${#PACKAGES[@]} -eq 0 ]]; then
						echo "No packages selected."
						sleep 2
						continue
					fi

					declare -a installed_pkgs=()
					
					for pkg in "${PACKAGES[@]}"; do
						log "$TOOLBOX_USER is updating $pkg using $PKG_MGR"
						case $PKG_MGR in
							apk)
								apk upgrade "$pkg"
								;;
							apt)
								apt install --only-upgrade "$pkg" -y
								;;
							conda)
								conda install "$pkg" -y
								;;
							dnf)
								dnf upgrade "$pkg" -y
								;;
							emerge)
								emerge "$pkg" --ask=n
								;;
							nix-env)
								nix-env --upgrade "$pkg"
								;;
							pacman)
								pacman -S "$pkg" --noconfirm
								;;
							pkg)
								pkg upgrade "$pkg" -y
								;;
							pkgin)
								pkgin -y upgrade "$pkg"
								;;
							pkg_add)
								pkg_add -u "$pkg"
								;;
							slackpkg)
								slackpkg upgrade "$pkg" -batch=on
								;;
							spack)
								spack install "$pkg" -y
								;;
							yum)
								yum upgrade "$pkg" -y
								;;
							zypper)
								zypper install --no-recommends "$pkg" -y
								;;
							*)
								echo "Unsupported package manager: $PKG_MGR"
								continue
								;;
						esac
					done
				
					if [[ "${PACKAGES[*]}" =~ clamav ]]; then
						command -v freshclam &>/dev/null && freshclam
					fi
					
					read -rp "Press enter to return..."
					;;
				"Back")
					echo "Returning to menu..."
					echo ""
					echo ""
					break
					;;
				*)
					echo "Invalid update choice: $update_choice"
					sleep 2
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

# System Monitoring Submenu
sys_mon() {
	while true; do
		choice=$(echo -e "Back\nView Memory Info\nShow Virtual Memory Stats\nShow Last Boot Time\nShow Free Memory\nMonitor Processes (top)\nMonitor Processes (htop)\nList Processes" | fzf)
        
		if [[ -z "$choice" ]]; then
			echo "No selection made. Returning to main menu..."
			sleep 2
			break
		fi
		case "$choice" in
			"List Processes")
				read -p "Enter process filter (e.g., 'aux' or press Enter for default 'ps'): " opts
				read -p "Enter user to filter (or press Enter for none): " user
				if [[ -n "$user" ]]; then
					cmd="ps $opts | grep $user"
					log "$TOOLBOX_USER listed processes for user using '$cmd'"
					echo "[$TOOLBOX_USER@$HOST]$ $cmd"
					echo ""
					echo ""
					ps "$opts" | grep "$user" | tee -a "$LOG_FILE"
					sleep 1
					echo ""
					echo ""
					read -rp "Press enter to return..."
				elif [[ -n "$opts" ]]; then
					cmd="ps $opts"
					log "$TOOLBOX_USER listed processes using '$cmd'"
					echo ""
					echo ""
					echo "[$TOOLBOX_USER@$HOST]$ $cmd"
					ps "$opts" | tee -a "$LOG_FILE"
					sleep 1
					echo ""
					echo ""
					read -rp "Press enter to return..."
				else
					cmd="ps"
					log "$TOOLBOX_USER listed processes using '$cmd'"
					echo ""
					echo ""
					echo "[$TOOLBOX_USER@$HOST]$ $cmd"
					$cmd | tee -a "$LOG_FILE"
					sleep 1
					echo ""
					echo ""
					read -rp "Press enter to return..."
				fi
				;;
			"Monitor Processes (htop)")
				cmd="htop"
				log "$TOOLBOX_USER monitored processes using '$cmd'"
				echo ""
				echo ""
				echo "[$TOOLBOX_USER@$HOST]$ $cmd"
				$cmd | tee -a "$LOG_FILE"
				sleep 1
				echo ""
				echo ""
				;;
			"Monitor Processes (top)")
				cmd="top"
				log "$TOOLBOX_USER monitored processes using '$cmd'"
				echo ""
				echo ""
				echo "[$TOOLBOX_USER@$HOST]$ $cmd"
				$cmd | tee -a "$LOG_FILE"
				sleep 1
				echo ""
				echo ""
				;;
			"Show Free Memory")
				cmd="free -hw"
				log "$TOOLBOX_USER viewed free memory using '$cmd'"
				echo "[$TOOLBOX_USER@$HOST]$ $cmd"
				echo ""
				echo ""
				$cmd | tee -a "$LOG_FILE"
				sleep 1
				echo ""
				echo ""
				read -rp "Press enter to return..."
				;;
			"Show Last Boot Time")
				cmd="who -b"
				log "$TOOLBOX_USER viewed last boot time using '$cmd'"
				echo "[$TOOLBOX_USER@$HOST]$ $cmd"
				echo "" 
				echo ""
				$cmd | tee -a "$LOG_FILE"
				sleep 1
				echo ""
				echo ""
				read -rp "Press enter to return..."
				;;
			"Show Virtual Memory Stats")
				cmd="vmstat -sw"
				log "$TOOLBOX_USER viewed virtual memory stats using '$cmd'"
				echo "[$TOOLBOX_USER@$HOST]$ $cmd"
				echo ""
				echo ""
				$cmd | tee -a "$LOG_FILE"
				sleep 1
				echo ""
				echo ""
				read -rp "Press enter to return..."
				;;
			"View Memory Info")
				cmd="less /proc/meminfo"
				log "$TOOLBOX_USER viewed memory info using '$cmd'"
				echo ""
				echo ""
				echo "[$TOOLBOX_USER@$HOST]$ $cmd"
				$cmd
				sleep 1
				echo ""
				echo ""
				read -rp "Press enter to return..."
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

# Service Statuses Submenu
srv_stat() {
	while true; do
		choice=$(echo -e "Back\nManage Service\nList Services\nList Processes" | fzf)
        
		if [[ -z "$choice" ]]; then
			echo "No selection made. Returning to main menu..."
			sleep 2
			break
		fi

		case "$choice" in
			"List Processes")
				read -p "Enter process filter (e.g., 'aux' or press Enter for default 'ps'): " opts
				read -p "Enter user to filter (or press Enter for none): " user
				if [[ -n "$user" ]]; then
					cmd="ps $opts | grep $user"
					log "$TOOLBOX_USER listed processes for user using '$cmd'"
					echo "[$TOOLBOX_USER@$HOST]$ $cmd"
					echo ""
					echo ""
					$cmd | tee -a "$LOG_FILE"
					sleep 1
					echo ""
					echo ""
					read -rp "Press enter to return..."
				elif [[ -n "$opts" ]]; then
					cmd="ps $opts"
					log "$TOOLBOX_USER listed processes using '$cmd'"
					echo ""
					echo ""
					echo "[$TOOLBOX_USER@$HOST]$ $cmd"
					$cmd | tee -a "$LOG_FILE"
					sleep 1
					echo ""
					echo ""
					read -rp "Press enter to return..."
				else
					cmd="ps"
					log "$TOOLBOX_USER listed processes using '$cmd'"
					echo ""
					echo ""
					echo "[$TOOLBOX_USER@$HOST]$ $cmd"
					$cmd | tee -a "$LOG_FILE"
					sleep 1
					echo ""
					echo ""
					read -rp "Press enter to return..."
				fi
				;;
			"List Services")
				cmd="systemctl list-units --type=service --all --no-legend | fzf | awk '{print \$1}'"
				log "$TOOLBOX_USER listed services using '$cmd'"
				echo ""
				echo ""
				echo "[$TOOLBOX_USER@$HOST]$ $cmd"
				service=$(eval $cmd)
				if [[ -z "$service" ]]; then
					echo "No service selected."
					sleep 2
				else
					echo "$service" | tee -a "$LOG_FILE"
					sleep 1
					echo ""
					echo ""
					read -rp "Press enter to return..."
				fi
				;;
			"Manage Service")
				read -p "Enter service name: " service
				read -p "Enter action (start/stop/restart/status): " action
				if [[ -n "$service" && -n "$action" ]]; then
					cmd="systemctl $action $service"
					log "$TOOLBOX_USER managed service using '$cmd'"
					echo ""
					echo ""
					echo "[$TOOLBOX_USER@$HOST]$ $cmd"
					$cmd | tee -a "$LOG_FILE"
					sleep 1
					echo ""
					echo ""
					read -rp "Press enter to return..."
				else
					echo "Invalid service name or action."
					sleep 2
				fi
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

# System Information Submenu
sys_info() {
	while true; do
		choice=$(echo -e "Back\nShow Uptime (pretty)\nShow System Uptime (since)\nShow System Uptime\nShow Memory Info\nShow Kernel Info\nShow CPU Info" | fzf)
        
		if [[ -z "$choice" ]]; then
			echo "No selection made. Returning to main menu..."
			sleep 2
			break
		fi

		case "$choice" in
			"Show CPU Info")
				cmd="lscpu"
				log "$TOOLBOX_USER viewed CPU info using '$cmd'"
				echo "[$TOOLBOX_USER@$HOST]$ $cmd"
				echo ""
				echo ""
				$cmd | tee -a "$LOG_FILE"
				sleep 1
				echo ""
				echo ""
				read -rp "Press enter to return..."
				;;
			"Show Kernel Info")
				cmd="uname -a"
				log "$TOOLBOX_USER viewed kernel info using '$cmd'"
				echo "[$TOOLBOX_USER@$HOST]$ $cmd"
				echo ""
				echo ""
				$cmd | tee -a "$LOG_FILE"
				sleep 1
				echo ""
				echo ""
				read -rp "Press enter to return..."
				;;
			"Show Memory Info")
				cmd="lsmem"
				log "$TOOLBOX_USER viewed memory info using '$cmd'"
				echo "[$TOOLBOX_USER@$HOST]$ $cmd"
				echo ""
				echo ""
				$cmd | tee -a "$LOG_FILE"
				sleep 1
				echo ""
				echo ""
				read -rp "Press enter to return..."
				;;
			"Show System Uptime")
				cmd="uptime"
				log "$TOOLBOX_USER viewed uptime using '$cmd'"
				echo "[$TOOLBOX_USER@$HOST]$ $cmd"
				echo ""
				echo ""
				$cmd | tee -a "$LOG_FILE"
				sleep 1
				echo ""
				echo ""
				read -rp "Press enter to return..."
				;;
			"Show System Uptime (since)")
				cmd="uptime -s"
				log "$TOOLBOX_USER viewed uptime (since) using '$cmd'"
				echo "[$TOOLBOX_USER@$HOST]$ $cmd"
				echo ""
				echo ""
				$cmd | tee -a "$LOG_FILE"
				sleep 1
				echo ""
				echo ""
				read -rp "Press enter to return..."
				;;
			"Show Uptime (pretty)")
			cmd="uptime -p"
			log "$TOOLBOX_USER viewed uptime (pretty) using '$cmd'"
			echo "[$TOOLBOX_USER@$HOST]$ $cmd"
			echo ""
			echo ""
			$cmd | tee -a "$LOG_FILE"
			sleep 1
			echo ""
			echo ""
			read -rp "Press enter to return..."
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
