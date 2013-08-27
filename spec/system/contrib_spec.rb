require 'spec_helper_system'

describe 'postgresql::contrib:' do
  after :all do
    # Cleanup after tests have ran
    puppet_apply("class { 'postgresql::contrib': package_ensure => absent }") do |r|
      r.exit_code.should_not == 1
    end
  end

  it 'test loading class with no parameters' do
    pp = <<-EOS
      class { 'postgresql::contrib': }
    EOS

    puppet_apply(pp) do |r|
      r.exit_code.should_not == 1
      r.refresh
      r.exit_code.should == 0
    end
  end
end
