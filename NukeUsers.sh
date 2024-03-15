#!/bin/bash

# Check if script is running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script as root."
    exit 1
fi

# Create a list of directories users are allowed to access
allowed_directories=("/home" "/var" "/tmp")

# Create a list of basic commands users are allowed to execute
allowed_commands=("ls" "cd")

# Revoke sudo access for all non-root users
echo "Revoking sudo access for all non-root users..."
for user in $(getent passwd | grep -vE '^root:|:0:' | cut -d: -f1); do
    usermod -G sudo -R $user
done

# Limit user permissions
echo "Limiting user permissions..."
for user in $(getent passwd | grep -vE '^root:|:0:' | cut -d: -f1); do
    # Restricting user's shell to /bin/rbash
    usermod --shell /bin/rbash $user

    # Granting access to allowed directories
    chown $user:$user ${allowed_directories[@]}

    # Creating symbolic links to allowed commands in user's home directory
    mkdir -p /home/$user/bin
    for cmd in "${allowed_commands[@]}"; do
        ln -s $(which $cmd) /home/$user/bin/$cmd
    done

    # Adding the user's bin directory to the PATH
    echo 'export PATH="$HOME/bin:$PATH"' >> /home/$user/.bashrc
done

echo "User permissions limited successfully."
