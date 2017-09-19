# mysql profile
class profiles::mysql (
 $privileges         = [ 'ALL' ],
){


  class { '::mysql::server':
    root_password           => 'correcthorsebatterystable',
    remove_default_accounts => true,
    override_options        => {
      'mysqld' => {
        'bind-address' => $::digital_ocean_interfaces_private_0_ipv4_address
      }
    }
  }

  mysql_user { 'vault@%':
    ensure        => present,
    password_hash => mysql_password('vault')
  }

  mysql_grant { 'vault@%/*.*':
    ensure     => present,
    privileges => $privileges,
    table 		 => '*.*',
    user       => 'vault@%',
    options    => ['GRANT'],
    require    => Mysql_user['vault@%'],
  }
}
