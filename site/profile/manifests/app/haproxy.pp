class profile::app::haproxy {

  include ::haproxy
  #Puppet agent connections
  haproxy::listen { 'puppet00':
    ipaddress => $facts['ipaddress'],
    ports     => '8140',
  }

  #PXP agent connections
  haproxy::listen { 'puppet01':
    ipaddress => $facts['ipaddress'],
    ports     => '8142',
    options   => {
      'balance' => 'leastconn',
    },
  }
}
