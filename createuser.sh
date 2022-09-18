#!/bin/bash

# Create a user with ssh access for remote login.
# Author: Balli Asghar

# Check if the user is root
if [ $(id -u) -ne 0 ]; then
    echo "You must be root to run this script."
    exit 1
fi

echo "Enter User Information"

# ask for username
read -p "🙍 username: " username

# check if username is empty
if [ -z "$username" ]; then
    echo "Username cannot be empty."
    exit 1
fi

# check if user already exists
if id "$username" >/dev/null 2>&1; then
    echo "User already exists."
    exit 1
fi

# ask for password
password=`systemd-ask-password "Enter password:"`

# check if password is empty
if [ -z "$password" ]; then
    echo "Password cannot be empty."
    exit 1
fi

# Ask for public key
read -p "🔑 Enter public key (from you local machine): " publickey

# check if public key is empty
if [ -z "$publickey" ]; then
    echo "Public key cannot be empty."
    exit 1
fi

# validate public key
if ! echo "$publickey" | grep -q "ssh-rsa"; then
    echo "Invalid public key"
    exit 1
fi

# create user
useradd -m -s /bin/bash $username

# # set password
echo "$username:$password" | chpasswd

# # add user to sudo group
usermod -aG sudo $username

# # create .ssh directory
mkdir /home/$username/.ssh

# # change ownership of .ssh directory
chown $username:$username /home/$username/.ssh

# # add public key to authorized_keys
echo $publickey >> /home/$username/.ssh/authorized_keys

# # change ownership of authorized_keys
chown $username:$username /home/$username/.ssh/authorized_keys

echo -e "\e[32mUser created successfully.\e[0m"

# ip address of the server
ipaddress=`hostname -I | awk '{print $1}'`

echo -e "\e[33mLogin with: ssh $username@$ipaddress\e[0m"
