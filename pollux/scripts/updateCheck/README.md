# **Update checker script README**

This directory contains scripts for verifying the OS version, and detect newer one. There are one for Linux and one for Windows.

---

## **Scripts Overview**

### **1. Windows Script**

- **`updateCheck.ps1`:** A PowerShell script designed for systems running Windows.

### **2. Linux Script**

- **`updateCheck.sh`:** A Bash script for checking Windows version.

---

## **Features**

### **Windows Script**
- Checks if the Windows system is up to date using the Windows Update API.
- Identifies available updates and their details (e.g., security updates, feature updates)
- Handles systems configured with WSUS (if correctly set up)
- Logs results to a temporary file for auditing purposes.

### **Linux Script**
- Verifies if the system is up to date by checking for available package updates.
- Supports major package managers
- Logs results to a temporary file for auditing purposes.
- Provides information on outdated packages, including names and versions.

### Important information
* Both scripts assume the user has root or administrative privileges. Running them as a standard user may lead to incomplete results or errors.
* Neither script differentiates between a system needing an "update" (applying updates to installed packages) and a full "upgrade" (moving to a new OS version).
* On Windows : Systems using a local WSUS or other custom update servers may not provide accurate "up-to-date" information.
---
