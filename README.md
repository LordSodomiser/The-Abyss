# The-Abyss
A collection of Bash-based sysadmin tools for secure, efficient, and lightweight system management.

## SHA512 Checksums

Here are the SHA512 sums for important scripts in this repo:
3bc38f46da45f5252eda117e305c015f9e778648c9ba71a434af34afa3ff27a6091291e86fdf73c7e9d62a8b0e395ead500ca2be1ddab8f68a5d3c20406768c0  ./abyss-toolbox/functions.sh

8bcf7cbbfc4995c02544f9d915a76de98b00e0b32add0428678f935518e92e2b1ad1b81986569098b0e819fbff57f66f7dcdc5656c348b99a53232cc059270a8  ./abyss-toolbox/initialize.sh

49a844757c82708f9718ac4b583c741212ab299fd15a40a6aa06e9d68e0e871039aea985983ebe23f0f267a2e626375deb43630d201d35f206c2e882470e3703  ./abyss-toolbox/install.sh

82d59caba0db7a1dcd98d5f38b8ac83ecf4cd6c49475f6bd21ea3562d6e32064f73f3f38ce653c8bf06cd60f643eb9aaa8ce5458b952c15287a08f9a3f70d2fb  ./abyss-toolbox/toolbox.sh

## Verifying Script Integrity

To verify that the scripts you downloaded haven't been tampered with, you can run:

```bash
sha512sum --check CHECKSUM

This command will compare the downloaded scripts against the expected SHA512 hashes listed in the CHECKSUM file and report if everything matches.

Alternatively, use our provided verification script:
./verify

## Quick Start

> **Step into `/tmp` or be consumed.**
```bash
# (If you're not already in /tmp)
cd /tmp

Download the Latest Release
You can download and extract the latest .tar.gz release to /tmp using either wget or curl:
Option 1: Using wget
wget https://github.com/LordSodomiser/The-Abyss/releases/download/0.1.0/abyss_toolbox-0.1.0.tar.xz

Option 2: Using curl
curl -LO https://github.com/LordSodomiser/The-Abyss/releases/download/0.1.0/abyss_toolbox-0.1.0.tar.xz

1. Extract the Archive

tar -xJvf abyss-0.1.0.tar.xz
cd The-Abyss/abyss-toolbox

2. Initialize the Environment
Prepares traps, detects your distro, ensures permissions, and lays the foundation.

./initialize.sh

3. Install the Toolbox
Installs required packages, places toolbox into your $PATH, and offers to clean up.

./install.sh

4. Invoke the Abyss (Should you run the cleanup, the directory you inhabit (/tmp) will vanish. You’ll need to ‘cd’ to emerge from the void.)

cystoolbox
Or if you’re still shy:
cd /opt/The-Abyss/abyss-toolbox/toolbox.sh

## Support the Project

If this project helped you, consider donating:

https://ko-fi.com/lordsodomiser
