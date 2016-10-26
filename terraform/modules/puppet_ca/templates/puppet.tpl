#cloud-config
yum_repos:
  puppet:
    baseurl: https://yum.puppetlabs.com/el/7/PC1/x86_64/
    enabled: 1
    gpgcheck: 0
    name: PuppetLabs

packages:
  - puppetserver
  - ruby
  - ruby-devel
  - git
  - vim
  - bind-utils
 
runcmd:
  - gem install r10k
  - sed -i 's/2g/512m/g' /etc/sysconfig/puppetserver
  - sed -i '/\[master\]/a dns_alt_names=puppetmaster-0.${domain},puppetmaster.service.consul' /etc/puppetlabs/puppet/puppet.conf
  - sed -i '/\[master\]/a ca=true' /etc/puppetlabs/puppet/puppet.conf
  - sed -i '/\[master\]/a autosign=true' /etc/puppetlabs/puppet/puppet.conf
  - systemctl start puppetserver.service
  - systemctl enable puppetserver.service
  - mkdir -p /etc/facter/facts.d
  - r10k deploy environment -p --verbose -c /etc/puppetlabs/r10k.yaml
  - echo -e "nameserver 173.245.58.51\nnameserver 8.8.8.8" > /etc/resolv.conf
  - while true; do /opt/puppetlabs/puppet/bin/puppet agent -t --environment=develop --server=puppetmaster-0.${domain} ; done


write_files:
  - path: /etc/puppetlabs/r10k.yaml
    content: |
      # The location to use for storing cached Git repos
      :cachedir: '/opt/puppetlabs/r10k/cache'

      # A list of git repositories to create
      :sources:
        # This will clone the git repository and instantiate an environment per
        # branch in /etc/puppetlabs/code/environments
        :github:
          remote: 'https://github.com/jaxxstorm/puppet-consul-demo.git'
          basedir: '/etc/puppetlabs/code/environments'
  - path: /etc/puppetlabs/puppet/autosign.conf
    content: |
      *.${domain}
      puppetmaster.service.consul
  - path: /etc/facter/facts.d/role.txt
    content: |
      role=puppetca

output:
  all: ">> /var/log/cloud-init.log"
