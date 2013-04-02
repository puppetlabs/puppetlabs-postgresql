class postgresql::package_source::apt_postgresql_org (
  $mirror
) {
  # Here we have tried to replicate the instructions on the PostgreSQL site:
  #
  # http://www.postgresql.org/download/linux/debian/
  #
  apt::pin { 'apt.postgresql.org':
    originator => $mirror,
    priority   => 500,
  }->
  apt::source { 'apt.postgresql.org':
    location          => "${mirror}/pub/repos/apt/",
    release           => "${::lsbdistcodename}-pgdg",
    repos             => 'main',
    required_packages => 'pgdg-keyring',
    key               => 'ACCC4CF8',
    key_source        => "${mirror}/pub/repos/apt/ACCC4CF8.asc",
    include_src       => false,
  }

  Apt::Source['apt.postgresql.org']->Package<|tag == 'postgresql'|>
}
