#!/bin/bash
# Installs system and Python dependencies for the HRI interface

echo "Updating apt repositories..."
sudo apt-get update

echo "Installing system dependencies..."
sudo apt-get install -y python3-pip python3-opencv espeak v4l-utils

echo "Installing Python requirements..."
pip3 install -r requirements.txt

echo "Dependencies installed successfully."
