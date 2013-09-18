require 'spec_helper_system'

describe 'postgresql::lib::python:' do
  after :all do
    # Cleanup after tests have ran
    puppet_apply("class { 'postgresql::lib::python': package_ensure => purged }") do |r|
      r.exit_code.should_not == 1
    end
  end

  it 'test loading class with no parameters' do
    pending('psycopg2 not available natively for centos 5', :if => (node.facts['osfamily'] == 'RedHat' and node.facts['lsbmajdistrelease'] == '5'))

    pp = <<-EOS.unindent
      class { 'postgresql::lib::python': }
    EOS

    puppet_apply(pp) do |r|
      r.exit_code.should_not == 1
      r.refresh
      r.exit_code.should == 0
    end
  end
end
