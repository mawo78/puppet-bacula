class bacula::pki(
  String $ssl_dir,
) {
  include ::bacula
  include ::bacula::client

  $conf_dir     = $::bacula::conf_dir
  $bacula_user  = $::bacula::bacula_user
  $bacula_group = $::bacula::bacula_group

  $certfile = "${conf_dir}/ssl/${trusted['certname']}_cert.pem"
  $keyfile  = "${conf_dir}/ssl/${trusted['certname']}_key.pem"
  $cafile   = "${conf_dir}/ssl/ca.pem"

  $pki_keypair  = "${conf_dir}/ssl/pki-keypair.pem"

  concat { $pki_keypair:
    owner   => 'root',
    group   => $bacula_group,
    mode    => '0640',
    require => File["${conf_dir}/ssl"],
  }

  concat::fragment { 'ca':
    ensure => present,
    order  => 10,
    target => $pki_keypair,
    source => $cafile,
  }

  concat::fragment { 'certificate':
    ensure => present,
    order  => 20,
    target => $pki_keypair,
    source => $certfile,
  }

  concat::fragment { 'private_key':
    ensure => present,
    order  => 30,
    target => $pki_keypair,
    source => $keyfile,
  }

}
