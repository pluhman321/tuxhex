#!/bin/bash

# Exit if any command fails
set -e

# Check for GitHub repo URL input
if [ -z "$1" ]; then
    echo "Usage: ./deploy.sh <github-repo-url>"
    echo "Example: ./deploy.sh https://github.com/yourusername/tuxhex.git"
    exit 1
fi

REPO_URL="$1"
FOLDER_NAME="TuxHex"

# Unzip the project if it's in the same directory
if [ -f TuxHex.zip ]; then
    unzip TuxHex.zip -d .
fi

cd "$FOLDER_NAME"

# Initialize git and push to your repo
git init
git add .
git commit -m "Initial commit of TuxHex"
git branch -M main
git remote add origin "$REPO_URL"
git push -u origin main

echo "✅ TuxHex deployed to $REPO_URL"
