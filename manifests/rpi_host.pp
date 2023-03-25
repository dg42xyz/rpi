# @summary Configuration for the raspberry pi host.
class rpi::rpi_host {
  file { '/etc/resolv.conf':
    ensure => 'file',
    source => 'puppet:///modules/rpi/resolv.conf',
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
    ensure => 'file',
  }

  file { '/etc/systemd/system/puppet.service':
    ensure => 'file',
    source => 'puppet:///modules/rpi/puppet.service',
  }

  service { 'puppet':
    ensure => 'running',
    enable => true,
  }
}
