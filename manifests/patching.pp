# @summary Configures patching for the raspian os.
# https://forge.puppet.com/modules/albatrossflavour/os_patching/readme
class rpi::patching {
  class { 'os_patching': }

  schedule { 'maintenance_window':
    period  => weekly,
    weekday => 'Saturday',
    range   => '01:00 - 05:00',
    repeat  => 1,
  }

  exec { 'Patch raspian':
    command  => '/usr/local/bin/puppet task run os_patching::patch_server',
    schedule => 'maintenance_window',
  }
}
