# == Class: freepbx::install
#
# See README.md for details
#
class freepbx::install {

  package {'git':
    ensure => latest,
  }

  class {'apache':
    user  => 'asterisk',
    group => 'asterisk',
  }

  $packages = [ 'asterisk',
                'asterisk-moh-opsound-gsm',
                'libapache2-mod-php5',
                'php5',
                'php5-mysql',
                'php5-gd',
                'php-db'
              ]

  package { $packages:
    ensure => $freepbx::package_ensure,
  }

  vcsrepo { $freepbx::asterisk_git_repo_dir:
    ensure   => $freepbx::package_ensure,
    provider => git,
    source   => 'http://git.freepbx.org/scm/freepbx/framework.git',
    revision => "release/${freepbx::version}",
  }

}
