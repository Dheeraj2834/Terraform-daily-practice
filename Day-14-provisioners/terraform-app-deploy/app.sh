#!/bin/bash
echo "Installing application"
sudo yum update -y
sudo yum install git -y
sudo yum install python3 -y
echo "Cloning application"
cd /opt
sudo git clone https://github.com/example/sample-app.git
echo "Starting application"
cd sample-app
sudo python3 app.py