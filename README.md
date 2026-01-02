<h1 align="center">
Android Secret Dialer Code Extraction Tool 🔍
</h1>

<p align="center">
  <img src="https://github.com/DouglasFreshHabian/SecretCodes/blob/main/Assets/SecretCodes.png"
       alt="SecretCodes Logo"
       width="700">
</p>

**SecretCodes** is a Bash-based utility for enumerating **`android_secret_code`** dialer codes across system and pre-installed applications on Android devices. It leverages **ADB (Android Debug Bridge)** to extract hidden secret codes safely and efficiently from a non-rooted device.

Whether you’re a security researcher, forensic analyst, or Android enthusiast, this script collects secret codes in a structured format, including **text**, **CSV**, or **JSON** exports.

---

### ⚙️ Prerequisites

Before you begin, ensure you have:

* **ADB installed** on your system:

```bash
sudo apt install adb -y
````

* **USB debugging enabled** on the target Android device.
* Exactly **one authorized device connected** to avoid ambiguous results.
* Proper **authorization** to access the device.

---

### 🔌 Verify ADB Connection

Check that your device is detected and authorized:

```bash
adb devices
```

Example output:

```
List of devices attached
RZ8N1234XYZ	device
```

---

### 📱 Run SecretCodes Script

1. Clone the repository:

```bash
git clone https://github.com/DouglasFreshHabian/SecretCodes.git
cd SecretCodes
```

2. Make the script executable:

```bash
chmod +x secretCodes.sh
```

3. Execute the script (default text output):

```bash
./secretCodes.sh
```

---

### 📤 Export Options

The script supports multiple output modes:

| Option       | Description                                            |
| ------------ | ------------------------------------------------------ |
| `--csv`      | Export results to CSV for spreadsheet use              |
| `--json`     | Export results to JSON for programmatic use            |
| `--quiet`    | Suppress console output, write directly to output file |
| `--help`     | Display help menu                                      |

**Examples:**

```bash
./secretCodes.sh --csv
./secretCodes.sh --json --quiet
```

Output files are automatically timestamped and include device metadata:

```
Secret_Codes_2025-12-31_12-00-00.csv
Secret_Codes_2025-12-31_12-00-00.json
Secret_Codes_2025-12-31_12-00-00.txt
```

---

### 🧠 How It Works

* Enumerates **system packages** (`pm list packages -s`) via ADB.
* Extracts **android_secret_code** authorities from package manifests (`pm dump`).
* Filters and deduplicates codes for clean output.
* Supports **structured CSV and JSON** export alongside text for human readability.
* Adds a **colorized console output** for easy readability (unless `--quiet` is used).

---

### 🧩 Included Script

#### **`secretCodes.sh`**

* Bash utility for automated enumeration of hidden Android secret codes.
* Works on **non-rooted devices**.
* Output formats: **text**, **CSV**, **JSON**.
* Supports **QUIET mode** for silent operation.

> ⚠️ Some secret codes may not be accessible on modern devices due to OEM restrictions or Android version limitations.

---

### 🧱 Directory Structure

```
SecretCodes/
├── secretCodes.sh
├── Assets/
│   └── SecretCodes.png
├── outputs/
│   └── Secret_Codes_2025-12-31_12-00-00.csv
└── README.md
```

---

### ⚖️ Legal & Ethical Notice

* Use **SecretCodes** only on devices you **own or have explicit permission** to analyze.
* Collected secret codes may contain sensitive operations or hidden features.
* Unauthorized use could violate device manufacturer policies or local laws.

---

### 💬 Feedback & Contributions

Contributions, bug reports, or feature suggestions are welcome. Open an issue or submit a pull request to improve the tool for the community.

---

### ☕ Support This Project

If **SecretCodes™** helps your research or forensic work, consider supporting ongoing development:

<p align="center">
  <a href="https://www.buymeacoffee.com/dfreshZ" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>
</p>

---

<!-- 
    Fresh Forensics, LLC | Douglas Fresh Habian | 2025
    github.com/DouglasFreshHabian
    freshforensicsllc@tuta.com
-->
