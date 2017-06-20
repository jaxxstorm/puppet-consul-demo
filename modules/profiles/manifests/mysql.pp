# mysql profile
class profiles::mysql {


  class { '::mysql::server':
    root_password           => 'correcthorsebatterystable',
    remove_default_accounts => true,
    override_options        => {
      'mysqld' => {
        'bind-address' => $::digital_ocean_interfaces_private_0_ipv4_address
      }
    }
  }


}
