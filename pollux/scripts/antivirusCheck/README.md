# **Antivirus Scripts README**

This directory contains scripts for monitoring and managing antivirus status on both Linux and Windows systems. These scripts are designed to provide detailed reports on antivirus status, including definitions, scans, and overall functionality.

---

## **Scripts Overview**

### **1. Windows Script**

- **`AntivirusCheck.ps1`:** A PowerShell script designed for systems running Windows Defender or other antivirus software registered with the Windows Security Center.

### **2. Linux Script**

- **`AntivirusCheck.sh`:** A Bash script for checking antivirus software commonly used on Linux systems. It logs scan history and reports the update status of virus definitions.

---

## **Features**

### **Windows Script**
- Checks antivirus status (e.g., running status, definitions, and scan activity).
- Supports both Windows Defender and third-party antivirus solutions.
- Logs results to a file for auditing purposes.

### **Linux Script**
- Verifies if any antivirus software is installed and running.
- Logs details about recent virus definition updates.
- Reports the results of recent scans, including files scanned and threats detected.
- Provides fewer details compared to the Windows version due to differences in how antivirus software is managed on Linux.

### **Supported Linux Antivirus Solutions**
The Linux script includes checks for the following antivirus software:
- **ClamAV**
- **Sophos**
- **ESET**
- **Kaspersky**
- **Comodo**
- **F-Secure**
- **Trend Micro**
- **Bitdefender**
- **Avast**

For any other antivirus software, a generic message indicating the status check is not implemented will be logged.

---