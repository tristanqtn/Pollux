# **Running Services Checker Script README**

This directory contains scripts for verifying running scripts permissions and descriptions. There are scripts for both Linux and Windows.

---

## **Scripts Overview**

### **1. Windows Script**

- **`serviceCheck.ps1`:** A PowerShell script designed for systems running Windows.

### **2. Linux Script**

- **`serviceCheck.sh`:** A Bash script for checking Linux running services.

---

## **Features**

### **Windows Script**

- Scans for running services.
- Prints each service description.
- Separates services running with administrator's permissions.

### **Linux Script**

- Scans for running services.
- Prints each service description.
- Separates services running with root's permissions.

### Important Information

- Both scripts assume the user has root or administrative privileges. Running them as a standard user may lead to incomplete results or errors.

---
