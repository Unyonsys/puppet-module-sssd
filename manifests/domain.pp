define sssd::domain (
  $ssl_ca,
  $ldap_uri,
  $ldap_search_base,
  $ldap_group_search_base,
  $ldap_schema  = 'rfc2307'
  ) {
  include ssl::variables
  concat::fragment { "sssd_domain_${name}":
    target  => '/etc/sssd/sssd.conf',
    order   => 05,
    content => template('sssd/domain.erb'),
    require => Ssl::Cert[$ssl_ca]
  }
}