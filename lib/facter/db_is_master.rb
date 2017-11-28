Facter.add('db_is_master') do
  setcode do
    Facter::Core::Execution.exec('sudo -u postgres psql -c "select pg_is_in_recovery();" | /bin/grep -qi "f" && echo "true" || echo "false"')
  end
end
