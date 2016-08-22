VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.define "octobercms" do |web|
    web.vm.box = "bento/ubuntu-16.04"
    # Change the values for the web machine based on your available resources
    web.vm.provider "virtualbox" do |vm|
      vm.name = "octobercms"
      vm.memory = 1024
      vm.cpus = 2
    end
    web.vm.hostname = "october"
    web.vm.network :private_network, ip: "55.55.55.20"

    # Provision the web instance
    web.vm.provision :shell, path: "provision.sh"

    # Share ~/.ssh/ so we can get the host machine user's public SSH key
    # and add it to /home/october/.ssh/authorized_keys on the guest VM
    web.vm.synced_folder "~/.ssh/", "/host_ssh"

    # Share the apps folder so we can work on the apps locally.
    # Uncomment the following line to sync these folders:
    # web.vm.synced_folder "apps/october", "/var/www/october", mount_options: ["dmode=777", "fmode=777"]
  end

end
