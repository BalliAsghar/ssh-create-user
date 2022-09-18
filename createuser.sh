#!/bin/bash

# Create a user with ssh access for remote login.
# Author: Balli Asghar

# Check if the user is root
if [ $(id -u) -ne 0 ]; then
    echo "You must be root to run this script."
    exit 1
fi

echo "You are Root"

# ask for username
read -p "Enter username: " username

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
read -s -p "Enter password: " password

# check if password is empty
if [ -z "$password" ]; then
    echo "Password cannot be empty."
    exit 1
fi

# create user
useradd -m -s /bin/bash $username

# set password
echo "$username:$password" | chpasswd

# add user to sudo group
usermod -aG sudo $username

# create .ssh directory
mkdir /home/$username/.ssh

# change ownership of .ssh directory
chown $username:$username /home/$username/.ssh

# Ask for public key
read -p "Enter public key: " publickey

# check if public key is empty
if [ -z "$publickey" ]; then
    echo "Public key cannot be empty."
    exit 1
fi

# add public key to authorized_keys
echo $publickey >> /home/$username/.ssh/authorized_keys

# change ownership of authorized_keys
chown $username:$username /home/$username/.ssh/authorized_keys

echo "User created successfully."
