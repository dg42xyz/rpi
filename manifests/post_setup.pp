# @summary Post-setup config to reboot after first agent run.
class rpi::post_setup {
  file { '/home/pi/.puppetized':
    ensure => file,
    owner  => 'pi',
    group  => 'pi',
  }

  reboot { 'After first run':
    apply     => 'finished',
    subscribe => File['/home/pi/.puppetized'],
  }
}
