class sssd (
  $domains,
  $local_groups = [ 'adm', 'dialout', 'cdrom', 'plugdev', 'lpadmin', 'sambashare' ],
  $use_ecryptfs = false
  ) {
  include ssl::variables
  
  #Natty ssd package is not working
  if $::lsbdistcodename == 'natty' {
    Class['apt::repository::ppa::fabricesp::experimental'] -> Package['sssd']
  }
  
  if $::lsbdistid in ['Ubuntu', 'Debian'] {
    file { '/etc/security/group.conf':
      ensure  => file,
      content => template('sssd/group.conf.erb'),
    }
  }
  
  package { ['sssd', 'libnss-sss', 'libpam-sss', 'auth-client-config'] :ensure => present }

  concat { '/etc/sssd/sssd.conf':
    warn    => true,
    mode    => 0600,
    require => Package['sssd'],
    notify  => Service['sssd'],
  }
  
  concat::fragment { 'sssd.conf.base':
    target  => '/etc/sssd/sssd.conf',
    order   => 02,
    content => template('sssd/sssd.conf.erb'),
  }

  file { '/etc/auth-client-config/profile.d/sss':
    ensure  => file,
    content => template('sssd/sss.erb'),
    require => Package['auth-client-config'],    
    notify  => Exec['update-sssd-profile'],
  }
  
  exec { 'update-sssd-profile':
    command     => 'auth-client-config -a -p sss',
    require     => [ File['/etc/auth-client-config/profile.d/sss'], Package['sssd', 'libnss-sss', 'libpam-sss'] ],
    refreshonly => true,
  }
  
  service { 'sssd':
    ensure    => running,
    enable    => true,
    hasstatus => true,
    require   => Package['sssd'],
  }

  if $use_ecryptfs {
    file { '/usr/share/libpam-script/pam_script_ses_open':
      ensure => file,
     source => 'puppet:///modules/sssd/pam_script_ses_open',
     mode   => 0755,
    }
  }
}
  
