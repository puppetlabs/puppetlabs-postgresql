require 'spec_helper_acceptance'

describe 'postgresql::server::config_entry' do

  let(:pp_setup) { <<-EOS
    class { 'postgresql::server':
      postgresql_conf_path => '/tmp/postgresql.conf',
      }
    EOS
  }

  context 'unix_socket_directories' do
    let(:pp_test) { pp_setup + <<-EOS
      postgresql::server::config_entry { 'unix_socket_directories':
        value => '/var/socket/, /root/'
      }
      EOS
    }

    #get postgresql version
    apply_manifest("class { 'postgresql::server': }")
    result = shell('psql --version')
    version = result.stdout.match(%r{\s(\d\.\d)})[1]

binding.pry
    if version >= '9.3'
      it 'moving postgresql.conf will trigger a service refresh' do
        apply_manifest(pp_test, :catch_failures => true)
binding.pry
        apply_manifest(pp_test, :catch_changes => false)
binding.pry
        apply_manifest(pp_test, :catch_changes => false)
      end

      it 'is expected to contain directories' do
        shell('cat /tmp/postgresql.conf') do |output|
          expect(output.stdout).to contain("unix_socket_directories = '/var/socket/, /root/'")
        end
      end
    end
  end
end
