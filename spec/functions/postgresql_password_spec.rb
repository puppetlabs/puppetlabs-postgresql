require 'spec_helper'

describe 'postgresql::password' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(ArgumentError) }
  it { is_expected.to run.with_params('foo').and_raise_error(ArgumentError) }
  it { is_expected.to run.with_params('foo', 'bar', 'baz').and_raise_error(ArgumentError) }
  it { is_expected.to run.with_params('foo', 'bar').and_return('md596948aad3fcae80c08a35c9b5958cd89') }
  it { is_expected.to run.with_params('foo', 1234).and_return('md539a0e1b308278a8de5e007cd1f795920') }
end
