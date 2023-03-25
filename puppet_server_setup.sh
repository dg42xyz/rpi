# Set up environment
mkdir -p ~/.puppetlabs/etc/code/environments/production/modules
mkdir -p ~/.puppetlabs/etc/code/environments/production/manifests
cat > ~/.puppetlabs/etc/code/environments/production/manifests/site.pp << EOF
node default {
  include rpi
}
EOF

# Enable basic autosigning
mkdir -p ~/.puppetlabs/etc/puppet/config
echo "raspberrypi" > ~/.puppetlabs/etc/puppet/config/autosign.conf

# Install modules from forge
puppet module install puppet-systemd --version 4.0.1
puppet module install puppetlabs-apt --version 9.0.2
puppet module install puppetlabs-docker --version 6.0.2
puppet module install puppetlabs-reboot --version 4.3.0

# Run puppet server
docker run -d --name puppet --hostname puppet -p 8140:8140 -v ~/.puppetlabs/etc/code:/etc/puppetlabs/code -v ~/.puppetlabs/etc/puppet:/etc/puppetlabs/puppet puppet/puppetserver
