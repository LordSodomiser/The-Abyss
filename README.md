# The-Abyss
A collection of Bash-based sysadmin tools for secure, efficient, and lightweight system management.

## SHA512 Checksums

Here are the SHA512 sums for all scripts in this repo:
428d8c2e5a57a6659048c15e6b993990f3a2eece0a2a8a418b1e60adb27534f05553a9e4e729c2ef8e165927726849a70f557fe8a9a1c6628b7ac4b34996a8ba  ./abyss-toolbox/functions.sh

1fcd6bbdf73090701eed42cf5bf189c01c238da5a89650a1d59474dd9c7009138467640d229828b76606a61760ed5043ee39cd94974b45a002da77a970d32a88  ./abyss-toolbox/initialize.sh

865272cd4e03a3312fa762a4629a443454596493b3421b3c9d7789743f6f6c119d9a3a91ad2a0151906d74d02adc558adada948cdd51b9a62ef2c06715720969  ./abyss-toolbox/install.sh

db525f79ed89b4b640de54909e76a891c545167594c9b5bf44195e6d9e804839e3b45a4c73148f7c7b8a739fb6d2031b3a8421cd0acee54ed7cb72611ae64c6e  ./abyss-toolbox/toolbox.sh

9c1e82b6f15e0ae8a16bf0a061725a38e38cd1f6b050e97612ebc15728d83bcd872fd803e13362e6fcc3f18e7ae82b6cd0736a41e10c8a7bbf672d95fac919a8  ./abyss-toolbox/uninstall.sh

6b7cc009ffcf3fabba6528977b0368f05a2054ba0331ea79410be1ce8611a4c75477b224ece4ec8bb14b87b866f0ce298d19f5a18cc587fcb0dae8c351e07476  ./abyss-toolbox/update.sh



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
