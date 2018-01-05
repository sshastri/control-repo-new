# This profile sets up the config for a Puppet Compile Master
class profile::app::puppet::compilemaster {

  # Export a balancermember server for the loadbalancer
  @@haproxy::balancermember { $facts['fqdn']:
    listening_service => 'puppet00',
    server_names      => $facts['hostname'],
    ipaddresses       => $facts['ipaddress'],
    ports             => '8140',
    options           => 'check',
  }

}
