class sssd (
  $domains,
  $local_groups = $sssd::variables::local_groups,
  $use_ecryptfs = false
) inherits sssd::variables {

  validate_array( $domains, $local_groups ) 
  validate_bool ( $use_ecryptfs )

  anchor { 'sssd::begin': }
  anchor { 'sssd::end': }

  Anchor[ 'sssd::begin' ] -> class { 'sssd::install': } -> Class['sssd::config'] ~> class {'sssd::service': } -> Anchor[ 'puppet::end' ]
  
  class { 'sssd::config':
    domains      => $domains,
    local_groups => $local_groups,
    use_ecryptfs => $use_ecryptfs
  }
}
