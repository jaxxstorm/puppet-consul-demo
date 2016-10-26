#cloud-config
yum_repos:
  puppet:
    baseurl: https://yum.puppetlabs.com/el/7/PC1/x86_64/
    enabled: 1
    gpgcheck: 0
    name: PuppetLabs

packages:
  - puppet-agent
  - ruby
  - ruby-devel
  - git
  - vim
  - bind-utils
 
runcmd:
  - mkdir -p /etc/facter/facts.d
  - echo -e "nameserver 173.245.58.51\nnameserver 8.8.8.8" > /etc/resolv.conf
  - echo -e "[main]\ncertname = $(hostname).briggs.lan" >> /etc/puppetlabs/puppet/puppet.conf
  - until /opt/puppetlabs/puppet/bin/puppet agent -t --environment=develop --server=puppetmaster-0.${domain}; do echo "puppet failed, retry in 10 seconds"; sleep 10; done  

write_files:
  - path: /etc/facter/facts.d/role.txt
    content: |
      role=consulserver

output:
  all: ">> /var/log/cloud-init.log"
