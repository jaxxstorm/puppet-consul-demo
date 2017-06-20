# mysql profile
class profiles::mysql {


  class { '::mysql::server':
    root_password           => 'correcthorsebatterystable',
    remove_default_accounts => true,
  }


}
