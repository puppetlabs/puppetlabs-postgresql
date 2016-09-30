# PRIVATE CLASS: do not use directly
class postgresql::repo::download_postgresql_org inherits postgresql::repo {
  $version_parts   = split($postgresql::repo::version, '[.]')
  $package_version = "${version_parts[0]}${version_parts[1]}"
  $gpg_key_path    = "/etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG-${package_version}"

  file { $gpg_key_path:
    source => 'puppet:///modules/postgresql/RPM-GPG-KEY-PGDG',
    before => Yumrepo['download.postgresql.org']
  }

  if($::operatingsystem == 'Fedora') {
    $label1 = 'fedora'
    $label2 = $label1
  } else {
    $label1 = 'redhat'
    $label2 = 'rhel'
  }
  $default_baseurl = "https://download.postgresql.org/pub/repos/yum/${postgresql::repo::version}/${label1}/${label2}-\$releasever-\$basearch"

  $baseurl_real = pick($postgresql::repo::baseurl,$default_baseurl,'undefined')
  if ( $baseurl_real == 'undefined' ){
    fail('No repo baseurl defined or automatically detected.')
  }

  yumrepo { 'download.postgresql.org':
    descr    => "PostgreSQL ${postgresql::repo::version} \$releasever - \$basearch",
    baseurl  => $baseurl_real,
    enabled  => 1,
    gpgcheck => 1,
    gpgkey   => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG-${package_version}",
    proxy    => $postgresql::repo::proxy,
  }

  Yumrepo['download.postgresql.org'] -> Package<|tag == 'postgresql'|>
}
