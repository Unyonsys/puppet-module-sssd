class sssd::variables {
  case $::operatingsystem {
    /(?i-mx:ubuntu|debian)/ : {
      $pkg_list     = [ 'sssd', 'libnss-sss', 'libpam-sss', 'auth-client-config']
      $local_groups = [ 'adm', 'dialout', 'cdrom', 'plugdev', 'lpadmin', 'sambashare', 'libvirtd' ]
    }
    default : {
      fail('Unsupported operating system')
    }
  }
}
