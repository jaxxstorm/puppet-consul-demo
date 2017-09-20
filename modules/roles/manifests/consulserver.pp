# Configures a consulserver
class roles::consulserver inherits roles::base {

  ::profiles::consul::server

}
