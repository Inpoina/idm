#!/bin/bash

# Function to check if a Python package is installed
check_package() {
    PACKAGE=$1
    if python -c "import $PACKAGE" &> /dev/null; then
        echo ""
    else
        echo "$PACKAGE is not installed. Installing..."
        pip install $PACKAGE
    fi
}

# Check if Python is installed
if command -v python3 &> /dev/null; then
    echo ""
else
    echo "Python is not installed. Installing..."
    pkg install python -y
fi

# Check and install requests
check_package requests

# Check and install beautifulsoup4
check_package bs4

python aktual.py
