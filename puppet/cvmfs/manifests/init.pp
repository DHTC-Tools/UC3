#########################################################################
#
# Installs CVMFS Client and the various dependencies
# 
# Once installed, users should be able to access the following:
#   /cvmfs/atlas.cern.ch
#   /cvmfs/atlas-condb.cern.ch
#   /cvmfs/atlas-nightlies.cern.ch
#   /cvmfs/uc3.uchicago.edu  
#
# Usage:            class { 'cvmfs::uc3::client': version => '2.0.18-1.el5'}
#
# Original author:  Dave Lesny (for MWT2)
# Modified by:      Lincoln Bryant (for UC3)
# Last modified:    4/2/2013
#########################################################################

class cvmfs::uc3::client($version) {

  file { 'RPM-GPG-KEY-CernVM': 
    path       => "/etc/pki/rpm-gpg/RPM-GPG-KEY-CernVM",
    source     => "puppet:///modules/cvmfs/RPM-GPG-KEY-CernVM" 
  }

  package { 'fuse.x86_64':        ensure => present }

  file { "/etc/fuse.conf":
    source     => "puppet:///modules/cvmfs/fuse.conf",
    require    => Package['fuse.x86_64']
  }

  file { "/etc/sysconfig/modules/fuse.modules":
    source     => "puppet:///modules/cvmfs/fuse.modules",
    require    => Package['fuse.x86_64'],
    mode       => 0755
  }

  exec { "/etc/sysconfig/modules/fuse.modules": 
    onlyif     => "/bin/sh -c '! lsmod | grep -q fuse'", 
    require    => File["/etc/sysconfig/modules/fuse.modules"], 
    notify     => Service['autofs'] 
  }

  package { 'autofs.x86_64':      ensure => present }

  service { "autofs":
    enable     => true,
    ensure     => true,
    pattern    => "automount",
    require    => Package['autofs.x86_64'] 
  }

  file { "/etc/auto.master":
    owner      => "root",
    group      => "root",
    mode       => 644,
    source     => "puppet:///modules/cvmfs/auto.master",
    require    => Package['autofs.x86_64'],
    notify     => [Service['autofs']]
  }

  package { 'cvmfs-keys':         
    ensure     => present,
    require    => File['RPM-GPG-KEY-CernVM'],
  }

  package { 'cvmfs':            
    ensure     => "${version}",
    require    => [ File['RPM-GPG-KEY-CernVM'],
                  Package['fuse.x86_64'],
                  Package['autofs.x86_64'],
                  Package['cvmfs-keys'], 
                ],
  }

  package { 'cvmfs-init-scripts': 
    ensure     => present,
    require    => Package['cvmfs'] 
  }

  file { "/etc/cvmfs/default.local":
    owner      => "root",
    group      => "root",
    mode       => 644,
    notify     => [Service["cvmfs"], Service["autofs"]],
    require    => Package['cvmfs'],
    source     => "puppet:///modules/cvmfs/default.local"
  }

# This may need to be modified to fit your site!! 
  file { '/scratch/cvmfs':
    ensure     => directory,
    owner      => "cvmfs",
    group      => "cvmfs"
  }

# Repos actually get instantiated here
  cvmfs::repository::cern { 'atlas.cern.ch': }   
  cvmfs::repository::cern { 'atlas-nightlies.cern.ch': }  
  cvmfs::repository::cern { 'atlas-condb.cern.ch': }  
  cvmfs::repository::uc3  { 'uc3.uchicago.edu': }


  service { 'cvmfs':
    enable     => true,
    ensure     => true,
    hasstatus  => true,
    hasrestart => true,
    restart    => "/etc/init.d/cvmfs reload",
    require    => [ 
      Package['cvmfs'], 
      Package['cvmfs-init-scripts'], 
      Package['cvmfs-keys'],
      Service['autofs'],
      File['/etc/cvmfs/default.local'], 
      File['/etc/auto.master'], 
      File['/etc/fuse.conf']  
    ]
  }


# The cvmfs_reload is used to force a "reload" of the CVMFS configuration once per day

  file { "/etc/cron.d/cvmfs_reload.cron":
    owner      => "root",
    group      => "root",
    mode       => 644,
    source     => "puppet:///modules/cvmfs/cvmfs_reload.cron",
    require    => Package['cvmfs']
  }

}


#########################################################################
#
# Creates the appropriate 'local' configuration file for a cern repository
#
#    cvmfs::repository::cern { 'atlas.cern.ch': }   
#
#########################################################################

define cvmfs::repository::cern { 

  file { "/etc/cvmfs/config.d/${name}.local":
    owner      => "root",
    group      => "root",
    mode       => 644,
    notify     => [Service["cvmfs"], Service["autofs"]],
    source     => "puppet:///modules/cvmfs/${name}.local",
    require    => Package['cvmfs']
  }

  exec { "probe ${ name }":
    command    => "/etc/init.d/cvmfs probe",
    creates    => "/cvmfs/${name}",
    require    => Service['cvmfs']  
  }

}

#########################################################################
#
# Creates the appropriate 'local' configuration file for a given repository
#
#    cvmfs::repository::mwt2 { 'uc3.uchicago.edu': }
#
#########################################################################

define cvmfs::repository::uc3 {               

   file { "/etc/cvmfs/config.d/${name}.conf":
     owner     => "root",
     group     => "root",
     mode      => 644,
     notify    => [Service["cvmfs"], Service["autofs"]],
     source    => "puppet:///modules/cvmfs/${name}.conf",
     require   => Package['cvmfs']
   }

   file { "/etc/cvmfs/keys/${name}.pub":
     path      => "/etc/cvmfs/keys/${name}.pub",
     owner     => "root",
     group     => "root",
     mode      => 444,
     source    => "puppet:///modules/cvmfs/${name}.pub",
     notify    => [Service["cvmfs"], Service["autofs"]],
     require   => Package['cvmfs']
   }

   exec { "probe ${ name }":
     command   => "/etc/init.d/cvmfs probe",
     creates   => "/cvmfs/${name}",
     require   => Service['cvmfs']
   }

}
