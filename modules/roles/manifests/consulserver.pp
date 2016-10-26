# Configures a consulserver
class roles::consulserver inherits roles::base {

  class { '::consul':
    config_hash => {
      datacenter          => 'lon1',
      server              => true,
      data_dir            => '/opt/consul',
      client_addr         => '0.0.0.0',
      ui_dir              => '/opt/consul-ui',
      node_name           => "${::fqdn}",
      log_level           => "DEBUG",
      encrypt             => "cg8StVXbQJ0gPvMd9o7yrg==", # https://www.consul.io/docs/agent/encryption.html
      bootstrap_expect    => 3,
      disable_remote_exec => true,
      retry_join          => [ 'consulserver-0.briggs.lan', 'consulserver-1.briggs.lan', 'consuslerver-2.briggs.lan' ]
    }
  }

}
