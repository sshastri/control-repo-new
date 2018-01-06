# This profile sets up the config for a Puppet Compile Master
class profile::app::puppet::compilemaster {

  # Export a balancermember server for the loadbalancer
  @@haproxy::balancermember { "puppet-agent-${facts['fqdn']}":
    listening_service => 'puppet00',
    server_names      => $facts['hostname'],
    ipaddresses       => $facts['ipaddress'],
    ports             => '8140',
    options           => 'check',
  }

  @@haproxy::balancermember { "pxp-agent-${facts['fqdn']}":
    listening_service => 'puppet01',
    server_names      => $facts['hostname'],
    ipaddresses       => $facts['ipaddress'],
    ports             => '8142',
    options           => 'check',
  }
}
