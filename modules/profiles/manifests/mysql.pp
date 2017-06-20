# mysql profile
class profiles::mysql (
 $privileges         = [ 'SELECT', 'INSERT', 'UPDATE', 'DELETE', 'CREATE',
                          'DROP', 'RELOAD', 'PROCESS', 'GRANT OPTION', 'REFERENCES',
                          'INDEX', 'ALTER', 'SHOW DATABASES', 'CREATE TEMPORARY TABLES',
                          'LOCK TABLES', 'EXECUTE', 'REPLICATION SLAVE',
                          'REPLICATION CLIENT', 'CREATE VIEW', 'SHOW VIEW',
                          'CREATE ROUTINE', 'ALTER ROUTINE', 'CREATE USER',
                          'EVENT', 'TRIGGER' ] 
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

  mysql_user { 'vault@consulserver-%.briggs.lan':
    ensure        => present,
    password_hash => mysql_password('vault')
  }

  mysql_grant { 'vault@consulserver-%.briggs.lan/*.*':
    ensure     => present,
    privileges => $privileges,
    table 		 => '*.*',
    user       => 'vault@consulserver-%.briggs.lan',
    require    => Mysql_user['vault@consulserver-%.briggs.lan'],
  }
}
