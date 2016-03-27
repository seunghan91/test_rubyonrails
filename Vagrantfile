Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network "forwarded_port", guest: 3000, host: 3000
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.provider "virtualbox" do | vb |
    vb.name = "RORLAB DEV Vagrant"
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
  config.vm.provision :shell, privileged: false, path: 'https://gist.githubusercontent.com/rorlab/9e52461a78592d00e6ca/raw/37c3983559bbb1dacd0353a1f3aea549d1811e1c/setup.sh'
end
