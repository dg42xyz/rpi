#!/bin/bash
set -eux

# Root check
if [ "$(id -u)" -ne 0 ]; then
  echo 'This script must be run by root' >&2
  exit 1
fi

PUPPET_SERVER_IP=$(ip --brief address show | grep wlan0 | awk '{print substr($3,0,12)}')

# Configure agent settings
mkdir -p /etc/puppetlabs/puppet/
touch /etc/puppetlabs/puppet/puppet.conf
puppet config set server puppet --section main
echo "${PUPPET_SERVER_IP}    puppet" >> /etc/hosts

# Run puppet
puppet ssl bootstrap
puppet agent -t
