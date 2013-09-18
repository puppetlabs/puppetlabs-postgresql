require 'spec_helper_system'

describe 'postgresql::lib::devel:' do
  after :all do
    # Cleanup after tests have ran
    puppet_apply("class { 'postgresql::lib::devel': package_ensure => purged }") do |r|
      r.exit_code.should_not == 1
    end
  end

  it 'test loading class with no parameters' do
    pp = <<-EOS.unindent
      class { 'postgresql::lib::devel': }
    EOS

    puppet_apply(pp) do |r|
      r.exit_code.should_not == 1
      r.refresh
      r.exit_code.should == 0
    end
  end
end
