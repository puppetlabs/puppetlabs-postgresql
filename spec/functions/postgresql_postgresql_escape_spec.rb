# frozen_string_literal: true

require 'spec_helper'

describe 'postgresql::postgresql_escape' do
  it_behaves_like 'postgresql_escape function'
end
