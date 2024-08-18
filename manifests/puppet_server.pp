# @summary Configures the puppet server docker service.
class rpi::puppet_server {
  file { [
      '/home/pi/.puppetlabs/etc/code/environments/production/manifests',
      '/home/pi/.puppetlabs/etc/puppet/config',
    ]:
      ensure  => 'directory',
      recurse => true,
  }

  file { '/home/pi/.puppetlabs/etc/code/environments/production/manifests/site.pp':
    ensure => file,
    source => 'puppet:///modules/rpi/puppet_server/site.pp',
  }

  file { '/home/pi/.puppetlabs/etc/puppet/config/autosign.conf':
    ensure  => file,
    content => 'raspberrypi',
  }

  vcsrepo { '/home/pi/.puppetlabs/etc/code/environments/production/modules/rpi':
    ensure         => mirror,
    provider       => git,
    source         => 'https://github.com/dg42xyz/rpi.git',
    owner          => 'pi',
    group          => 'pi',
    safe_directory => true,
    force          => true,
  }

  # docker run -d --name puppet \
  #   --hostname puppet -p 8140:8140 \
  #   -v /home/pi/.puppetlabs/etc/code:/etc/puppetlabs/code \
  #   -v /home/pi/.puppetlabs/etc/puppet:/etc/puppetlabs/puppet \
  #   voxpupuli/container-puppetserver
  docker::run { 'puppet':
    image           => 'voxpupuli/container-puppetserver',
    ports           => ['8140:8140'],
    volumes         => [
      '/home/pi/.puppetlabs/etc/code:/etc/puppetlabs/code',
      '/home/pi/.puppetlabs/etc/puppet:/etc/puppetlabs/puppet',
    ],
    hostname        => 'puppet',
    before_start    => 'rm -rf /home/pi/.puppetlabs/etc/puppet/ssl; rm -rf /etc/puppetlabs/puppet/ssl',
    restart_service => false,
  }
}
