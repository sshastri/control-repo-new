class profile::app::haproxy {

  class { 'haproxy':
    default_options => {
      'timeout' => [
        'tunnel 15m'
      ],
    },
    merge_options => true,
  }

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
      'option'  => [
        'tcplog',
      ],
      'balance' => 'leastconn',
    },
  }
}
