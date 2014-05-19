# == Class: freepbx::params
#
# See README.md for details
#
class freepbx::params {

  $version               = '2.11'
  $package_ensure        = 'present'
  $asterisk_user         = 'asterisk'
  $asterisk_group        = 'asterisk'
  $asterisk_db_user      = 'asteriskuser'
  $asterisk_git_repo_dir = "/usr/src/freepbx-${version}"
  $vhost_docroot         = '/var/www/html'
  $mysql_root_password   = 'Sf4hc9TFXcsh4DBd'
}
