# -*- mode: ruby -*-
# vi: set ft=ruby :
# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  require_relative './vagrant/key_authorization'
  authorize_key_for_root config, '~/.ssh/id_dsa.pub', '~/.ssh/id_rsa.pub'

  # tst01
  config.vm.define "tst01" do |tst01|
    tst01.vm.box = "ubuntu/trusty64"
    tst01.vm.network 'private_network', ip: '192.168.33.10'
    tst01.vm.network 'forwarded_port', guest: 3030, host: 3030
    tst01.vm.hostname = "tst01.mybuys.loc"
    tst01.vm.provision :ansible do |ansible|
      ansible.playbook = "playbook.yml"
    end
  end
end
