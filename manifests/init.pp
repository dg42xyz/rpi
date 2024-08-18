# @summary Configuration for my raspberry pi.  It applies configuration to the 
# raspberry pi host, then installs docker and runs two docker services: a 
# pi-hole and a unifi controller.
class rpi {
  include rpi::rpi_host
  include rpi::patching
  include rpi::docker
  include rpi::pihole
  include rpi::unifi
  include rpi::puppet_server
  include rpi::post_setup
}
