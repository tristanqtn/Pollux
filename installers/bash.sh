#!/bin/bash

echo "== Pollux Installer for Linux =="
echo "This script will install the dependencies required to run Pollux."
pwd=$(pwd)
echo "Currently running from the directory: $pwd"

echo "=================================="
echo ""

echo "=================================="
echo "Installing dependencies..."

# Check for Python3
if ! command -v python3 &> /dev/null
then
    echo "Python3 is not installed. Installing Python3..."
    # Add your Python3 installation logic here
    # Example for Ubuntu:
    sudo apt update
    sudo apt install -y python3
else
    echo "Python3 is already installed."
fi

# Check for Poetry
if ! command -v poetry &> /dev/null
then
    echo "Poetry is not installed or not in PATH. Installing Poetry locally..."
    # Add your Poetry installation logic here
    curl -sSL https://install.python-poetry.org | python3 -
    # Add Poetry to PATH
    export PATH=$PATH:$HOME/.local/bin
else
    echo "Poetry is already installed."
fi

echo "=================================="
echo ""

echo "=================================="
echo "Installing Pollux Python virtual env and dependencies..."
poetry install
echo "=================================="
echo ""

echo "=================================="
echo "Pollux dependencies installed successfully."
echo ""
echo "To run Pollux, activate the virtual environment by running the following command:"
echo "    poetry shell"
echo ""
echo "Then run Pollux by executing the following command:"
echo "    poetry run python -m pollux.main"
echo ""
echo "Don't forget that Pollux requires the configuration file to run."
echo "=================================="
echo ""
