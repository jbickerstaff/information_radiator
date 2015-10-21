# thermonuclear-radiator
Agile radiator for siterex squad

##Initial Setup

Install vagrant and virtualbox
[Install vagrant](http://www.vagrantup.com/downloads.html)
[Install virtualbox](https://www.virtualbox.org/wiki/Downloads)

Install vagrant plugins
```
vagrant plugin install vagrant-vbguest
vagrant plugin install vagrant-librarian-chef-nochef
```

Add to ~/.ssh/config
```
# For vagrant virtual machines
Host 192.168.33.* *.inside.dev *.mybuys.loc
StrictHostKeyChecking no
UserKnownHostsFile=/dev/null
User root
LogLevel ERROR
```

run `vagrant plugin install vagrant-hostsupdater`

##Starting, Stoping, Destroying and Getting into the VM

`cd thermonuclear-radiator`

`vagrant up` - brings up the VM

`vagrant halt` - takes down the VM

`vagrant global-status` - shows the created VMs

`vagrant destroy <number>` - destroys a created VM

`ssh tst01.mybuys.loc` - get into the VM

##Building the Dashboard
```
cd /vagrant/radiator/
bundle
dashing start
http://tst01.mybuys.loc:3030/
```



