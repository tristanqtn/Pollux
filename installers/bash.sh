#!/bin/bash

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
    echo "Poetry is not installed. Installing Poetry..."
    # Add your Poetry installation logic here
    curl -sSL https://install.python-poetry.org | python3 -
else
    echo "Poetry is already installed."
fi