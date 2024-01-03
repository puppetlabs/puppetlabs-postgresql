# @api private
class postgresql::repo::apt_postgresql_org inherits postgresql::repo {
  include apt

  # Here we have tried to replicate the instructions on the PostgreSQL site:
  #
  # http://www.postgresql.org/download/linux/debian/
  #
  $default_baseurl = 'https://apt.postgresql.org/pub/repos/apt/'
  $_baseurl = pick($postgresql::repo::baseurl, $default_baseurl)

  $default_release = "${facts['os']['distro']['codename']}-pgdg"
  $_release = pick($postgresql::repo::release, $default_release)

  apt::pin { 'apt_postgresql_org':
    originator => 'apt.postgresql.org',
    priority   => 500,
  }
  -> apt::source { 'apt.postgresql.org':
    location     => $_baseurl,
    release      => $_release,
    repos        => 'main',
    architecture => $facts['os']['architecture'],
    key          => {
      id     => 'B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8',
      source => 'https://www.postgresql.org/media/keys/ACCC4CF8.asc',
    },
    include      => {
      src => false,
    },
  }

  Apt::Source['apt.postgresql.org'] -> Package<|tag == 'puppetlabs-postgresql'|>
  Class['Apt::Update'] -> Package<|tag == 'puppetlabs-postgresql'|>
}
