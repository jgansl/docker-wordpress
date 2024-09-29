# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Use Ubuntu 22.04 as the base box
  config.vm.box = "ubuntu/jammy64"

  # Set up hostname and VM network configuration
  config.vm.hostname = "wordpress-laravel-vm"
  config.vm.network "private_network", type: "dhcp"

  # Forward ports (Nginx will listen on port 80 inside the Docker container)
  config.vm.network "forwarded_port", guest: 80, host: 8080

  # Provision the VM to install Docker and Docker Compose
  config.vm.provision "shell", inline: <<-SHELL
    # Update package manager and install required tools
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

    # Add Docker GPG key and repository
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

    # Install Docker and Docker Compose
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-compose

    # Enable Docker to run without sudo
    sudo usermod -aG docker vagrant

    # Install Composer (Optional: if you want to run composer commands)
    curl -sS https://getcomposer.org/installer | php
    sudo mv composer.phar /usr/local/bin/composer
  SHELL

  # Sync folders between the host and guest VM
  config.vm.synced_folder ".", "/vagrant", type: "nfs"

  # Automatically start Docker Compose (if you have a docker-compose.yml in your project)
  config.vm.provision "shell", inline: <<-SHELL
    cd /vagrant
    docker-compose up -d
  SHELL
end
