# Create new user and add to sudoers
adduser --disabled-password --gecos "" "$USERNAME"
adduser "$USERNAME" sudo

# Create an install directory for new user
if [ ! -d "/home/$USERNAME/install" ]; then
  mkdir -p "/home/$USERNAME/install"
  cd "/home/$USERNAME/install"
fi

# Disable sudo password for new user
sudoers=$(cat /etc/sudoers)
if [[ $sudoers != "*$USERNAME*" ]]; then
  cp /etc/sudoers "/home/$USERNAME/install/sudoers"
  echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" >> "/home/$USERNAME/install/sudoers"
  cp "/home/$USERNAME/install/sudoers" /etc/sudoers
  rm "/home/$USERNAME/install/sudoers"
fi

# Add host user's SSH key to authorized SSH keys
if [ ! -d "/home/$USERNAME/.ssh" ]; then
  mkdir -p "/home/$USERNAME/.ssh"
  cat /host_ssh/id_rsa.pub > "/home/$USERNAME/.ssh/authorized_keys"
  chmod 700 "/home/$USERNAME/.ssh"
  chmod 600 "/home/$USERNAME/.ssh/authorized_keys"
  chown "$USERNAME:$USERNAME" -R "/home/$USERNAME/.ssh"
fi

# Change ownership of new files to new user
if [ ! -e "/home/$USERNAME/install/user_files_installed" ]; then
  chown "$USERNAME:$USERNAME" -R "/home/$USERNAME"
  su - "$USERNAME" -c "touch /home/$USERNAME/install/user_files_installed"
fi

# Check for Vagrant and install dot files for `vagrant` user
if [ -d "/home/vagrant" ]; then
  if [ ! -d "/home/vagrant/bash" ]; then
    # Copy dot files for new user
    cp -r /vagrant/bash/ /home/vagrant/bash
    mv /home/vagrant/bash/.profile /home/vagrant/.profile

    # Change ownership of new files to new user
    chown vagrant:vagrant /home/vagrant/.profile
    chown vagrant:vagrant -R /home/vagrant
  fi
fi
