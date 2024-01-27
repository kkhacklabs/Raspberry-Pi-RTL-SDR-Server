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
