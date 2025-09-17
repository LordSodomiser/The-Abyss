# The-Abyss

A lightweight, Bash-based sysadmin toolbox for secure and efficient management of headless Linux servers. Designed for simplicity and zero dependencies, The-Abyss Sysadmin Toolbox streamlines server administration with essential utilities. Now includes the Abyss Vault for secure storage and management, with potential for more features in the future.

## Features

- **Lightweight**: Zero-dependency Bash scripts for minimal footprint.
- **Secure**: Focus on secure system management practices.
- **Portable**: Runs on most Linux distributions with distro detection.
- **Evolving**: Core toolbox and vault are functional; more enhancements planned.
- **New Functions**: Added `--update` and `--uninstall` options for streamlined management.

## SHA512 Checksums

Verify the integrity of downloaded scripts with these SHA512 checksums:

```
b71f44e434a1dddb515d4876ee698eaff6745be026ac5e43c620facf4c726790a27aa0a3b27419d31bc4bc55009d7b940f717acfd7eba82ab6bee67c37b08938  ./abyss-toolbox/functions.sh
926e082aaeac10df1d79d90ee2d0fb63061b747dfbf718bf771a1c6ccbf015bf96b7db1cdd808c5ec39aeb91abb2ffd2410428135c89bc24a51ea9e6242c5730  ./abyss-toolbox/install.sh
11c67d3f18c784d1388adb6dce5f7374791b14e6ba5dee7ee64521af5722a011375fa63dbcf40ea53048c66f0e373c8079dcfac2d724cdf622adc94563c706db  ./abyss-toolbox/toolbox.sh
28ecd71e160271c807d9668f379ac270f8c548e8fa74cc286b3c03954e8d8903b1986b9d6129e4c10da7d03b15e3c94f139cb572cc14ceda81e9d56195a55238  ./abyss-vault/functions.sh
6a537ae113c01843db98b15b0769055d6f52dbd2c84462463ce40afc7bb8acbb1649047c6a6ce625351e9a8a13c54eb026747247a8b9a3d880128e3d4e5c600b  ./abyss-vault/install.sh
3ac5908ecf12ccedf5ec8c8f895f58cc0dcee8331ded5e0424089a3372fbef5472c616fbb1a13b22a7860a384c744c1d212dcff2627d81f2e9cc9daff2b2ee6f  ./abyss-vault/vault.sh
```

### Verifying Script Integrity

To ensure scripts haven't been tampered with, run:

```bash
sha512sum --check CHECKSUM
```

Alternatively, use the provided verification script:

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

   Download the latest release (v0.1.1). The `git clone` method is recommended as it provides the latest updates directly from the GitHub repository, which may include newer features and fixes still undergoing testing. The `wget` and `curl` options are for stable release tarballs, which undergo more extensive testing but may lag behind the repository:

   - **Using git clone** (recommended for latest updates):
     ```bash
     git clone https://github.com/LordSodomiser/The-Abyss.git
     ```

   - **Using wget** (stable release):
     ```bash
     wget https://github.com/LordSodomiser/The-Abyss/releases/download/0.1.1/abyss-0.1.1.tar.xz
     ```

   - **Using curl** (stable release):
     ```bash
     curl -LO https://github.com/LordSodomiser/The-Abyss/releases/download/0.1.1/abyss-0.1.1.tar.xz
     ```

2. **Extract and Prepare (if using tarball)**

   ```bash
   tar -xJvf abyss-0.1.1.tar.xz
   ```

3. **Set Permissions**

   Navigate to either the toolbox or vault directory and make scripts executable:

   ```bash
   cd The-Abyss/abyss-toolbox
   chmod +x *.sh
   ```

   Or, for the vault:

   ```bash
   cd The-Abyss/abyss-vault
   chmod +x *.sh
   ```

4. **Install the Toolbox or Vault**

   Installs dependencies, adds The-Abyss to your `$PATH`, and offers cleanup:

   ```bash
   ./install.sh
   ```

5. **Invoke the Abyss**

   Run the toolbox:

   ```bash
   cystoolbox
   ```

   Or, run the vault:

   ```bash
   cadavault
   ```

   Alternatively, use the full path:

   ```bash
   /opt/The-Abyss/abyss-toolbox/toolbox.sh
   ```

   Or, for the vault:

   ```bash
   /opt/The-Abyss/abyss-vault/vault.sh
   ```

   > **Note**: If you ran cleanup, the `/tmp/The-Abyss` directory is removed. Use `cd` to navigate to a new directory.

6. **Update or Uninstall**

   Update the toolbox or vault to the latest version:

   ```bash
   cystoolbox --update
   ```

   Or, for the vault:

   ```bash
   cadavault --update
   ```

   Uninstall the toolbox or vault:

   ```bash
   cystoolbox --uninstall
   ```

   Or, for the vault:

   ```bash
   cadavault --uninstall
   ```

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
