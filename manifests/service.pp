# == Class: freepbx::service
#
# Service class for freepbx module
#
#   See README.md for details
#
class freepbx::service {

  exec { '/usr/local/sbin/amportal a reload':
    cwd         => '/var/lib/asterisk/bin',
    refreshonly => true,
  }

  service {'fail2ban':
    ensure  => running,
    require => Service['httpd'],
  }

  service {'asterisk':
    ensure => running,
  }

}


