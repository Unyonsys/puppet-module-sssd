define sssd::domain (
  $ldap_uri,
  $ldap_search_base,
  $ldap_group_search_base,
  $ldap_schema            = 'rfc2307',
  $ldap_id_use_start_tls  = true,
  $tls_ca                 = false,
  $tls_chain              = false,
) {
  include ssl::variables

  if ! ( $tls_ca ) and ! ( $tls_chain ) {
    fail ( 'You must provide either $tls_ca or $tls_chain' )
  }

  if $tls_ca {
    $tlscacertificatefile = "${ssl::variables::ssl_certs}/cert_${tls_ca}.pem"
    Ssl::Cert[$tls_ca] -> Domain[ $name ]
  }
  elsif $tls_chain {
    $tlscacertificatefile = "${ssl::variables::ssl_chain}/chain_${tls_chain}.pem"
    Ssl::Chain[$tls_chain] -> Domain[ $name ]
  }

  concat::fragment { "sssd_domain_${name}":
    target  => '/etc/sssd/sssd.conf',
    order   => 05,
    content => template('sssd/domain.erb'),
  }
}
