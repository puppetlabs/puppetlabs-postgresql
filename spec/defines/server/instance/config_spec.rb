# frozen_string_literal: true

require 'spec_helper'

describe 'postgresql::server::instance::config' do
  let(:title) { 'main' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let :facts do
        os_facts
      end

      let :pre_condition do
        "class {'postgresql::server':}"
      end

      context 'with defaults from config_class' do
        it {
          pending('Test needs aligining to current code, it was not running for some time')
          is_expected.to compile.with_all_deps
        }
      end
    end
  end
end
