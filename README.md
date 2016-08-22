# OctoberCMS - HHVM - NginX Vagrant Setup

## Requirements

- **[VirtualBox](https://www.virtualbox.org)**: Runs guest operating systems
- **[Vagrant](https://www.vagrantup.com)**: Creates and configures the guest OS environment

## Installation

To set up your local development environment run:

```bash
# Clone this repo and enter the directory
git clone git@github.com:jarydkrish/vagrant-nginx-hhvm-october.git
# Move into the new folder
cd ~/vagrant-nginx-hhvm-october
# Pull down the master branch (in case something went horribly, horribly wrong)
git pull
# Config git to ignore file mode changes caused by Vagrant
git config core.fileMode false
# Install vbguest addition to keep GuestAdditions up-todate
vagrant plugin install vagrant-vbguest
# Create and provision the local VM
vagrant up
```

Add october.dev entries to `/etc/hosts`:

```
55.55.55.20 october.dev www.october.dev
```

## Default configuration
The admin url is as follows: `http://www.october.dev/backend`
- Username: `admin`
- Password: `admin`

## Install Directory

It's not necessary, but you can configure the VagrantFile to install OctoberCMS on your machine to match a
local folder, found at `~/vagrant-nginx-hhvm-october/apps/october`. This folder matches `/var/www/october`
on your development machine.

## User: october

The `october` user is created as a sudoer without a password, and your local
public SSH key is added as an authorized key for the `october` user.
