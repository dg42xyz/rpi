# @summary Configures the unifi docker service.
# https://github.com/jacobalberty/unifi-docker
# https://hub.docker.com/r/jacobalberty/unifi
class rpi::unifi {
  file { [
      '/unifi',
      '/unifi/data',
      '/unifi/log',
    ]:
      ensure  => 'directory',
      recurse => true,
  }

  # docker run -d --name unifi --user unifi \
  #   -p 8080:8080 -p 8443:8443 -p 3478:3478/udp \
  #   -e TZ='America/New_York' \
  #   -v /home/pi/unifi:/unifi \
  #   jacobalberty/unifi
  docker::run { 'unifi':
    image            => 'jacobalberty/unifi',
    ports            => ['8080:8080', '8443:8443', '3478:3478/udp'],
    volumes          => ['/unifi:/unifi'],
    username         => 'unifi',
    hostname         => 'unifi',
    env              => ['TZ=America/New_York'],
    extra_parameters => ['--init'],
  }
}
