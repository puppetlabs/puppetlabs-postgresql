require 'spec_helper_system'

describe 'server plperl:' do
  after :all do
    # Cleanup after tests have ran
    pp = <<-EOS.unindent
      class { 'postgresql::server': ensure => absent }
      class { 'postgresql::server::plperl': package_ensure => purged }
    EOS
    puppet_apply(pp) do |r|
      r.exit_code.should_not == 1
    end
  end

  it 'test loading class with no parameters' do
    pending('no support for plperl with default version on centos 5',
      :if => (node.facts['osfamily'] == 'RedHat' and node.facts['lsbmajdistrelease'] == '5'))
    pp = <<-EOS.unindent
      class { 'postgresql::server': }
      class { 'postgresql::server::plperl': }
    EOS

    puppet_apply(pp) do |r|
      r.exit_code.should_not == 1
      r.refresh
      r.exit_code.should == 0
    end
  end
end
