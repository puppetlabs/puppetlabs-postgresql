require 'spec_helper'

describe 'postgresql', :type => :class do
  let :facts do
    {
      :postgres_default_version => '8.4',
      :osfamily => 'Debian',
    }
  end
  it { should include_class("postgresql") }
end
