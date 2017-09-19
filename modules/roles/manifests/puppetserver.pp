# this sets up a puppetserver
class roles::puppetserver inherits roles::base {


  include ::profiles::r10k

  file { '/etc/puppetlabs/puppet/hiera.yaml':
    ensure  => present,
    content => template('roles/puppetserver/hiera.yaml.erb'),
    mode    => '0644',
    owner   => 'puppet',
    group   => 'puppet',
    notify  => Class['puppet']
  }

  # set up a puppetserver
  include ::profiles::puppet

  # creates the service
  ::consul::service { 'puppetserver':
    ensure => present,
    port  => '8140',
    tags  => ['puppet'],
  }

  # checks the health of the service
  ::consul::check { 'puppetserver_healthcheck':
    ensure     => present,
    interval   => '60',
    script     => "/usr/lib64/nagios/plugins/check_http -H ${::fqdn} -p 8140 -u /status/v1/services?level=info -S -k 'Accept: pson'",
    notes      => 'Checks the puppetservers\'s status API to determine if the service is healthy',
    service_id => 'puppetserver',
  }

  include ::profiles::consul::agent

}
