# == Class: freepbx::install
#
# See README.md for details
#
class freepbx::install {

  # download the necessary repos
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

  package {'git':
    ensure => latest,
  }

  class {'apache':
    user  => 'asterisk',
    group => 'asterisk',
  }

  $packages = [ 'asterisk',
                'php',
                'php-mysql',
                'php-gd',
                'php-pear',
                'php-mysql',
                'php-mbstring'
              ]

  package { $packages:
    ensure => $freepbx::package_ensure,
  }

  apache::mod {'php5': }

  vcsrepo { $freepbx::asterisk_git_repo_dir:
    ensure   => $freepbx::package_ensure,
    provider => git,
    source   => 'http://git.freepbx.org/scm/freepbx/framework.git',
    revision => "release/${freepbx::version}",
  }

}
