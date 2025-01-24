# **File System Checker Script README**

This directory contains scripts for verifying file system permissions and sensitive locations or content. There are scripts for both Linux and Windows.

---

## **Scripts Overview**

### **1. Windows Script**

- **`filesystemCheck.ps1`:** A PowerShell script designed for systems running Windows.

### **2. Linux Script**

- **`filesystemCheck.sh`:** A Bash script for checking Linux environment variables.

---

## **Features**

### **Windows Script**

- Scans for sensitive files and directories.
- Checks for backup files.
- Detects suspiscious permissions.

### **Linux Script**

- Audits files with root permissions.
- Audits files with sensitive content.

### Important Information

- Both scripts assume the user has root or administrative privileges. Running them as a standard user may lead to incomplete results or errors.

---
