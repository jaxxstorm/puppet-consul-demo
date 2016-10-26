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
  class { '::puppet':
  	server                      => true,
  	server_foreman              => false,
  	server_reports              => 'store',
  	server_external_nodes       => '',
  	server_environments         => [],
    server_common_modules_path  => [],
    server_jvm_min_heap_size    => '512m',
    server_jvm_max_heap_size    => '512m',
    server_ca                   => false,
    ca_server                   => "puppetserver-0.${::fqdn}"
	}

  # creates the service
  ::consul::service { 'puppetserver':
  	ensure => present,
    port   => '8140',
    tags   => ['puppet'],
  }

  # checks the health of the service
  ::consul::check { 'puppetserver_healthcheck':
    ensure     => present,
    interval   => '60',
    script     => "/usr/lib64/nagios/plugins/check_http -H ${::fqdn} -p 8140 -u /production/status/test?environment=production -S -k 'Accept: pson' -s '\"is_alive\":true'",
    notes      => 'Checks the puppetservers\'s status API to determine if the service is healthy',
    service_id => 'puppetserver',
  } 

  include ::profiles::consul::agent

}
