class profile::base::hosts {

  # Implementing a DNS system with exported records
  @@host { $facts['fqdn']:
    ensure        => present,
    host_aliases  => [$facts['hostname']],
    ip            => $facts['ipaddress'],
    tag           => 'pe-ha',
  }

  Host <<| tag == 'pe-ha' |>>
}
