class sssd::service {
  service { 'sssd':
    ensure    => running,
    enable    => true,
    hasstatus => true,
  }
}
