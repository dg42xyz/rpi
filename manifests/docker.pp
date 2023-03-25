# @summary Configures docker.
class rpi::docker {
  file { 'Docker convenience script':
    ensure         => 'file',
    path           => '/tmp/get-docker.sh',
    source         => 'https://get.docker.com',
    mode           => 'u=rwx',
    checksum       => 'sha256',
    checksum_value => 'f4b318605efd87bb2b717fc5f355b67ecf44828e9cd88758b6e9a136f8680a16',
  }

  exec { 'Install docker':
    command => '/tmp/get-docker.sh',
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
}
