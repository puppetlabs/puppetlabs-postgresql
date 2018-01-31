require 'spec_helper_acceptance'

describe 'postgresql_psql', unless: UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do
  pp_one = <<-MANIFEST
    class { 'postgresql::server': } ->
    postgresql_psql { 'foobar':
      db        => 'postgres',
      psql_user => 'postgres',
      command   => 'select 1',
    }
  MANIFEST
  it 'alwayses run SQL' do
    apply_manifest(pp_one, catch_failures: true)
    apply_manifest(pp_one, expect_changes: true)
  end

  pp_two = <<-MANIFEST
    class { 'postgresql::server': } ->
    postgresql_psql { 'foobar':
      db        => 'postgres',
      psql_user => 'postgres',
      command   => 'select 1',
      unless    => 'select 1 where 1=2',
    }
  MANIFEST
  it 'runs some SQL when the unless query returns no rows' do
    apply_manifest(pp_two, catch_failures: true)
    apply_manifest(pp_two, expect_changes: true)
  end

  pp_three = <<-MANIFEST
    class { 'postgresql::server': } ->
    postgresql_psql { 'foobar':
      db        => 'postgres',
      psql_user => 'postgres',
      command   => 'select * from pg_database limit 1',
      unless    => 'select 1 where 1=1',
    }
  MANIFEST
  it 'does not run SQL when the unless query returns rows' do
    apply_manifest(pp_three, catch_failures: true)
    apply_manifest(pp_three, catch_changes: true)
  end

  pp_four = <<-MANIFEST
    class { 'postgresql::server': } ->
    notify { 'trigger': } ~>
    postgresql_psql { 'foobar':
      db        => 'postgres',
      psql_user => 'postgres',
      command   => 'invalid sql statement',
      unless    => 'select 1 where 1=1',
    }
  MANIFEST
  it 'does not run SQL when refreshed and the unless query returns rows' do
    apply_manifest(pp_four, catch_failures: true)
    apply_manifest(pp_four, expect_changes: true)
  end

  context 'with refreshonly' do
    pp_five = <<-MANIFEST
      class { 'postgresql::server': } ->
      postgresql_psql { 'foobar':
        db          => 'postgres',
        psql_user   => 'postgres',
        command     => 'select 1',
        unless      => 'select 1 where 1=2',
        refreshonly => true,
      }
    MANIFEST
    it 'does not run SQL when the unless query returns no rows' do
      apply_manifest(pp_five, catch_failures: true)
      apply_manifest(pp_five, catch_changes: true)
    end

    pp_six = <<-MANIFEST.unindent
      class { 'postgresql::server': } ->
      notify { 'trigger': } ~>
      postgresql_psql { 'foobar':
        db          => 'postgres',
        psql_user   => 'postgres',
        command     => 'select 1',
        unless      => 'select 1 where 1=2',
        refreshonly => true,
      }
    MANIFEST
    it 'runs SQL when refreshed and the unless query returns no rows' do
      apply_manifest(pp_six, catch_failures: true)
      apply_manifest(pp_six, expect_changes: true)
    end

    pp_seven = <<-MANIFEST.unindent
      class { 'postgresql::server': } ->
      notify { 'trigger': } ~>
      postgresql_psql { 'foobar':
        db          => 'postgres',
        psql_user   => 'postgres',
        command     => 'invalid sql query',
        unless      => 'select 1 where 1=1',
        refreshonly => true,
      }
    MANIFEST
    it 'does not run SQL when refreshed and the unless query returns rows' do
      apply_manifest(pp_seven, catch_failures: true)
      apply_manifest(pp_seven, expect_changes: true)
    end
  end

  pp_eight = <<-MANIFEST
    class { 'postgresql::server': } ->
    postgresql_psql { 'foobar':
      db        => 'postgres',
      psql_user => 'postgres',
      command   => 'select 1',
      onlyif    => 'select 1 where 1=2',
    }
  MANIFEST
  it 'does not run some SQL when the onlyif query returns no rows' do
    apply_manifest(pp_eight, catch_failures: true)
    apply_manifest(pp_eight, catch_changes: true)
  end

  pp_nine = <<-MANIFEST
    class { 'postgresql::server': } ->
    postgresql_psql { 'foobar':
      db        => 'postgres',
      psql_user => 'postgres',
      command   => 'select * from pg_database limit 1',
      onlyif    => 'select 1 where 1=1',
    }
  MANIFEST
  it 'runs SQL when the onlyif query returns rows' do
    apply_manifest(pp_nine, catch_failures: true)
    apply_manifest(pp_nine, expect_changes: true)
  end

  context 'with secure password passing by environment' do
    it 'runs SQL that contanins password passed by environment' do # rubocop:disable RSpec/ExampleLength
      select = "select \\'$PASS_TO_EMBED\\'"
      pp = <<-MANIFEST.unindent
        class { 'postgresql::server': } ->
        postgresql_psql { 'password embedded by environment: #{select}':
          db          => 'postgres',
          psql_user   => 'postgres',
          command     => '#{select}',
          environment => [
            'PASS_TO_EMBED=pa$swD',
          ],
        }
      MANIFEST
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, expect_changes: false)
    end
    it 'runs SQL that contanins password passed by environment in check' do # rubocop:disable RSpec/ExampleLength
      select = "select 1 where \\'$PASS_TO_EMBED\\'=\\'passwD\\'"
      pp = <<-MANIFEST.unindent
        class { 'postgresql::server': } ->
        postgresql_psql { 'password embedded by environment in check: #{select}':
          db          => 'postgres',
          psql_user   => 'postgres',
          command     => 'invalid sql query',
          unless      => '#{select}',
          environment => [
            'PASS_TO_EMBED=passwD',
          ],
        }
      MANIFEST

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, expect_changes: false)
    end
  end
end
