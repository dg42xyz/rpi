# @summary Configures docker.
class rpi::docker {
  file { 'Docker convenience script':
    ensure         => file,
    path           => '/tmp/get-docker.sh',
    source         => 'https://get.docker.com',
    mode           => 'u=rwx',
    checksum       => 'sha256',
    checksum_value => '3829968f490ad98516d606c267465c51391d9102a12fb3515ce716d5ce1ec523',
  }

  exec { 'Install docker':
    command => '/tmp/get-docker.sh',
    returns => ['0', '100'],
    onlyif  => '/usr/bin/test -z `/usr/bin/which docker`',
    require => File['Docker convenience script'],
  }

  reboot { 'After docker install':
    subscribe => Exec['Install docker'],
  }

  service { 'docker':
    ensure => 'running',
    enable => true,
  }

  service { 'containerd':
    ensure => 'running',
    enable => true,
  }

  include docker
}
