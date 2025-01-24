# **FirewallChecker Script README**

This directory contains scripts for verifying firewall configurations, rules, trusted connections and networks. There are scripts for both Linux and Windows.

---

## **Scripts Overview**

### **1. Windows Script**

- **`firewallCheck.ps1`:** A PowerShell script designed for systems running Windows.

### **2. Linux Script**

- **`firewallCheck.sh`:** A Bash script for checking Linux environment variables.

---

## **Features**

### **Windows Script**

- Enumerates all firewall rules (Windows Firewall).
- Checks for trusted networks and connections.

### **Linux Script**

- Enumarates all firewall rules (nftables, iptables).

### Important Information

- Both scripts assume the user has root or administrative privileges. Running them as a standard user may lead to incomplete results or errors.

---
