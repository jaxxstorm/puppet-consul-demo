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

  # Everything needs puppet configured!
  include ::puppet

  # We need to make sure our local resolv.conf can also see consul
  # See hiera for the settings, notice localhost is first
  include ::resolv_conf

  # Unbound allows us to have a local resolver which will forward queries to Consul
  include ::unbound

  # This grabs the current consul nodes using the consul backend:
  # https://github.com/lynxman/hiera-consul
  $consul_service_array = hiera('consul',[])

  # We than add the addresses of each consul server to a new array
  $consul_cluster_nodes = consul_info($consul_service_array, 'Address')

  unbound::stub { $::domain :
    address  => '173.245.58.51',
    insecure => true,
  }

  unbound::forward { 'service.consul':
    # We use suffix from stdlib to add the consul DNS port: https://github.com/puppetlabs/puppetlabs-stdlib#suffix
    address => suffix($consul_cluster_nodes, '@8600')
  }

  unbound::forward { '.':
    address => [ '8.8.8.8', '8.8.4.4' ]
  }

  include ::mysql::client

}
