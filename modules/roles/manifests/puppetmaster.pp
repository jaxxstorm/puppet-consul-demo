# this sets up a puppetmaster
class roles::puppetmaster inherits roles::base {

  # set up a puppetmaster
  class { '::puppet':
  	server                    => true,
  	server_foreman            => false,
  	server_reports            => 'store',
  	server_external_nodes     => '',
  	server_environments       => [],
    server_jvm_min_heap_size  => '512m',
    server_jvm_max_heap_size  => '512m'
	}

}