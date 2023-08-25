# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'postgresql::server::reassign_owned_by:' do
  let(:db) { 'reassign_test' }
  let(:old_owner) { 'psql_reassign_old_owner' }
  let(:new_owner) { 'psql_reassign_new_owner' }
  let(:password) { 'psql_reassign_pw' }
  let(:superuser) { 'postgres' }

  let(:pp_setup) do
    <<-MANIFEST.unindent
      $db = #{db}
      $old_owner = #{old_owner}
      $new_owner = #{new_owner}
      $password = #{password}

      class { 'postgresql::server': }

      postgresql::server::role { $old_owner:
        password_hash => postgresql::postgresql_password($old_owner, $password),
      }

      # Since we are not testing pg_hba or any of that, make a local user for ident auth
      user { $old_owner:
        ensure => present,
      }

      # Create a user to reassign ownership to
      postgresql::server::role { $new_owner:
        db      => $db,
        require => Postgresql::Server::Database[$db],
      }

      # Make a local user for ident auth
      user { $new_owner:
        ensure => present,
      }

      # Grant the new owner membership of the old owner (must have both for REASSIGN OWNED BY to work)
      postgresql::server::grant_role { "grant_role to ${new_owner}":
        role  => $new_owner,
        group => $old_owner,
      }

      # Grant them connect to the database
      postgresql::server::database_grant { "allow connect for ${old_owner}":
        privilege => 'CONNECT',
        db        => $db,
        role      => $old_owner,
      }
    MANIFEST
  end

  let(:pp_db_old_owner) do
    <<-MANIFEST.unindent
      postgresql::server::database { $db:
        owner   => $old_owner,
        require => Postgresql::Server::Role[$old_owner],
      }
    MANIFEST
  end

  let(:pp_db_no_owner) do
    <<-MANIFEST.unindent
      postgresql::server::database { $db:
      }
    MANIFEST
  end

  context 'reassign_owned_by' do
    describe 'REASSIGN OWNED BY tests' do
      let(:db) { 'reassign_test' }
      let(:old_owner) { 'psql_reassign_old_owner' }
      let(:new_owner) { 'psql_reassign_new_owner' }

      let(:pp_setup_objects) do
        <<-MANIFEST.unindent
          postgresql_psql { 'create test table':
            command   => 'CREATE TABLE test_tbl (col1 integer)',
            db        => '#{db}',
            psql_user => '#{old_owner}',
            unless    => "SELECT tablename FROM pg_catalog.pg_tables WHERE tablename = 'test_tbl'",
            require   => Postgresql::Server::Database['#{db}'],
          }
          postgresql_psql { 'create test sequence':
            command   => 'CREATE SEQUENCE test_seq',
            db        => '#{db}',
            psql_user => '#{old_owner}',
            unless    => "SELECT relname FROM pg_catalog.pg_class WHERE relkind='S' AND relname = 'test_seq'",
            require   => [ Postgresql_psql['create test table'], Postgresql::Server::Database['#{db}'] ],
          }
        MANIFEST
      end
      let(:pp_reassign_owned_by) do
        <<-MANIFEST.unindent
          postgresql::server::reassign_owned_by { 'test reassign to new_owner':
            db          => '#{db}',
            old_role    => '#{old_owner}',
            new_role    => '#{new_owner}',
            psql_user   => '#{new_owner}',
          }
        MANIFEST
      end

      it 'reassigns all objects to new_owner' do
        if Gem::Version.new(postgresql_version) >= Gem::Version.new('9.0')
          apply_manifest(pp_setup + pp_db_old_owner + pp_setup_objects, catch_failures: true)

          idempotent_apply(pp_setup + pp_db_no_owner + pp_reassign_owned_by)

          ## Check that the ownership was transferred
          psql("-d #{db} --tuples-only --no-align --command=\"SELECT tablename,tableowner FROM pg_catalog.pg_tables WHERE schemaname NOT IN ('pg_catalog', 'information_schema')\"", superuser) do |r|
            expect(r.stdout).to match(%r{test_tbl.#{new_owner}})
            expect(r.stderr).to eq('')
          end
          psql("-d #{db} --tuples-only --no-align --command=\"SELECT relname,pg_get_userbyid(relowner) FROM pg_catalog.pg_class c WHERE relkind='S'\"", superuser) do |r|
            expect(r.stdout).to match(%r{test_seq.#{new_owner}})
            expect(r.stderr).to eq('')
          end
          if Gem::Version.new(postgresql_version) >= Gem::Version.new('9.3')
            psql("-d #{db} --tuples-only --no-align --command=\"SELECT pg_get_userbyid(datdba) FROM pg_database WHERE datname = current_database()\"", superuser) do |r|
              expect(r.stdout).to match(%r{#{new_owner}})
              expect(r.stderr).to eq('')
            end
          end
        end
      end # it should reassign all objects
    end
  end
  #####################
end
