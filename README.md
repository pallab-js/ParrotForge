# Parrot OS Optimization Script

A comprehensive shell script to optimize Parrot OS for better performance, responsiveness, and resource management.

![Parrot OS Logo](https://upload.wikimedia.org/wikipedia/commons/thumb/1/1b/Parrot_os_logo.svg/1200px-Parrot_os_logo.svg.png)
<p align="center"><i>This script tunes various system settings, from kernel parameters to desktop effects.</i></p>

---

## ⚠️ Disclaimer

This script makes significant changes to your system configuration and requires **root privileges**. The author is not responsible for any damage or data loss that may occur. **Please back up your important data before running this script.**

---

## ✨ Features

- **System Cleanup:** Updates, upgrades, and removes unnecessary packages.
- **Service Management:** Disables non-essential services like `bluetooth` and `cups` to free up resources.
- **Kernel & Swap Tuning:** Optimizes `swappiness` and configures `zram` with `lz4` compression for faster swap operations.
- **Boot Time Reduction:** Reduces the GRUB timeout and disables `NetworkManager-wait-online.service`.
- **I/O Optimization:** Applies the `noatime` mount option to reduce disk writes and improve SSD longevity.
- **Desktop Responsiveness:** Disables XFCE compositing and desktop icons for a snappier user interface.
- **Automated Temp File Cleaning:** Installs `tmpreaper` for safe, periodic cleanup of temporary files.

---

## 🚀 Usage

1.  **Clone the repository:**
    ```sh
    git clone [https://github.com/your-username/your-repo-name.git](https://github.com/your-username/your-repo-name.git)
    cd your-repo-name
    ```

2.  **Make the script executable:**
    ```sh
    chmod +x optimize_parrot.sh
    ```

3.  **Run the script with root privileges:**
    ```sh
    sudo ./optimize_parrot.sh
    ```

4.  **Reboot your system** to apply all the changes.

---

## 🤝 Contributing

Contributions are welcome! If you have suggestions for improvements, feel free to open an issue or submit a pull request.