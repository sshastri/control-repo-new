class profile::app::haproxy {

  class { 'haproxy':
    defaults_options  => {
      'timeout' => [
        'http-request 10s',
        'queue 1m',
        'connect 10s',
        'client 1m',
        'server 1m',
        'check 10s',
        'tunnel 15m'
      ],
    },
    merge_options     => true,
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
