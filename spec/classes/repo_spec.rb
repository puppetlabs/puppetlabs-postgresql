# frozen_string_literal: true

require 'spec_helper'

describe 'postgresql::repo' do
  include_examples 'Debian 11'

  describe 'with no parameters' do
    it 'instantiates apt_postgresql_org class' do
      expect(subject).to contain_class('postgresql::repo::apt_postgresql_org')
    end
  end
end
