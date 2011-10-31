class sssd::ldapadmins {
  concat::fragment { 'sudoers_admins' :
      target  => '/etc/sudoers',
      order   => 10,
      source  => 'puppet:///modules/authentication/sudoers_admins_in_ldap'
  }
}