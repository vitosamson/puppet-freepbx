# == Class: freepbx::install
#
# See README.md for details
#
class freepbx::install {

  include freepbx::repos

  exec {'yum -y groupinstall core': }
  exec {'yum -y groupinstall base': }

  class {'apache':
    user  => 'asterisk',
    group => 'asterisk',
  }

  include 'apache::mod::php'
  include 'apache::mod::prefork'

  $packages = [ 'asterisk',
                'php',
                'php-gd',
                'php-pear',
                'php-pear-DB',
                'php-mbstring',
                'ncurses-devel',
                'php-mysql',
                'php-posix',
                'php-ldap',
                'fail2ban'
              ]

  package { $packages:
    ensure => $freepbx::package_ensure,
    require => [ File['/etc/yum.repos.d/centos-digium.repo'], Class['yum::repo::epel'] ],
  }

  package {'git':
    ensure => latest,
  }

  vcsrepo { $freepbx::asterisk_git_repo_dir:
    ensure   => $freepbx::package_ensure,
    provider => git,
    source   => 'http://git.freepbx.org/scm/freepbx/framework.git',
    revision => "release/${freepbx::version}",
    require  => Package['git'],
  }

  file {'/var/lib/asterisk/agi-bin':
    ensure => directory,
  }

}
