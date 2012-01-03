  class { 'sssd':
    domains      => ['example'],
    use_ecryptfs => true
  }

  sssd::domain { 'example':
    ssl_ca                  => 'example',
    ldap_uri                => 'ldap://server.example.com',
    ldap_search_base        => 'dc=root',
    ldap_group_search_base  => 'dc=root'
  }

