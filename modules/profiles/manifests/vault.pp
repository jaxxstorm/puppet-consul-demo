class profiles::vault (
  $consul_address = "${::fqdn}:8500" 
){

  file { '/etc/vault/ssl':
    ensure => directory,
    mode   => '0700',
    owner  => 'vault',
    group  => 'vault',
  }

  file { '/etc/vault/ssl/cert.pem':
    ensure  => file,
    source  => "/etc/puppetlabs/puppet/ssl/certs/${::fqdn}.pem",
    mode    => '0600',
    owner   => 'vault',
    group   => 'vault',
    require => File['/etc/vault/ssl'],
    notify  => Service['vault'],
  }

  file { '/etc/vault/ssl/key.pem':
    ensure    => file,
    source    => "/etc/puppetlabs/puppet/ssl/private_keys/${::fqdn}.pem",
    mode      => '0600',
    owner     => 'vault',
    group     => 'vault',
    show_diff => false,
    require   => File['/etc/vault/ssl'],
    notify    => Service['vault'],
  }

  class { '::vault':
    backend  => {
      consul => {
        address => $consul_address,
        path    => "vault/${::digital_ocean_region}",
      },
    },
    listener => {
      tcp           => {
        address       => '0.0.0.0:8200',
        tls_cert_file => '/etc/vault/ssl/cert.pem',
        tls_key_file  => '/etc/vault/ssl/key.pem',
      },
    }
  }

}
