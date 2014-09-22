
# http://blog.roomthirteen.de/2013/01/07/solved-installing-postgresql-on-ubuntu-12-04/

class postgresql::server::ssl_certificate {

  $days         = $postgresql::server::cerificate_days
  $country      = $postgresql::server::cerificate_country
  $state        = $postgresql::server::certificate_state
  $locality     = $postgresql::server::certificate_locality
  $organization = $postgresql::server::certificate_organization
  $common_name  = $postgresql::server::certificate_common_name
  $email        = $postgresql::server::certificate_email

  # /C=CA/ST=British Columbia/L=Comox/O=TheBrain.ca/CN=thebrain.ca/emailAddress=info@thebrain.ca'
  $subject = "/C=${country}/ST=${state}/L=${locality}/O=${organization}/CN=${common_name}/emailAddress=${email}" 

  $err_prefix = "Module postgresql::server::ssl_certificate unable to create server certificate: please specify a value for postgresql::server::certificate_"
  if ($days == undef) { fail("${err_prefix}days") }
  if ($country == undef) { fail("${err_prefix}country") }
  if ($state == undef) { fail("${err_prefix}state") }
  if ($locality == undef) { fail("${err_prefix}locality") }
  if ($organization == undef) { fail("${err_prefix}organization") }
  if ($common_name == undef) { fail("${err_prefix}common_name") }
  if ($email == undef) { fail("${err_prefix}email") }

  file { [ "$postgresql::params::postgresql_conf_path/server.crt",
           "$postgresql::params::postgresql_conf_path/server.key" ]:
    ensure => absent,
  }

  exec { 'generate_self_signed_pg_server_certificate':
        cwd => "$postgresql::params::postgresql_conf_path",
    command => "/usr/bin/openssl genrsa -des3 -passout pass:puppetlabs-postgresql -out trash.key 1024
                /usr/bin/openssl rsa -passin pass:puppetlabs-postgresql -in trash.key -out trash.key 
                /usr/bin/openssl req -new -key trash.key -days $days -out trash.cert -x509 $subject 
                /bin/cp server.crt root.crt ",
  }

  file { "$postgresql::params::postgresql_conf_path/server.key":
    ensure => file,
      mode => '0400',
      user => $postgresql::server::user,
     group => $postgresql::server::group, 
  }

}

