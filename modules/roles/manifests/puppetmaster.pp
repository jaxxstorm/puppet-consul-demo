# this sets up a puppetmaster
class roles::puppetmaster inherits roles::base {

  # set up a puppetmaster
  class { '::puppet':
  	server                => true,
  	server_foreman        => false,
  	server_reports        => 'store',
  	server_external_nodes => '',
  	server_environments   => [],
	}

}
