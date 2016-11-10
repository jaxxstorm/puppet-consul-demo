# puppet-consul-demo

## Security Notice

The terraform config will, by default, provision Digital Ocean droplets which are exposed externally, and it will also make the [consul web ui](https://www.consul.io/intro/getting-started/ui.html) accessible on port 8500. This is a major security consideration - do not run the terraform config unless you're absolutely sure what you're doing.

I will accept no liability if your Digital Ocean droplets get hacked. *You have been warned*

## About

This module contains some boilerplate puppet code, as well as some terraform config for spinning up a consul cluster, and scaling your puppetservers horizontally using consul. It will:

 - Launch some Digital Ocean droplets using terraform (instructions [here](https://github.com/jaxxstorm/puppet-consul-demo/blob/production/terraform/README.md))
 - Configure an initial CA puppetserver and download this repo using [r10k](https://github.com/puppetlabs/r10k) to the `$codedir`
 - Install & configure a consul cluster with 3 servers
 - Configure [Unbound](https://www.unbound.net/) to forward DNS queries for the domain consul is authoritative for to the consul cluster
 - Configure the puppetmaster to lookup service information from the consul catalog using [hiera-consul](https://github.com/lynxman/hiera-consul)
 - Configure `resolv.conf` to use the local unbound resolve for all queries
 
Essentially, this should be everything you need to bootstrap consul along with Puppet.

*This is a very opinionated repo, but pull requests/improvements are still welcome*

### r10k

If you're not familiar with r10k, I suggest reading the [quickstart guide](https://github.com/puppetlabs/r10k/blob/master/doc/dynamic-environments/quickstart.mkd) before going forward. Essentially, r10k will download all the modules in the Puppetfile into the empty `vendor` directory, which is then set as a `$modulepath` for the puppetmasters. There is a cronjob which runs every 5 minutes to do this.

### Unbound

Unbound is configured to forward queries for the default `service.consul` domain to the consul servers. The way those consul servers are populated in `unbound.conf` is by hiera. The [hiera-consul](https://github.com/lynxman/hiera-consul) looks up the provisioned consul servers and populates the the ip addresses from the consul catalogue. This seemed like a good way of showing off the consul key/value store, but it can be a little flaky.

## Modules Used

This repo makes use of several third party modules. They can be found in the `Puppetfile` but they are also listed here for acknowledgement:

 - [stdlib](https://github.com/puppetlabs/puppetlabs-stdlib)
 - [theforeman-puppet](https://github.com/theforeman/puppet-puppet.git)
 - [puppetlabs-concat](https://github.com/puppetlabs/puppetlabs-concat.git)
 - [solarkennedey-consul](https://github.com/solarkennedy/puppet-consul.git)
 - [voxpupuli-archive](https://github.com/solarkennedy/puppet-consul.git)
 - [jethrocarr-digitalocean](https://github.com/jethrocarr/puppet-digitalocean.git)
 - [stahnma-epel](https://github.com/stahnma/puppet-module-epel.git)
 - [saz-resolv_conf](https://github.com/saz/puppet-resolv_conf.git)
 - [xaque208-unbound](https://github.com/xaque208/puppet-unbound.git)
 - [lynxman-hiera-consul](https://github.com/lynxman/hiera-consul.git)

## Resources

Some other consul resources which may help you:

 - [Stripe blog post](https://stripe.com/blog/service-discovery-at-stripe) about how they're using Consul
 - [Another blog post](https://sreeninet.wordpress.com/2016/04/17/service-discovery-with-consul/) with lots of Consul description
 - [Consul + MySQL](https://www.percona.com/blog/2016/10/10/consul-architecture/) from Percona
