# thermonuclear-radiator
Agile radiator for siterex squad

##Initial Setup

[Install vagrant](http://www.vagrantup.com/downloads.html)<br />
[Install virtualbox](https://www.virtualbox.org/wiki/Downloads)<br />

Install vagrant plugins
```
vagrant plugin install vagrant-vbguest
vagrant plugin install vagrant-librarian-chef-nochef
```

Install ansible
```
brew install ansible
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

`cd thermonuclear-radiator`<br />
`vagrant up` - brings up the VM<br />
`vagrant halt` - takes down the VM<br />
`vagrant global-status` - shows the created VMs<br />
`vagrant destroy <number>` - destroys a created VM<br />
`ssh tst01.mybuys.loc` - get into the VM<br />

##Building the Dashboard
```
cd /vagrant/radiator/
bundle
dashing start
http://tst01.mybuys.loc:3030/
```



