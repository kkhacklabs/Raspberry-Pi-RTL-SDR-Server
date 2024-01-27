# Raspberry Pi RTL-SDR Server Setup Script

This repository contains a script to easily set up an RTL-SDR server on a Raspberry Pi.

## Overview
The `setup_rtl_sdr.sh` script automates the process of setting up a Raspberry Pi as an RTL-SDR server. It updates the system, installs necessary libraries, blacklists conflicting drivers, and sets up a service to run the RTL-SDR server on boot. The script also allows you to specify a custom port for the server.

## Prerequisites
- Raspberry Pi with Raspberry Pi OS installed
- Internet connection
- RTL-SDR USB dongle

## Installation

1. Clone this repository or download the `setup_rtl_sdr.sh` script directly to your Raspberry Pi.
2. Make the script executable:

   ```bash
   chmod +x setup_rtl_sdr.sh

## Run

Run the script with sudo. You will be prompted to enter a custom port number. If you don't specify one, the default port 1234 will be used:
  '''bash
  sudo ./setup_rtl_sdr.sh

The script will handle the rest. After completion, your Raspberry Pi will be running an RTL-SDR server accessible over your network.

## Script Content
Below is the content of setup_rtl_sdr.sh:

#!/bin/bash

# RTL-SDR Server Setup Script for Raspberry Pi

# Default port for RTL-SDR server
DEFAULT_PORT=1234

# Ask for a custom port
read -p "Enter the port number for the RTL-SDR server (default is $DEFAULT_PORT): " PORT
PORT=${PORT:-$DEFAULT_PORT} # If no port is provided, use the default

# Update and Upgrade the System
echo "Updating and upgrading Raspberry Pi OS..."
sudo apt update && sudo apt upgrade -y

# Install RTL-SDR Library
echo "Installing RTL-SDR library..."
sudo apt-get install rtl-sdr -y

# Blacklist the DVB-T Drivers
echo "Blacklisting DVB-T drivers..."
echo "blacklist dvb_usb_rtl28xxu" | sudo tee /etc/modprobe.d/blacklist.conf

# Creating RTL-SDR Server Service
echo "Setting up RTL-SDR server service..."
SERVICE_FILE=/etc/systemd/system/rtl_tcp.service
sudo touch $SERVICE_FILE

echo "[Unit]
Description=RTL-SDR Server
After=network.target

[Service]
ExecStart=/usr/bin/rtl_tcp -a 0.0.0.0 -p $PORT

[Install]
WantedBy=multi-user.target" | sudo tee $SERVICE_FILE

# Enabling and Starting the Service
echo "Enabling and starting RTL-SDR server service..."
sudo systemctl enable rtl_tcp.service
sudo systemctl start rtl_tcp.service

echo "RTL-SDR server setup is complete. Server is running on port $PORT."
Usage
Connect to the RTL-SDR server using any SDR client software by specifying your Raspberry Pi's IP address and the port you set (default is 1234).

License
This project is licensed under the MIT License - see the LICENSE file for details.
