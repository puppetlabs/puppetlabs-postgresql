require 'spec_helper'

describe 'postgresql::server::config', type: :class do
  let(:pre_condition) do
    'class { postgresql::server: manage_selinux => true }'
  end

  describe 'on RedHat 7' do
    let(:facts) do
      {
        osfamily: 'RedHat',
        operatingsystem: 'CentOS',
        operatingsystemrelease: '7.0',
        concat_basedir: tmpfilename('server'),
        kernel: 'Linux',
        id: 'root',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        selinux: true,
        os: {
          'architecture' => 'x86_64',
          'family'       => 'RedHat',
          'hardware'     => 'x86_64',
          'name'         => 'CentOS',
          'release'      => {
            'full'  => '7.6.1810',
            'major' => '7',
            'minor' => '6',
          },
        },
      }
    end

    it 'has SELinux port defined' do
      is_expected.to contain_package('policycoreutils-python-utils') .with(ensure: 'present')

      is_expected.to contain_exec('/usr/sbin/semanage port -a -t postgresql_port_t -p tcp 5432')
        .with(unless: '/usr/sbin/semanage port -l | grep -qw 5432')
        .that_comes_before('Postgresql::Server::Config_entry[port]')
        .that_requires('Package[policycoreutils-python-utils]')
    end

    it 'has the correct systemd-override file' do
      is_expected.to contain_file('systemd-override').with(
        ensure: 'present', path: '/etc/systemd/system/postgresql.service',
        owner: 'root', group: 'root'
      )
    end
    it 'has the correct systemd-override file #content' do
      is_expected.to contain_file('systemd-override') \
        .with_content(%r{.include \/usr\/lib\/systemd\/system\/postgresql.service})
    end

    describe 'with manage_package_repo => true and a version' do
      let(:pre_condition) do
        <<-EOS
          class { 'postgresql::globals':
            manage_package_repo => true,
            version => '9.4',
          }->
          class { 'postgresql::server': }
        EOS
      end

      it 'has the correct systemd-override file' do
        is_expected.to contain_file('systemd-override').with(
          ensure: 'present', path: '/etc/systemd/system/postgresql-9.4.service',
          owner: 'root', group: 'root'
        )
      end
      it 'has the correct systemd-override file #regex' do
        is_expected.to contain_file('systemd-override') \
          .with_content(%r{.include \/usr\/lib\/systemd\/system\/postgresql-9.4.service})
      end
    end
  end

  describe 'on Fedora 21' do
    let(:facts) do
      {
        osfamily: 'RedHat',
        operatingsystem: 'Fedora',
        operatingsystemrelease: '21',
        concat_basedir: tmpfilename('server'),
        kernel: 'Linux',
        id: 'root',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        selinux: true,
        os: {
          'architecture' => 'x86_64',
          'family'       => 'RedHat',
          'hardware'     => 'x86_64',
          'name'         => 'Fedora',
          'release'      => {
            'full'  => '21',
            'major' => '21',
          },
        },
      }
    end

    it 'has SELinux port defined' do
      is_expected.to contain_package('policycoreutils-python-utils') .with(ensure: 'present')

      is_expected.to contain_exec('/usr/sbin/semanage port -a -t postgresql_port_t -p tcp 5432')
        .with(unless: '/usr/sbin/semanage port -l | grep -qw 5432')
        .that_comes_before('Postgresql::Server::Config_entry[port]')
        .that_requires('Package[policycoreutils-python-utils]')
    end

    it 'has the correct systemd-override file' do
      is_expected.to contain_file('systemd-override').with(
        ensure: 'present', path: '/etc/systemd/system/postgresql.service',
        owner: 'root', group: 'root'
      )
    end
    it 'has the correct systemd-override file #regex' do
      is_expected.to contain_file('systemd-override') \
        .with_content(%r{.include \/lib\/systemd\/system\/postgresql.service})
    end

    describe 'with manage_package_repo => true and a version' do
      let(:pre_condition) do
        <<-EOS
          class { 'postgresql::globals':
            manage_package_repo => true,
            version => '9.4',
          }->
          class { 'postgresql::server': }
        EOS
      end

      it 'has the correct systemd-override file' do
        is_expected.to contain_file('systemd-override').with(
          ensure: 'present', path: '/etc/systemd/system/postgresql-9.4.service',
          owner: 'root', group: 'root'
        )
      end
      it 'has the correct systemd-override file #regex' do
        is_expected.to contain_file('systemd-override') \
          .with_content(%r{.include \/lib\/systemd\/system\/postgresql-9.4.service})
      end
    end
  end

  describe 'on Amazon' do
    let :facts do
      {
        osfamily: 'RedHat',
        operatingsystem: 'Amazon',
        operatingsystemrelease: '1.0',
        concat_basedir: tmpfilename('server'),
        kernel: 'Linux',
        id: 'root',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        selinux: true,
      }
    end

    it 'has SELinux port defined' do
      is_expected.to contain_package('policycoreutils') .with(ensure: 'present')

      is_expected.to contain_exec('/usr/sbin/semanage port -a -t postgresql_port_t -p tcp 5432')
        .with(unless: '/usr/sbin/semanage port -l | grep -qw 5432')
        .that_comes_before('Postgresql::Server::Config_entry[port]')
        .that_requires('Package[policycoreutils]')
    end
  end

  describe 'on Gentoo' do
    let(:pre_condition) do
      <<-EOS
        class { 'postgresql::globals':
          version => '9.5',
        }->
        class { 'postgresql::server': }
      EOS
    end
    let(:facts) do
      {
        osfamily: 'Gentoo',
        operatingsystem: 'Gentoo',
        operatingsystemrelease: 'unused',
        concat_basedir: tmpfilename('server'),
        kernel: 'Linux',
        id: 'root',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        selinux: false,
      }
    end

    it 'does not have SELinux port defined' do
      is_expected.not_to contain_exec('/usr/sbin/semanage port -a -t postgresql_port_t -p tcp 5432')
    end

    it 'has the correct systemd-override file' do
      is_expected.to contain_file('systemd-override').with(
        ensure: 'present', path: '/etc/systemd/system/postgresql-9.5.service',
        owner: 'root', group: 'root'
      )
    end
    it 'has the correct systemd-override file #regex' do
      is_expected.to contain_file('systemd-override') \
        .with_content(%r{.include \/usr\/lib64\/systemd\/system\/postgresql-9.5.service})
    end
  end

  describe 'with managed pg_hba_conf and ipv4acls' do
    let(:pre_condition) do
      <<-EOS
        class { 'postgresql::globals':
          version => '9.5',
        }->
        class { 'postgresql::server':
          manage_pg_hba_conf => true,
          ipv4acls => [
            'hostnossl all all 0.0.0.0/0 reject',
            'hostssl all all 0.0.0.0/0 md5'
          ]
        }
      EOS
    end
    let(:facts) do
      {
        osfamily: 'RedHat',
        operatingsystem: 'CentOS',
        operatingsystemrelease: '7.0',
        concat_basedir: tmpfilename('server'),
        kernel: 'Linux',
        id: 'root',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        selinux: true,
      }
    end

    it 'has hba rule default' do
      is_expected.to contain_postgresql__server__pg_hba_rule('local access as postgres user')
    end
    it 'has hba rule ipv4acls' do
      is_expected.to contain_postgresql__server__pg_hba_rule('postgresql class generated rule ipv4acls 0')
    end
  end
end
