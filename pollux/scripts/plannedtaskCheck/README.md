# **Planned Tasks Checker Script README**

This directory contains scripts for verifying scheduled tasks. There are scripts for both Linux and Windows.

---

## **Scripts Overview**

### **1. Windows Script**

- **`sessionCheck.ps1`:** A PowerShell script designed for systems running Windows.

### **2. Linux Script**

- **`sessionCheck.sh`:** A Bash script for checking Linux sessions.

---

## **Features**

- Enumerates all active planed tasks
- Searches for non system scheduled tasks.
- Audits admin and user scheduled tasks.

### Important Information

- Both scripts assume the user has root or administrative privileges. Running them as a standard user may lead to incomplete results or errors.

---
