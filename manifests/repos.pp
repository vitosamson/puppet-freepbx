# == Class: freepbx::repos
#
# Installs the necessary yum repositories
#
class freepbx::repos {

  file {'/etc/yum.repos.d/centos-asterisk-11.repo':
    ensure => present,
    owner  => root,
    source => "puppet:///modules/freepbx/centos-asterisk-11.repo",
  }

  file {'/etc/yum.repos.d/centos-asterisk.repo':
    ensure => present,
    owner  => root,
    source => "puppet:///modules/freepbx/centos-asterisk.repo",
  }

  file {'/etc/yum.repos.d/centos-digium-11.repo':
    ensure => present,
    owner  => root,
    source => "puppet:///modules/freepbx/centos-digium-11.repo",
  }

  file {'/etc/yum.repos.d/centos-digium.repo':
    ensure => present,
    owner  => root,
    source => "puppet:///modules/freepbx/centos-digium.repo",
  }

  include yum::repo::epel

}
