# this sets up a puppetmaster
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

  # set up a puppetmaster
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
    ca_server                   => 'puppetmaster-0.briggs.lan'
	}

}
