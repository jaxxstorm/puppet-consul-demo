# This is a base role
# All hosts get this configured
class roles::base {

  # Epel needs to be installed before everything
  # Assign to setup stage
  class { '::epel':
    stage => 'setup'
  }

  # Need all std package before we do everything else
  class { '::profiles::stdpackage':
    stage => 'pre'
  }

}
