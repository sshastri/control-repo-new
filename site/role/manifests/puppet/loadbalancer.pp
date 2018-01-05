class role::puppet::loadbalancer {

  include profile::base
  include profile::app::haproxy

}
