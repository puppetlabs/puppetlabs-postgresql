# frozen_string_literal: true

require 'spec_helper'

describe 'postgresql_password' do
  include_examples 'Ubuntu 18.04'

  it_behaves_like 'postgresql_password function'
end
