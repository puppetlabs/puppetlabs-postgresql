Puppet::Type.type(:postgresql_replication_slot).provide(:ruby) do
  # For confinement
  commands psql: 'psql'

  def self.instances
    run_sql_command('SELECT * FROM pg_replication_slots;')[0].split("\n").select { |l| l =~ %r{\|} }.map do |l|
      name, *_others = l.strip.split(%r{\s+\|\s+})
      new(name: name,
          ensure: :present)
    end
  end

  def self.prefetch(resources)
    instances.each do |i|
      slot = resources[i.name]
      if slot
        slot.provider = i
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    output = self.class.run_sql_command("SELECT * FROM pg_create_physical_replication_slot('#{resource[:name]}');")
    raise Puppet::Error, "Failed to create replication slot #{resource[:name]}:\n#{output[0]}" unless output[1].success?
    @property_hash[:ensure] = :present
  end

  def destroy
    output = self.class.run_sql_command("SELECT pg_drop_replication_slot('#{resource[:name]}');")
    raise Puppet::Error, "Failed to destroy replication slot #{resource[:name]}:\n#{output[0]}" unless output[1].success?
    @property_hash[:ensure] = :absent
  end

  private

  def self.run_sql_command(sql)
    command = ['psql', '-t', '-c', sql]

    run_command(command, 'postgres', 'postgres')
  end

  def self.run_command(command, user, group)
    if Puppet::PUPPETVERSION.to_f < 3.4
      Puppet::Util::SUIDManager.run_and_capture(command, user, group)
    else
      output = Puppet::Util::Execution.execute(command, uid: user,
                                                        gid: group,
                                                        failonfail: false,
                                                        combine: true,
                                                        override_locale: true,
                                                        custom_environment: {})
      [output, $CHILD_STATUS.dup]
    end
  end
end
