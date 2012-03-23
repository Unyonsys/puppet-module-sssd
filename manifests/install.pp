class sssd::install {
  package { $sssd::variables::pkg_list:
    ensure => present,
  }
}
