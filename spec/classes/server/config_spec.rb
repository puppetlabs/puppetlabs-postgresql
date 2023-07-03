# frozen_string_literal: true

require 'spec_helper'

describe 'postgresql::server::config' do
  let(:pre_condition) do
    'class { postgresql::server: manage_selinux => true }'
  end

  describe 'on RedHat 7' do
    include_examples 'RedHat 7'

    it 'has SELinux port defined' do
      expect(subject).to contain_package('policycoreutils-python').with(ensure: 'installed')

      expect(subject).to contain_exec('/usr/sbin/semanage port -a -t postgresql_port_t -p tcp 5432')
        .with(unless: '/usr/sbin/semanage port -l | grep -qw 5432')
        .that_comes_before('Postgresql::Server::Config_entry[port_for_instance_main]')
        .that_requires('Package[policycoreutils-python]')
    end

    it 'has the correct systemd-override drop file' do
      expect(subject).to contain_file('/etc/systemd/system/postgresql.service.d/postgresql.conf').with(
        ensure: 'file', owner: 'root', group: 'root',
      ).that_requires('File[/etc/systemd/system/postgresql.service.d]')
    end

    it 'has the correct systemd-override file #regex' do
      expect(subject).to contain_file('/etc/systemd/system/postgresql.service.d/postgresql.conf')
    end

    describe 'with manage_package_repo => true and a version' do
      let(:pre_condition) do
        <<-EOS
          class { 'postgresql::globals':
            manage_package_repo => true,
            version => '10',
          }->
          class { 'postgresql::server': }
        EOS
      end

      it 'has the correct systemd-override file' do
        expect(subject).to contain_file('/etc/systemd/system/postgresql-10.service.d/postgresql-10.conf').with(
          ensure: 'file', owner: 'root', group: 'root',
        )
      end

      it 'has the correct systemd-override file #regex' do
        expect(subject).to contain_file('/etc/systemd/system/postgresql-10.service.d/postgresql-10.conf').without_content(%r{\.include})
      end
    end
  end

  describe 'on Redhat 8' do
    include_examples 'RedHat 8'

    it 'has SELinux port defined' do
      expect(subject).to contain_package('policycoreutils-python-utils').with(ensure: 'installed')

      expect(subject).to contain_exec('/usr/sbin/semanage port -a -t postgresql_port_t -p tcp 5432')
        .with(unless: '/usr/sbin/semanage port -l | grep -qw 5432')
        .that_comes_before('Postgresql::Server::Config_entry[port_for_instance_main]')
        .that_requires('Package[policycoreutils-python-utils]')
    end

    it 'has the correct systemd-override drop file' do
      expect(subject).to contain_file('/etc/systemd/system/postgresql.service.d/postgresql.conf').with(
        ensure: 'file', owner: 'root', group: 'root',
      ).that_requires('File[/etc/systemd/system/postgresql.service.d]')
    end

    it 'has the correct systemd-override file #regex' do
      expect(subject).to contain_file('/etc/systemd/system/postgresql.service.d/postgresql.conf').without_content(%r{\.include})
    end

    describe 'with manage_package_repo => true and a version' do
      let(:pre_condition) do
        <<-EOS
          class { 'postgresql::globals':
            manage_package_repo => true,
            version => '14',
          }->
          class { 'postgresql::server': }
        EOS
      end

      it 'has the correct systemd-override file' do
        expect(subject).to contain_file('/etc/systemd/system/postgresql-14.service.d/postgresql-14.conf').with(
          ensure: 'file', owner: 'root', group: 'root',
        )
      end

      it 'has the correct systemd-override file #regex' do
        expect(subject).to contain_file('/etc/systemd/system/postgresql-14.service.d/postgresql-14.conf').without_content(%r{\.include})
      end
    end
  end

  describe 'on Fedora 33' do
    include_examples 'Fedora 33'

    it 'has SELinux port defined' do
      expect(subject).to contain_package('policycoreutils-python-utils').with(ensure: 'installed')

      expect(subject).to contain_exec('/usr/sbin/semanage port -a -t postgresql_port_t -p tcp 5432')
        .with(unless: '/usr/sbin/semanage port -l | grep -qw 5432')
        .that_comes_before('Postgresql::Server::Config_entry[port_for_instance_main]')
        .that_requires('Package[policycoreutils-python-utils]')
    end

    it 'has the correct systemd-override drop file' do
      expect(subject).to contain_file('/etc/systemd/system/postgresql.service.d/postgresql.conf').with(
        ensure: 'file', owner: 'root', group: 'root',
      ).that_requires('File[/etc/systemd/system/postgresql.service.d]')
    end

    it 'has the correct systemd-override file #regex' do
      expect(subject).to contain_file('/etc/systemd/system/postgresql.service.d/postgresql.conf').without_content(%r{\.include})
    end

    describe 'with manage_package_repo => true and a version' do
      let(:pre_condition) do
        <<-EOS
          class { 'postgresql::globals':
            manage_package_repo => true,
            version => '13',
          }->
          class { 'postgresql::server': }
        EOS
      end

      it 'has the correct systemd-override file' do
        expect(subject).to contain_file('/etc/systemd/system/postgresql-13.service.d/postgresql-13.conf').with(
          ensure: 'file', owner: 'root', group: 'root',
        )
      end

      it 'has the correct systemd-override file #regex' do
        expect(subject).to contain_file('/etc/systemd/system/postgresql-13.service.d/postgresql-13.conf').without_content(%r{\.include})
      end
    end
  end

  describe 'on Amazon' do
    include_examples 'Amazon 1'

    it 'has SELinux port defined' do
      expect(subject).to contain_package('policycoreutils').with(ensure: 'installed')

      expect(subject).to contain_exec('/usr/sbin/semanage port -a -t postgresql_port_t -p tcp 5432')
        .with(unless: '/usr/sbin/semanage port -l | grep -qw 5432')
        .that_comes_before('Postgresql::Server::Config_entry[port_for_instance_main]')
        .that_requires('Package[policycoreutils]')
    end
  end

  describe 'with managed pg_hba_conf and ipv4acls' do
    include_examples 'RedHat 7'
    let(:pre_condition) do
      <<-EOS
        class { 'postgresql::globals':
          version => '14',
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

    it 'has hba rule default' do
      expect(subject).to contain_postgresql__server__pg_hba_rule('local access as postgres user for instance main')
    end

    it 'has hba rule ipv4acls' do
      expect(subject).to contain_postgresql__server__pg_hba_rule('postgresql class generated rule ipv4acls 0')
    end
  end

  describe 'on Gentoo' do
    include_examples 'Gentoo'

    describe 'with systemd' do
      let(:facts) { super().merge(service_provider: 'systemd') }
      let(:pre_condition) do
        <<-EOS
          class { 'postgresql::globals':
            version => '14',
          }->
          class { 'postgresql::server': }
        EOS
      end

      it 'does not have SELinux port defined' do
        expect(subject).not_to contain_exec('/usr/sbin/semanage port -a -t postgresql_port_t -p tcp 5432')
      end

      it 'has the correct systemd-override drop file' do
        expect(subject).to contain_file('/etc/systemd/system/postgresql-14.service.d/postgresql-14.conf').with(
          ensure: 'file', owner: 'root', group: 'root',
        )
      end
    end
  end
end
