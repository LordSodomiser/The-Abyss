# The-Abyss

A lightweight, Bash-based sysadmin toolbox for secure and efficient management of headless Linux servers. Designed for simplicity and zero dependencies, The-Abyss Sysadmin Toolbox streamlines server administration with essential utilities. Future expansions include tools like Modular Dotfile Manager, TUI .onion Site Manager, and Offline Encrypted Vault Generator.

## Features

- **Lightweight**: Zero-dependency Bash scripts for minimal footprint.
- **Secure**: Focus on secure system management practices.
- **Portable**: Runs on most Linux distributions with distro detection.
- **Evolving**: Core toolbox is functional; additional modules in development.

## SHA512 Checksums

Verify the integrity of downloaded scripts with these SHA512 checksums:

```
428d8c2e5a57a6659048c15e6b993990f3a2eece0a2a8a418b1e60adb27534f05553a9e4e729c2ef8e165927726849a70f557fe8a9a1c6628b7ac4b34996a8ba  ./abyss-toolbox/functions.sh
be1cef9e07ddd676b0e341a214322155b069fc66a602caf92cb1c0460a0aedbdaef53da7bcc8e7809371d59e3ec9191a5b795ecfe66a3383e9be78cca3860cf0  ./abyss-toolbox/initialize.sh
865272cd4e03a3312fa762a4629a443454596493b3421b3c9d7789743f6f6c119d9a3a91ad2a0151906d74d02adc558adada948cdd51b9a62ef2c06715720969  ./abyss-toolbox/install.sh
db525f79ed89b4b640de54909e76a891c545167594c9b5bf44195e6d9e804839e3b45a4c73148f7c7b8a739fb6d2031b3a8421cd0acee54ed7cb72611ae64c6e  ./abyss-toolbox/toolbox.sh
9c1e82b6f15e0ae8a16bf0a061725a38e38cd1f6b050e97612ebc15728d83bcd872fd803e13362e6fcc3f18e7ae82b6cd0736a41e10c8a7bbf672d95fac919a8  ./abyss-toolbox/uninstall.sh
6b7cc009ffcf3fabba6528977b0368f05a2054ba0331ea79410be1ce8611a4c75477b224ece4ec8bb14b87b866f0ce298d19f5a18cc587fcb0dae8c351e07476  ./abyss-toolbox/update.sh
```

### Verifying Script Integrity

To ensure scripts haven't been tampered with, run:

```bash
sha512sum --check CHECKSUM
```

This compares downloaded scripts against the listed SHA512 hashes. Alternatively, use the provided verification script:

```bash
chmod +x verify
./verify
```

## Quick Start

> **Step into `/tmp` or be consumed by the void.**

1. **Download the Latest Release**

   Navigate to `/tmp` to avoid cluttering your system:

   ```bash
   cd /tmp
   ```

   Download and extract the latest release (v0.1.1):

   - **Using wget**:
     ```bash
     wget https://github.com/LordSodomiser/The-Abyss/releases/download/0.1.1/abyss-0.1.1.tar.xz
     ```

   - **Using curl**:
     ```bash
     curl -LO https://github.com/LordSodomiser/The-Abyss/releases/download/0.1.1/abyss-0.1.1.tar.xz
     ```

2. **Extract and Prepare**

   ```bash
   tar -xJvf abyss-0.1.1.tar.xz
   cd The-Abyss/abyss-toolbox
   chmod +x *.sh
   ```

3. **Initialize the Environment**

   Sets up traps, detects your distro, and ensures proper permissions:

   ```bash
   ./initialize.sh
   ```

4. **Install the Toolbox**

   Installs dependencies, adds The-Abyss to your `$PATH`, and offers cleanup:

   ```bash
   ./install.sh
   ```

5. **Invoke the Abyss**

   Run the toolbox:

   ```bash
   cystoolbox
   ```

   Or, if you prefer the full path:

   ```bash
   /opt/The-Abyss/abyss-toolbox/toolbox.sh
   ```

   > **Note**: If you ran cleanup, the `/tmp/The-Abyss` directory is removed. Use `cd` to navigate to a new directory.

## Contributing

We welcome contributions! Check out our [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on reporting bugs, suggesting features, or submitting pull requests. Testers are especially needed to help squash minor bugs—join the effort!

## Contact
Created and Maintained By
LordSodomiser (Into the Abyss) <lordsodomiser@proton.me>

## Support the Project

If The-Abyss saves you time, consider supporting its development:

[Donate via Ko-fi](https://ko-fi.com/lordsodomiser)

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
