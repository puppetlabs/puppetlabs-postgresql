# frozen_string_literal: true

require 'spec_helper'

describe 'postgresql::lib::perl' do
  describe 'on redhat 8' do
    include_examples 'RedHat 8'

    it {
      is_expected.to contain_package('perl-DBD-Pg').with(
        name: 'perl-DBD-Pg',
        ensure: 'present',
      )
    }
  end

  describe 'on debian 11' do
    include_examples 'Debian 11'

    it {
      is_expected.to contain_package('perl-DBD-Pg').with(
        name: 'libdbd-pg-perl',
        ensure: 'present',
      )
    }
  end
end
