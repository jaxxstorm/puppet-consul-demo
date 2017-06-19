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

	# creates the service
  ::consul::service { 'puppetserver':
    ensure => present,
    port  => '8140',
    tags  => ['puppet', 'ca'],
  }

  # checks the health of the service
  ::consul::check { 'puppetserver_healthcheck':
    ensure     => present,
    interval   => '60',
    script     => "/usr/lib64/nagios/plugins/check_http -H ${::fqdn} -p 8140 -u /production/status/test?environment=production -S -k 'Accept: pson' -s '\"is_alive\":true'",
    notes      => 'Checks the puppetservers\'s status API to determine if the service is healthy',
    service_id => 'puppetserver',
  }

}
