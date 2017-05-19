class bacula::pki(
  String $ssl_dir,
) {
  include ::bacula
  include ::bacula::client

  $conf_dir     = $::bacula::conf_dir
  $bacula_user  = $::bacula::bacula_user
  $bacula_group = $::bacula::bacula_group

  $certfile = "${conf_dir}/ssl/${trusted['certname']}_pki_cert.pem"
  $keyfile  = "${conf_dir}/ssl/${trusted['certname']}_pki_key.pem"

  $pki_keypair  = "${conf_dir}/ssl/pki-keypair.pem"

  exec { 'bacula_pki_key':
    command => "/usr/bin/openssl genrsa -out ${keyfile} 4096",
    creates => $keyfile,
    require => File["${conf_dir}/ssl"]
  }

  exec { 'bacula_pki_cert':
    command => "/usr/bin/openssl req -new -key ${keyfile} -x509 -out ${certfile} -subj /CN=${trusted['certname']}",
    creates => $certfile,
    require => Exec['bacula_pki_key'],
  }

  concat { $pki_keypair:
    owner   => 'root',
    group   => $bacula_group,
    mode    => '0640',
    require => Exec['bacula_pki_cert'],
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
