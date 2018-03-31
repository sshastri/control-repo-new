# This profile manages the Puppet agent and its settings.
class profile::app::puppet::agent {

  # Always make sure the puppet agent is running and enabled.
  service { 'puppet':
    ensure => running,
    enable => true,
  }

  # Determine what value to use for the 'server' setting in puppet.conf
  #  - Normal agents should point to the load-balancer
  #  - Puppet masters must point to the MoM.
  #
  # To figure out if a node is a Puppet master, we can check for the existance
  # of the pe_server_version fact which is only available on a Puppet master.
  # If it doesn't exist (is undef), we know we're on a normal agent.
  $puppet_agent_server = $facts['pe_server_version'] ? {
    undef   => lookup('profile::app::puppet::agent::server'),
    default => lookup('puppet_mom'),
  }

  $puppet_config = $facts['os']['family'] ? {
    'windows' => 'C:/ProgramData/PuppetLabs/puppet/etc/puppet.conf',
    default   => '/etc/puppetlabs/puppet/puppet.conf',
  }

  # Set the server setting in puppet.conf
  ini_setting { 'puppet agent server setting':
    ensure  => present,
    path    => $puppet_config,
    section => 'main',
    setting => 'server',
    value   => $puppet_agent_server,
  }

}
