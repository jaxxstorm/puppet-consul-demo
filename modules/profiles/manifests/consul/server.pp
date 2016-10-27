# A consul server instance
class profiles::consul::server {

  class { '::consul':
    pretty_config => true,
    config_hash   => {
      datacenter          => $::digital_ocean_region,
      server              => true,
      data_dir            => '/opt/consul',
      client_addr         => '0.0.0.0',
      ui_dir              => '/opt/consul-ui',
      node_name           => $::fqdn,
      log_level           => 'DEBUG',
      advertise_addr      => $::ipaddress_eth1,
      encrypt             => 'cg8StVXbQJ0gPvMd9o7yrg==', # https://www.consul.io/docs/agent/encryption.html
      bootstrap_expect    => 3,
      disable_remote_exec => true,
      retry_join          => [ "consulserver-0.${::domain}", "consulserver-1.${::domain}", "consulserver-2.${::domain}" ]
    }
  }

}
