# This is a base role
# All hosts get this configured
class roles::base {

  include ::epel
  include ::profiles::stdpackages

}
