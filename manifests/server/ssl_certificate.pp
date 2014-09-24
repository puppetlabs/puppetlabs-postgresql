
# http://www.postgresql.org/docs/9.3/static/ssl-tcp.html
# http://blog.roomthirteen.de/2013/01/07/solved-installing-postgresql-on-ubuntu-12-04/
# http://stackoverflow.com/questions/4294689/how-to-generate-a-key-with-passphrase-from-the-command-line

class postgresql::server::ssl_certificate (

  $force                    = 0,
  $datadir                  = $postgresql::server::datadir,
  $certificate_days         = $postgresql::server::certificate_days,
  $certificate_country      = $postgresql::server::certificate_country,
  $certificate_state        = $postgresql::server::certificate_state,
  $certificate_locality     = $postgresql::server::certificate_locality,
  $certificate_organization = $postgresql::server::certificate_organization,
  $certificate_common_name  = $postgresql::server::certificate_common_name,
  $certificate_email        = $postgresql::server::certificate_email,

){

  # /C=CA/ST=British Columbia/L=Comox/O=TheBrain.ca/CN=thebrain.ca/emailAddress=info@thebrain.ca'
  $certificate_subject = "/C=${certificate_country}/ST=${certificate_state}/L=${certificate_locality}/O=${certificate_organization}/CN=${certificate_common_name}/emailAddress=${certificate_email}" 

  $err_prefix = "Module postgresql::server::ssl_certificate unable to create server certificate: please specify a value for postgresql::server::certificate_"
  if ($certificate_days == undef) { fail("$certificate_{err_prefix}days") }
  if ($certificate_country == undef) { fail("$certificate_{err_prefix}country") }
  if ($certificate_state == undef) { fail("$certificate_{err_prefix}state") }
  if ($certificate_locality == undef) { fail("$certificate_{err_prefix}locality") }
  if ($certificate_organization == undef) { fail("$certificate_{err_prefix}organization") }
  if ($certificate_common_name == undef) { fail("$certificate_{err_prefix}common_name") }
  if ($certificate_email == undef) { fail("$certificate_{err_prefix}email") }

  notify { "debug_postgresql::server::ssl_certificate":
    message => "The postgresql data path is at: $datadir",
  }

  file { "${datadir}/validate_self_signed_ssl_certificate.pl":
    source => 'puppet:///modules/postgresql/validate_self_signed_ssl_certificate.pl',
  }

  file { "${datadir}/generate_self_signed_pg_server_certificate.sh":
    source => 'puppet:///modules/postgresql/generate_self_signed_pg_server_certificate.sh',
  }

  exec { 'generate_self_signed_pg_server_certificate':
    command => "${datadir}/generate_self_signed_pg_server_certificate.sh $datadir $postgresql::server::user $postgresql::server::group '$certificate_subject' $certificate_days $force",
  }

}

