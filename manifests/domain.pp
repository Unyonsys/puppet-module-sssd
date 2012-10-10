define sssd::domain (
  $ldap_uri,
  $ldap_search_base,
  $ldap_group_search_base,
  $ldap_schema            = 'rfc2307',
  $ldap_id_use_start_tls  = true,
) {
  include ssl::variables

  if ! ( $tls_ca_file ) and ! ( $tls_chain_file ) {
    fail ( 'You must provide either $tls_ca_file or $tls_chain_file' )
  } else {  
    $tls_domain = $name
    
    if $tls_ca_file {
      $tlscacertificatefile = "${ssl::variables::ssl_certs}/${tls_ca_file}"
      Ssl::Cert[$tls_ca_file] -> Domain[ $name ]
    }
    elsif $tls_chain_file {
      $tlscacertificatefile = "${ssl::variables::ssl_chain}/${tls_chain_file}"
      Ssl::Chain[$tls_chain_file] -> Domain[ $name ]
    }

    concat::fragment { "sssd_domain_${name}":
      target  => '/etc/sssd/sssd.conf',
      order   => 05,
      content => template('sssd/domain.erb'),
    }
  }
}