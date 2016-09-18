#!/bin/bash
# Docker installation script for CentOS 7.2
# Stolen from https://docs.docker.com/engine/installation/linux/centos/

function destroy {
	echo -e "\nDocker failed to install sucessfully\n"
	sudo systemctl stop docker > /dev/null 2>&1
        sudo yum -y remove docker-engine > /dev/null 2>&1
        sudo rm -f /etc/yum.repos.d/docker.repo > /dev/null 2>&1
	exit 1
}

# Kernal must be version 3.10 or higher
if [ `uname -r | cut -d\- -f1 | tr -d '.'` -lt 3100 ]; then
	echo "\nKernal version must be 3.10 or higher\n"
	exit 1
fi

# Must be running on a 64-bit architecture
if [ `uname -r | cut -d\_ -f2` -ne 64 ]; then
        echo "\nMust be running a 64 bit architecture\n"
        exit 1
fi

# Make sure we have latest packages
sudo yum -y update > /dev/null 2>&1

# Install the Docker repo
{
sudo tee /etc/yum.repos.d/docker.repo <<-'EOF'
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/7/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF
} > /dev/null 2>&1

# Install Docker engine
sudo yum install -y docker-engine > /dev/null 2>&1

# Start the service
sudo systemctl start docker > /dev/null 2>&1

# Check if service started correctly, if not remove
if [ $? -ne 0 ]; then
	destroy
fi

# Run Hello World Docker image to verify installation
sudo docker run hello-world | grep "Hello from Docker" > /dev/null 2>&1

# Check if image successfully ran
if [ $? -eq 0 ]; then
	echo -e "\nDocker successfully installed\n"
	exit 0
else
	destroy
fi
