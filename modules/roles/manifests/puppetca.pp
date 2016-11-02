# this sets up a puppetca
class roles::puppetca inherits roles::base {

  include ::profiles::r10k

  file { '/etc/puppetlabs/puppet/hiera.yaml':
    ensure  => present,
    content => template('roles/puppetserver/hiera.yaml.erb'),
    mode    => '0644',
    owner   => 'puppet',
    group   => 'puppet',
    notify  => Class['puppet']
  }

  include ::profiles::puppet

  include ::profiles::consul::agent

}
