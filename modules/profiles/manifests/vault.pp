class profiles::vault {

  file { '/etc/vault/ssl':
    ensure => directory,
    mode   => 0700,
    owner  => 'vault',
    group  => 'vault',
  }

  file { '/etc/vault/ssl/cert.pem':
    ensure  => present,
    source  => "/etc/puppetlabs/puppet/ssl/certs/${::fqdn}.pem",
    mode    => '0600',
    owner   => 'vault',
    mode    => 'vault',
    require => File['/etc/vault/ssl'],
  }

  file { '/etc/vault/ssl/key.pem':
    ensure  => present,
    source  => "/etc/puppetlabs/puppet/ssl/private_keys/${::fqdn}.pem",
    mode    => '0600',
    owner   => 'vault',
    mode    => 'vault',
    require => File['/etc/vault/ssl'],
  }

	class { '::vault':
    backend  => {
      consul => {
        address       => "${::fqdn}:8500",
        path          => "vault",
      }
    },
    listener => {
      tcp           => {
        address       => "0.0.0.0:8200",
        tls_cert_file => '/etc/vault/ssl/cert.pem',
        tls_key_file  => '/etc/vault/ssl/key.pem', 
      }
		},
		require [ File['/etc/vault/ssl/cert.pem', '/etc/vault/ssl/key.pem'],
	}

}
