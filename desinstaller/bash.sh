#!/bin/bash

echo "== Pollux Installer for Linux =="
echo "This script will install the dependencies required to run Pollux."
pwd=$(pwd)
echo "Currently running from the directory: $pwd"

echo "=================================="
echo ""

echo "=================================="
echo "Removing Pollux files..."
rm -rf /tmp/pollux
echo ""
echo "To delete this repository, run the following command:"
echo "rm -rf $pwd"
echo "=================================="

echo "Pollux has been uninstalled."
echo "Thank you for using Pollux!"


