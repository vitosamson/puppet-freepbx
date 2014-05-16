# == Class: freepbx::service
#
# Service class for freepbx module
#
#   See README.md for details
#
class freepbx::service {

  exec { '/usr/local/sbin/amportal a reload':
    path        => ['/usr/local/sbin', '/var/lib/asterisk/bin'],
    cwd         => '/var/lib/asterisk/bin',
    refreshonly => true,
  }

}


