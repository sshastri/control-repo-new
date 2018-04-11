class profile::app::puppet::hiera_eyaml {

  package { 'hiera-eyaml':
    ensure   => present,
    provider => 'puppet_gem',
  }

  package { 'puppetserver-hiera-eyaml':
    ensure   => present,
    name     => 'hiera-eyaml',
    provider => 'puppetserver_gem',
  }

  $eyamlkeys_dir = '/etc/puppetlabs/puppet/eyaml'

  #Directory for keys
  file { $eyamlkeys_dir :
    ensure => directory,
    owner  => 'pe-puppet',
    group  => 'pe-puppet',
    mode   => '0500',
    before => Exec['create_keys'],
  }

  #Create eyaml keys if not present
  exec {'create_keys' :
    command =>  "eyaml createkeys \
                  --pkcs7-private-key=${eyamlkeys_dir}/private_key.pkcs7.pem  \
                  --pkcs7-public-key=${eyamlkeys_dir}/public_key.pkcs7.pem",
    path    => '/opt/puppetlabs/puppet/bin',
    creates => ["${eyamlkeys_dir}/private_key.pkcs7.pem","${eyamlkeys_dir}/public_key.pkcs7.pem"],
    require => Package['puppetserver-hiera-eyaml', 'hiera-eyaml'],
  }

  #Permissions for keys
  file { ["${eyamlkeys_dir}/private_key.pkcs7.pem",
          "${eyamlkeys_dir}/public_key.pkcs7.pem"]:
    ensure    => 'present',
    owner     => 'pe-puppet',
    group     => 'pe-puppet',
    mode      => '0400',
    subscribe => Exec['create_keys'],
  }

}
