# @summary Configures the pihole docker service.
# https://hub.docker.com/r/pihole/pihole
# https://github.com/pi-hole/docker-pi-hole#readme
class rpi::pihole {
  file { [
      '/pihole',
      '/pihole/etc-pihole',
      '/pihole/etc-dnsmasq.d',
    ]:
      ensure  => 'directory',
      recurse => true,
  }

  file { '/pihole/etc-pihole/adlists.list':
    ensure => file,
    source => 'puppet:///modules/rpi/pihole/adlists.list',
  }

  docker_network { 'pihole':
    ensure   => present,
    driver   => 'macvlan',
    subnet   => '192.168.1.0/24',
    gateway  => '192.168.1.1',
    ip_range => '192.168.1.17/32',
    options  => 'parent=eth0',
  }

  docker::run { 'pihole':
    image    => 'pihole/pihole',
    net      => ['pihole'],
    volumes  => [
      '/pihole/etc-pihole:/etc/pihole',
      '/pihole/etc-dnsmasq.d:/etc/dnsmasq.d',
    ],
    hostname => 'pihole',
    env      => [
      'TZ=America/New_York',
      'VIRTUAL_HOST=pi.hole',
      'PROXY_LOCATION=pi.hole',
      "FTLCONF_LOCAL_IPV4=${$facts['networking']['ip']}",
    ],
    dns      => ['127.0.0.1', '1.1.1.1'],
  }
}
