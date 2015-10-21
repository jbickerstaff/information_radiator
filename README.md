# thermonuclear-radiator
Agile radiator for siterex squad

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
