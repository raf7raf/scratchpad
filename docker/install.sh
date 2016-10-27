#!/bin/bash
# Docker installation script for CentOS 7.2 - requires user with sudo
# Stolen from https://docs.docker.com/engine/installation/linux/centos/

echo -e "\n-----------------"
echo -e "Installing Docker"
echo -e "-----------------\n"

function destroy {
	echo -e "\nDocker failed to install sucessfully\n"
	sudo systemctl stop docker > /dev/null 2>&1
        sudo yum -y remove docker-engine > /dev/null 2>&1
        sudo rm -f /etc/yum.repos.d/docker.repo > /dev/null 2>&1
	sudo rm -f /usr/local/bin/docker-compose > /dev/null 2>&1
	sudo rm -f /usr/local/bin/docker-machine > /dev/null 2>&1
	
	exit 1
}

echo "Checking Kernal and OS version is compatible"

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
echo "Updating system packages"
sudo yum -y update > /dev/null 2>&1

# Install the Docker repo
echo "Adding the Docker repository"
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
echo "Installing and starting Docker Engine"
sudo yum install -y docker-engine > /dev/null 2>&1

# Start the service
sudo systemctl start docker > /dev/null 2>&1

# Check if service started correctly, if not remove
if [ $? -ne 0 ]; then
	destroy
fi

# Run Hello World Docker image to verify installation
echo "Verifying if installation successful"
sudo docker run hello-world | grep "Hello from Docker" > /dev/null 2>&1

# Check if image successfully ran
if [ $? -eq 0 ]; then
	echo -e "Docker successfully installed!"
else
	destroy
fi

# Create docker group so application can be executed without sudo
echo "Creating docker group..."
sudo groupadd docker > /dev/null 2>&1

# Add current user to docker group
if [ $? -eq 0 ]; then
	echo "Adding $USERNAME to docker group"
	sudo usermod -aG docker $USERNAME
	echo -e "\nPlease log out and in again to run Docker without sudo\n"
fi

# Install docker-compose
curl -L https://github.com/docker/compose/releases/download/1.9.0-rc1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose

# Check compose installed correctly
if [[ $(docker-compose --version | grep "docker-compose") ]]; then
	echo -e "docker-compose successfully installed!"
else
	destroy
fi

# Install docker-machine
sudo curl -L https://github.com/docker/machine/releases/download/v0.8.2/docker-machine-`uname -s`-`uname -m` >/usr/local/bin/docker-machine && \ chmod +x /usr/local/bin/docker-machine
if [[ $(docker-machine --version | grep "docker-machine") ]]; then
	echo -e "docker-machine successfully installed!"
else
	destroy
fi

echo -e "\n---------------------------"
echo -e "Docker installion complete!"
echo -e "---------------------------\n"

exit 0
