# This is a base role
# All hosts get this configured
class roles::base {

  # Epel needs to be installed before everything
  # Assign to setup stage
  class { '::epel':
    stage => 'setup'
  }

  # Need all std package before we do everything else
  class { '::profiles::stdpackages':
    stage => 'pre'
  }

  include ::resolv_conf

  include ::unbound

  $consul_service_array = hiera('consul',[])
	$consul_cluster_nodes = consul_info($consul_service_array, 'Address')

  unbound::forward { 'service.consul':
    address => suffix($consul_cluster_nodes, '@8600')
  }

}
