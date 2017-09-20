# Configures a vaultserver
class roles::vaultserver inherits roles::base {

  include ::profiles::consul::agent
  include ::profiles::vault

}
