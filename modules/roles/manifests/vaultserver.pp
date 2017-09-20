# Configures a vaultserver
class roles::vaultserver inherits roles::base {

  include ::profiles::vault

}
