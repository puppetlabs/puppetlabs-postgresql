
describe 'postgresql::server::grant', :type => :define do
  let :facts do
    {
      :osfamily => 'Debian',
      :operatingsystem => 'Debian',
      :operatingsystemrelease => '6.0',
      :kernel => 'Linux',
      :concat_basedir => tmpfilename('contrib'),
      :id => 'root',
      :path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    }
  end

  let :title do
    'test'
  end

  let :params do
    {
      :db => 'test',
      :role => 'test',
      :connect_settings => {},
    }
  end

  let :pre_condition do
    "class {'postgresql::server':}"
  end

  it { is_expected.to contain_postgresql__server__grant('test') }
  it { is_expected.to contain_postgresql_psql("grant:test").with_connect_settings( {} ).with_port( 5432 ) }

  context "with specific db connection settings - default port" do
    let :params do
      {
        :db => 'test',
        :role => 'test',
        :connect_settings => { 'PGHOST'    => 'postgres-db-server',
                               'DBVERSION' => '9.1', },
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    it { is_expected.to contain_postgresql__server__grant('test') }
    it { is_expected.to contain_postgresql_psql("grant:test").with_connect_settings( { 'PGHOST'    => 'postgres-db-server','DBVERSION' => '9.1' } ).with_port( 5432 ) }
  end

  context "with specific db connection settings - including port" do
    let :params do
      {
        :db => 'test',
        :role => 'test',
        :connect_settings => { 'PGHOST'    => 'postgres-db-server',
                               'DBVERSION' => '9.1',
			       'PGPORT'    => '1234', },
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    it { is_expected.to contain_postgresql__server__grant('test') }
    it { is_expected.to contain_postgresql_psql("grant:test").with_connect_settings( { 'PGHOST'    => 'postgres-db-server','DBVERSION' => '9.1','PGPORT'    => '1234' } ).with_port( nil ) }
  end

  context "with specific db connection settings - port overriden by explicit parameter" do
    let :params do
      {
        :db => 'test',
        :role => 'test',
        :connect_settings => { 'PGHOST'    => 'postgres-db-server',
                               'DBVERSION' => '9.1',
			       'PGPORT'    => '1234', },
        :port => '5678',
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    it { is_expected.to contain_postgresql__server__grant('test') }
    it { is_expected.to contain_postgresql_psql("grant:test").with_connect_settings( { 'PGHOST'    => 'postgres-db-server','DBVERSION' => '9.1','PGPORT'    => '1234' } ).with_port( '5678' ) }
  end
end
