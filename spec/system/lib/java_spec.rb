require 'spec_helper_system'

describe 'postgresql::lib::java:' do
  after :all do
    # Cleanup after tests have ran
    puppet_apply("class { 'postgresql::lib::java': package_ensure => purged }") do |r|
      r.exit_code.should_not == 1
    end
  end

  it 'test loading class with no parameters' do
    pending('libpostgresql-java-jdbc not available natively for Ubuntu 10.04 and Debian 6',
      :if => (node.facts['osfamily'] == 'Debian' and ['6', '10'].include?(node.facts['lsbmajdistrelease'])))

    pp = <<-EOS.unindent
      class { 'postgresql::lib::java': }
    EOS

    puppet_apply(pp) do |r|
      r.exit_code.should_not == 1
      r.refresh
      r.exit_code.should == 0
    end
  end
end
