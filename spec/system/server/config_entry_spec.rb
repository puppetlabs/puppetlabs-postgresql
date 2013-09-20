require 'spec_helper_system'

describe 'postgresql::server::config_entry:' do
  after :all do
    # Cleanup after tests have ran
    puppet_apply("class { 'postgresql::server': ensure => absent }") do |r|
      r.exit_code.should_not == 1
    end
  end

  it 'should change setting and reflect it in show all' do
    pp = <<-EOS.unindent
      class { 'postgresql::server': }

      postgresql::server::config_entry { 'check_function_bodies':
        value => 'off',
      }
    EOS

    puppet_apply(pp) do |r|
      r.exit_code.should_not == 1
      r.refresh
      r.exit_code.should == 0
    end

    psql('--command="show all" postgres') do |r|
      r.stdout.should =~ /check_function_bodies.+off/
      r.stderr.should be_empty
      r.exit_code.should == 0
    end
  end
end
