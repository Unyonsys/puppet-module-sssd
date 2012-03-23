class sssd::config (
  $domains,
  $local_groups,
  $use_ecryptfs,
) {

  concat { '/etc/sssd/sssd.conf':
    warn    => true,
    mode    => '0600',
  }

  concat::fragment { 'sssd.conf.base':
    target  => '/etc/sssd/sssd.conf',
    order   => 02,
    content => template('sssd/sssd.conf.erb'),
  }
  
  file { '/etc/security/group.conf':
    ensure  => file,
    content => template('sssd/group.conf.erb'),
  }

  file { '/etc/auth-client-config/profile.d/sss':
    ensure  => file,
    content => template('sssd/sss.erb'),
    notify  => Exec['update-sssd-profile'],
  }

  exec { 'update-sssd-profile':
    command     => 'auth-client-config -a -p sss',
    require     => File[ '/etc/auth-client-config/profile.d/sss' ],
    refreshonly => true,
  }

  if $use_ecryptfs {
    package { 'libpam-script':
      ensure => present
    }

    file { '/usr/share/libpam-script/pam_script_ses_open':
      ensure  => file,
      source  => 'puppet:///modules/sssd/pam_script_ses_open',
      mode    => '0755',
      require => Package['libpam-script']
    }

    file { '/usr/local/bin/ecryptfs-wrap-passphrase-1st-login.sh':
      ensure  => file,
      source  => 'puppet:///modules/sssd/ecryptfs-wrap-passphrase-1st-login.sh',
      mode    => '0755',
    }

    file { '/usr/share/autostart/ecryptfs-wrap-passphrase-1st-login.desktop':
      ensure  => file,
      source  => 'puppet:///modules/sssd/ecryptfs-wrap-passphrase-1st-login.desktop',
      mode    => '0644',
    }
  }
}
