require 'spec_helper'

describe 'postgresql::client', :type => :class do
  let :facts do
    {
      :osfamily => 'Debian',
      :operatingsystem => 'Debian',
      :operatingsystemrelease => '6.0',
    }
  end

  describe 'with parameters' do
    let :params do
      {
        :validcon_script_path => '/opt/bin/my-validate-con.sh',
        :package_ensure       => 'absent',
        :package_name         => 'mypackage',
        :file_ensure          => 'file'
        :validate_connections => { 'test' => {
                                               :database_host => 'test',
                                               :database_name => 'test',
                                               :database_password => 'test',
                                               :database_username => 'test',
                                               :database_port => 5432,
                                               :run_as => 'postgresq',
                                               :sleep => 4,
                                               :tries => 30,
                                             } }
      }
    end

    it 'should modify package' do
      is_expected.to contain_package("postgresql-client").with({
        :ensure => 'absent',
        :name => 'mypackage',
        :tag => 'postgresql',
      })
    end

    it 'should have specified validate connexion' do
      should contain_file('/opt/bin/my-validate-con.sh').with({
        :ensure => 'file',
        :owner  => 0,
        :group  => 0,
        :mode   => '0755'
      })

    it { is_expected.to contain_postgresql__validate_db_connection('test') }

    end
  end

  describe 'with no parameters' do
    it 'should create package with postgresql tag' do
      is_expected.to contain_package('postgresql-client').with({
        :tag => 'postgresql',
      })
    end
  end
end
