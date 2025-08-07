# The-Abyss
A collection of Bash-based sysadmin tools for secure, efficient, and lightweight system management.

## SHA512 Checksums

Here are the SHA512 sums for important scripts in this repo:
2d29fdf3d2895e79814e85f7fcd41da34e6daa9f1cc6fdbedbcb44693f40bf6e988cd9360830360ddb241f03c29adb27091725e4d4380091d2d24f569e16a332  ./abyss-toolbox/functions.sh

1fcd6bbdf73090701eed42cf5bf189c01c238da5a89650a1d59474dd9c7009138467640d229828b76606a61760ed5043ee39cd94974b45a002da77a970d32a88  ./abyss-toolbox/initialize.sh

c079e1a1104baf4fd416b99d0d665f4aab0f1dfd518dc96a1bf9279320527dacedfdf550425cb2eeab1ab256462780e82442d19ab95329a3e0f452b9f3d7d318  ./abyss-toolbox/install.sh

db525f79ed89b4b640de54909e76a891c545167594c9b5bf44195e6d9e804839e3b45a4c73148f7c7b8a739fb6d2031b3a8421cd0acee54ed7cb72611ae64c6e  ./abyss-toolbox/toolbox.sh

9c1e82b6f15e0ae8a16bf0a061725a38e38cd1f6b050e97612ebc15728d83bcd872fd803e13362e6fcc3f18e7ae82b6cd0736a41e10c8a7bbf672d95fac919a8  ./abyss-toolbox/uninstall.sh

da8831ba460c053dd165543e6a3465d52f4fc915214dc402a5f31bd1938241e8dd39159aea57369bdfe9c841aa01a5dfb5547b302110145481798b8cd598cb9d  ./abyss-toolbox/update.sh

## Verifying Script Integrity

To verify that the scripts you downloaded haven't been tampered with, you can run:

```bash
sha512sum --check CHECKSUM

This command will compare the downloaded scripts against the expected SHA512 hashes listed in the CHECKSUM file and report if everything matches.

Alternatively, use our provided verification script:
chmod +x verify
./verify

## Quick Start

> **Step into `/tmp` or be consumed.**
```bash
# (If you're not already in /tmp)
cd /tmp

Download the Latest Release
You can download and extract the latest .tar.gz release to /tmp using either wget or curl:
Option 1: Using wget
wget https://github.com/LordSodomiser/The-Abyss/releases/download/0.1.1/abyss-0.1.1.tar.xz

Option 2: Using curl
curl -LO https://github.com/LordSodomiser/The-Abyss/releases/download/0.1.1/abyss-0.1.1.tar.xz

1. Extract the Archive

tar -xJvf abyss-0.1.1.tar.xz
cd The-Abyss/abyss-toolbox
chmod +x *.sh

2. Initialize the Environment
Prepares traps, detects your distro, ensures permissions, and lays the foundation.

./initialize.sh

3. Install the Toolbox
Installs required packages, places toolbox into your $PATH, and offers to clean up.

./install.sh

4. Invoke the Abyss (Should you run the cleanup, the directory you inhabit (/tmp) will vanish. You’ll need to ‘cd’ to emerge from the void.)

cystoolbox

Or if you’re still shy:
/opt/The-Abyss/abyss-toolbox/toolbox.sh

## Support the Project

If this project helped you, consider donating:

https://ko-fi.com/lordsodomiser
