#!/bin/bash
set -eux

PUPPET_SERVER_IP="192.168.7.93"

# Root check
if [ "$(id -u)" -ne 0 ]; then
        echo 'This script must be run by root' >&2
        exit 1
fi

# Update system
apt update
apt full-upgrade -y
apt-get autoremove -y
apt clean

# Install puppet agent
apt install ruby-full -y
gem install puppet
mkdir -p /etc/puppetlabs/puppet/
touch /etc/puppetlabs/puppet/puppet.conf
puppet config set server puppet --section main
echo "${PUPPET_SERVER_IP}    puppet" >> /etc/hosts

# Run puppet
puppet ssl bootstrap
puppet agent -t
