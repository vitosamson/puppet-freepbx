# == Class: freepbx::config
#
# Config class for freepbx module
#
#   See README.md for details
#
class freepbx::config {

  File {
    owner   => $freepbx::asterisk_user,
    group   => $freepbx::asterisk_group,
  }

  # fail2ban:

  file {'/etc/fail2ban/jail.local':
    ensure  => present,
    source  => "puppet:///modules/freepbx/fail2ban/jail.local",
    owner   => "root",
    require => Package['fail2ban'],
    notify  => Service['fail2ban']
  }

  file {'/etc/fail2ban/filter.d/asterisk.conf':
    ensure  => present,
    source  => "puppet:///modules/freepbx/fail2ban/asterisk.conf",
    owner   => "root",
    require => Package['fail2ban'],
    notify  => Service['fail2ban'],
  }

  # apache:

  file { $freepbx::vhost_docroot:
    ensure  => directory,
  }

  apache::vhost { $freepbx::vhost_name:
    port    => 80,
    docroot => $freepbx::vhost_docroot,
  }

  file {'/etc/php.ini':
    ensure => present,
    owner  => root,
    source => "puppet:///modules/freepbx/php.ini",
  }

  # mysql:

  class {'::mysql::server':
    root_password => $freepbx::mysql_root_password,
  }

  mysql::db {'asterisk':
    user     => $freepbx::asterisk_db_user,
    password => $freepbx::asterisk_db_pass,
  }

  mysql::db {'asteriskcdrdb':
    user     => $freepbx::asterisk_db_user,
    password => $freepbx::asterisk_db_pass,
  }

  # We could translate these SQL scripts into puppet receipt, but then this
  # module would be obsolete every new version of freepbx's SQL scripts
  exec { 'mysql newinstall.sql':
    command     => "mysql --user=${freepbx::asterisk_db_user} --password=${freepbx::asterisk_db_pass} --database=asterisk < ${freepbx::asterisk_git_repo_dir}/SQL/newinstall.sql",
    cwd         => $freepbx::asterisk_git_repo_dir,
    environment => "MYSQL_PWD=${freepbx::asterisk_db_pass}",
    unless      => "mysql --user=${freepbx::asterisk_db_user} --password=${freepbx::asterisk_db_pass} asterisk -e \"SELECT * FROM dahdichandids LIMIT 1;\"",
    require     => Mysql::Db['asterisk'],
  } ->

  exec { 'mysql cdr_nmysql_table.sql':
    command     => "mysql --user=${freepbx::asterisk_db_user} --password=${freepbx::asterisk_db_pass} --database=asteriskcdrdb  < ${freepbx::asterisk_git_repo_dir}/SQL/cdr_mysql_table.sql",
    cwd         => $freepbx::asterisk_git_repo_dir,
    environment => "MYSQL_PWD=${freepbx::asterisk_db_pass}",
    unless      => "mysql --user=${freepbx::asterisk_db_user} --password=${freepbx::asterisk_db_pass} asteriskcdrdb -e \"SELECT * FROM cdr LIMIT 1;\"",
    require     => Mysql::Db['asteriskcdrdb'],
  } ->


  # Now, install freepbx:
  ## start asterisk
  exec { "${freepbx::asterisk_git_repo_dir}/start_asterisk start":
    cwd    => $freepbx::asterisk_git_repo_dir,
  } ->

  file { "/etc/asterisk/manager.d":
    ensure => directory,
  } ->

  exec { "${freepbx::asterisk_git_repo_dir}/install_amp --username=${freepbx::asterisk_db_user} --password=${freepbx::asterisk_db_pass} --webroot ${freepbx::vhost_docroot} --asteriskuser=${freepbx::asterisk_amp_user} --asteriskpass=${freepbx::asterisk_amp_pass} --freepbxip=${::ipaddress} --scripted --dbhost=localhost":
    cwd     => $freepbx::asterisk_git_repo_dir,
    creates => '/usr/local/sbin/amportal',
  } ->

  # exec 'amportal a ma installall' needs _cache dir but doesn't create it...
  file { "${freepbx::vhost_docroot}/admin/modules/_cache/":
    ensure => directory,
  } ->

  file { "/etc/asterisk/manager_additional.conf":
    ensure => present
  } ->

  file { "/etc/asterisk/manager_custom.conf":
    ensure => present,
    notify => Service['asterisk']
  } ->

  exec { '/usr/local/sbin/amportal a ma installall':
    creates => "${freepbx::vhost_docroot}/admin/modules/weakpasswords/i18n/weakpasswords.pot",
    notify  => Exec['/usr/local/sbin/amportal a reload']
  }


}
