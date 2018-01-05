class profile::app::haproxy {

  include ::haproxy
  haproxy::listen { 'puppet00':
    ipaddress => $facts['ipaddress'],
    ports     => '8140',
  }

}
