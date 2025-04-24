# frozen_string_literal: true

require 'spec_helper'

describe 'postgresql::server::instance::late_initdb' do
  let(:title) { 'main' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let :facts do
        os_facts
      end

      let :pre_condition do
        "class {'postgresql::initdb':}"
      end

      context 'with defaults from initdb class' do
        it {
          pending('Test needs aligining to current code, it was not running for some time')
          is_expected.to compile.with_all_deps
        }
      end
    end
  end
end
