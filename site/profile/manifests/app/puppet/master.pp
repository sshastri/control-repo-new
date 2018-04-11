#This profile manages a Puppet monolithic master (MoM)
class profile::app::puppet:master {

  inlude profile::app::puppet::hiera_eyaml

  # Enable basic autosigning
  ini_setting { 'Enable autosigning':
    ensure  => present,
    path    => '/etc/puppetlabs/puppet/puppet.conf',
    section => 'master',
    setting => 'autosign',
    value   => '/etc/puppetlabs/puppet/autosign.conf',
  }

  $autosign_domains = [
    '*.company1.com',
    '*.company2.com',
    '*.company3.com',
  ]

  file { '/etc/puppetlabs/puppet/autosign.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => join($autosign_domains, "\n"),
  }

  # Firewall settings
  Firewalld_port {
    zone     => 'public',
    protocol => 'tcp',
  }

  firewalld_port { 'Open port 443 - Puppet Console':
    ensure => present,
    port   => '443',
  }

  firewalld_port { 'Open port 4433 - Puppet Node Classifier':
    ensure => present,
    port   => '4433',
  }

  firewalld_port { 'Open port 8081 - PuppetDB':
    ensure => present,
    port   => '8081',
  }

  firewalld_port { 'Open port 8142 - Puppet Orchestrator':
    ensure => present,
    port   => '8142',
  }

  firewalld_port { 'Open port 8170 - Puppet Code Manager':
    ensure => present,
    port   => '8170',
  }

}
