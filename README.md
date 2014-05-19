Introduction
============

This module try to install and setup freepbx from git repository.
After the first run, you should finish freepbx install by going on http://nodename/admin/config.php

Compatibility
=============

This module has been tested on CentOS 6.5 x64

Requires
========

* Puppetlabs Apache <https://forge.puppetlabs.com/puppetlabs/apache>
* Puppetlabs Concat <https://forge.puppetlabs.com/puppetlabs/concat>
* Puppetlabs MySQL <https://forge.puppetlabs.com/puppetlabs/mysql>
* Example42 Yum <https://forge.puppetlabs.com/example42/yum>
* Puppetlabs vcsrepo <https://forge.puppetlabs.com/puppetlabs/vcsrepo>

About
=====

Work inspired by camptocamp's puppet-freepbx module and the [FreePBX Wiki](http://wiki.freepbx.org/display/HTGS/Installing+FreePBX+2.11+on+Centos+6.3#InstallingFreePBX2.11onCentos6.3-InstallandConfigureFreePBX)

Parameters
==========

* [*version*]

  Release version of freepbx to download and install.
  At time of writing this module, version 2.11, 2.10 and 12 are available.
  This parameter must be set.

* [*vhost_name*]

  Name user in apache for asterisk vhost.
  This parameter must be set.

* [*package_ensure*]

  Set if freepbx module should install packages.
  Value: present or absent. Defaults to Present

* [*asterisk_user*]

  Specify user name for the daemon asterisk. defaults to 'asterisk'.

* [*asterisk_group*]

  Specify user group for the daemon asterisk. defaults to 'asterisk'.

* [*asterisk_db_user*]

  mysql user for asterisk and freepbx

* [*asterisk_db_pass*]

  mysql password for asterisk and freepbx

* [*asterisk_git_repo_dir*]

  local directory user for git repository download.
  Defaults to '/usr/src/freepbx/framework'.

* [*vhost_docroot*]

  DocumentRoot for apache vhost.
  Defaults to '/var/www'.

* [*asterisk_amp_username*]

* [*asterisk_amp_pass*]

Example
=======

```puppet
class { 'freepbx':
  version          => '2.11',
  vhost_name       => 'freepbx.example.com',
  asterisk_db_pass => 'changemeasIamaweakpassword',
}
```

Authors
=======

Vito LaVilla <vslavilla@gmail.com>

Forked from Simon Séhier <simon.sehier@camptocamp.com>

Copyright
=========

Copyright 2014 Simon Séhier, Camptocamp.com

