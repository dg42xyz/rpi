#!/bin/bash
set -eux

# Root check
if [ "$(id -u)" -ne 0 ]; then
  echo 'This script must be run by root' >&2
  exit 1
fi

# Set up environment
mkdir -p /home/pi/.puppetlabs/etc/code/environments/production/modules
mkdir -p /home/pi/.puppetlabs/etc/code/environments/production/manifests
cat > /home/pi/.puppetlabs/etc/code/environments/production/manifests/site.pp << EOF
node default {
  include rpi
}

EOF

# Enable basic autosigning
mkdir -p /home/pi/.puppetlabs/etc/puppet/config
echo "raspberrypi" > /home/pi/.puppetlabs/etc/puppet/config/autosign.conf

# Update system
apt update
apt full-upgrade -y
apt-get autoremove -y
apt clean

# Install puppet agent
apt install ruby-full -y
gem install puppet

# Install modules from forge
puppet module install puppet-systemd --version 4.0.1 --target-dir=/home/pi/.puppetlabs/etc/code/environments/production/modules
puppet module install puppetlabs-apt --version 9.0.2 --target-dir=/home/pi/.puppetlabs/etc/code/environments/production/modules
puppet module install puppetlabs-docker --version 6.0.2 --target-dir=/home/pi/.puppetlabs/etc/code/environments/production/modules
puppet module install puppetlabs-reboot --version 4.3.1 --target-dir=/home/pi/.puppetlabs/etc/code/environments/production/modules
puppet module install puppetlabs-vcsrepo --version 6.1.0 --target-dir=/home/pi/.puppetlabs/etc/code/environments/production/modules
puppet module install albatrossflavour-os_patching --version 0.21.0 --target-dir=/home/pi/.puppetlabs/etc/code/environments/production/modules

# Install docker
curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
sh /tmp/get-docker.sh

# Run puppet server
docker run -d --name puppet --hostname puppet -p 8140:8140 -v /home/pi/.puppetlabs/etc/code:/etc/puppetlabs/code -v /home/pi/.puppetlabs/etc/puppet:/etc/puppetlabs/puppet voxpupuli/container-puppetserver
health=$(docker inspect --format='{{ json .State.Health.Status }}' puppet)
until [ "$health" = '"healthy"' ]; do
  echo "Waiting for puppetserver container to be healthy"
  sleep 10
  health=$(docker inspect --format='{{ json .State.Health.Status }}' puppet)
done
