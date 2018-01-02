require 'spec_helper'

describe 'postgresql::escape' do

  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(ArgumentError) }
  it { is_expected.to run.with_params('foo', 'bar').and_raise_error(ArgumentError) }
  it { is_expected.to run.with_params('foo').and_return('$$foo$$') }
  it { is_expected.to run.with_params('fo$$o').and_return('$ed$fo$$o$ed$') }
  it { is_expected.to run.with_params('foo$').and_return('$a$foo$$a$') }
end
