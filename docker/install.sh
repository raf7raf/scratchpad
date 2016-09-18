#!/bin/bash
# Docker installation script for CentOS 7.2
# Stolen from https://docs.docker.com/engine/installation/linux/centos/

function destroy {
        sudo yum -y remove docker-engine
        rm -f /etc/yum.repos.d/docker.repo
	exit 1
}

# Kernal must be version 3.10 or higher
if [ `uname -r | cut -d\- -f1 | tr -d '.'` -lt 3100 ]; then
	echo "Kernal version must be 3.10 or higher"
	exit 1
fi

# Must be running on a 64-bit architecture
if [ `/usr/bin/uname -r | cut -d\_ -f2` -ne 64 ]; then
        echo "Must be running a 64 bit architecture"
        exit 1
fi

# Make sure we have latest packages
sudo yum -y update

# Install the Docker repo
sudo tee /etc/yum.repos.d/docker.repo <<-'EOF'
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/7/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF

# Install Docker engine
sudo yum install -y docker-engine

# Start the service
sudo service docker start

# Check if service started correctly, if not remove
if [ '$?' -ne '0' ]
	echo "Failed to start the Docker engine"
	destroy
fi

# Run Hello World Docker image to verify installation
sudo docker run hello-world | grep "Hello from Docker"

# Check if image successfully ran
if [ '$' -eq '0' ]
	echo "Docker successfully installed"
else
	echo "Docker failed to install sucessfully"
	destroy
fi
