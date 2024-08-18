# @summary Configuration for the raspberry pi host.
class rpi::rpi_host {
  file { '/etc/resolv.conf':
    ensure => file,
    source => 'puppet:///modules/rpi/rpi_host/resolv.conf',
  }

  $pkgs = {
    git => 'present',
    vim => 'present',
  }
  $pkgs.each |$key, $value| {
    package { $key:
      ensure => $value,
    }
  }

  package { 'puppet':
    ensure   => 'present',
    provider => 'gem',
  }

  file { '/etc/default/puppet':
    ensure => file,
  }

  systemd::timer { 'puppet.timer':
    timer_source   => 'puppet:///modules/rpi/rpi_host/puppet.timer',
    service_source => 'puppet:///modules/rpi/rpi_host/puppet.service',
    active         => true,
    enable         => true,
  }
}
