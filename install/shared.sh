echo "## Apt Get Update"
apt-get update

echo "## Installing Dev Tools"
apt-get -y install autoconf bison build-essential git htop libssl-dev

# Run additional shared scripts
/vagrant/install/create_user.sh

# Enable 2GB Swap File
if [ ! -e /swapfile ]; then
  install -o root -g root -m 0600 /dev/null /swapfile
  dd if=/dev/zero of=/swapfile bs=1k count=2048k
  mkswap /swapfile
  swapon /swapfile
  echo '/swapfile       swap    swap    auto      0       0' | tee -a /etc/fstab
  sysctl -w vm.swappiness=10
  echo vm.swappiness = 10 | tee -a /etc/sysctl.conf
fi
