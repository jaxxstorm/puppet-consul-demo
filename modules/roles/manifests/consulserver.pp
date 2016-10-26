# Configures a consulserver
class roles::consulserver inherits roles::base {

  include ::profiles::consul::server

}
