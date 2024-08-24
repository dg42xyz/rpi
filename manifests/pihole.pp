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
    ensure            => present,
    driver            => 'macvlan',
    subnet            => '192.168.1.0/24',
    gateway           => '192.168.1.1',
    ip_range          => '192.168.1.17/32',
    additional_flags  => ['-o parent=eth0'],
  }

  # docker run -d --name pihole \
  #   -p 53:53/tcp -p 53:53/udp -p 80:80 \
  #   -v "/home/pi/pihole/etc-pihole:/etc/pihole" \
  #   -v "/home/pi/pihole/etc-dnsmasq.d:/etc/dnsmasq.d" \
  #   --dns=127.0.0.1 --dns=1.1.1.1 --hostname pi.hole \
  #   -e TZ="America/New_York" -e VIRTUAL_HOST="pi.hole" \
  #   -e PROXY_LOCATION="pi.hole" -e FTLCONF_LOCAL_IPV4="192.168.1.63" \
  #   pihole/pihole:latest
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
