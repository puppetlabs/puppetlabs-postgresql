require 'digest/md5'
require 'parsedate'

Puppet::Type.type(:pg_role).provide(:pg_role) do

  desc "Manage users for a postgres database cluster"

  commands :psql => 'psql'
  commands :su => 'su'

  # generate getters for properties
  mk_resource_methods

  @@instances = nil

  def initialize(value={})
    super(value)

    @flush_query = []
    @flush_missing_roles = []
    @flush_additional_roles = []

    @pg_param_hash = {
      :superuser  => {:true => "SUPERUSER", :false=>"NOSUPERUSER"},
      :createdb => {:true => "CREATEDB", :false=>"NOCREATEDB"},
      :createrole => {:true => "CREATEROLE", :false=>"NOCREATEROLE"},
      :inherit => {:true => "INHERIT", :false=>"NOINHERIT"},
      :canlogin => {:true => "LOGIN", :false=>"NOLOGIN"},
      :replication => {:true => "REPLICATION", :false=>"NOREPLICATION"},
      :connection_limit => "CONNECTION LIMIT",
      :password => "ENCRYPTED PASSWORD",
      :valid_until => "VALID UNTIL",
      :inrole => "IN ROLE",
      :role => "ROLE",
    }
  end

  def run_psql(query)
    su("-", "postgres", "-c", "psql --quiet -A -t -c \"%s\"" % query)
  end

  def self.instances
    instances = []
    sql = "SELECT
            pg_authid.rolname,
            pg_authid.rolsuper,
            pg_authid.rolcreatedb,
            pg_authid.rolcreaterole,
            pg_authid.rolinherit,
            pg_authid.rolcanlogin,
            pg_authid.rolreplication,
            pg_authid.rolconnlimit,
            pg_authid.rolpassword,
            pg_authid.rolvaliduntil,
            (SELECT array_agg(groname) FROM pg_group WHERE pg_authid.oid = ANY(pg_group.grolist)) as rolgroups
          FROM pg_authid LEFT JOIN pg_group ON pg_authid.oid = pg_group.grosysid;"

    roles = su("-", "postgres", "-c", "psql --quiet -A -t -c \"%s\"" % sql)

    roles.each_line do |line|
      data = line.split('|')

      instances << new( :name => data[0],
                       :ensure => :present,
                       :superuser => data[1] == 't' ? :true : :false,
                       :createdb => data[2] == 't' ? :true : :false,
                       :createrole => data[3] == 't' ? :true : :false,
                       :inherit => data[4] == 't' ? :true : :false,
                       :canlogin => data[5] == 't' ? :true : :false,
                       :replication => data[6] == 't' ? :true : :false,
                       :connection_limit  => data[7],
                       :password  => data[8],
                       :valid_until => data[9].delete("\n"),
                       :inrole => data[10].delete("\n").delete("{").delete("}").split(",")
                      )
    end

    return instances
  end

  def self.prefetch(resources)
    @@instances = resources.values

    resources.keys.each do |name|
      if provider = instances.find{ |role| role.name == name }
        resources[name].provider = provider
      end
    end
  end

  def create
    stm = "CREATE ROLE %s WITH" % @resource.value(:name)

    stm << (@resource.value(:superuser).nil? ? '' : " " <<
            @pg_param_hash[:superuser][@resource.value(:superuser)])
    stm << (@resource.value(:createdb).nil? ? '' : " " <<
            @pg_param_hash[:createdb][@resource.value(:createdb)])
    stm << (@resource.value(:createrole).nil? ? '' : " " <<
            @pg_param_hash[:createrole][@resource.value(:createrole)])
    stm << (@resource.value(:inherit).nil? ? '' : " " <<
            @pg_param_hash[:inherit][@resource.value(:inherit)])
    stm << (@resource.value(:canlogin).nil? ? '' : " " <<
            @pg_param_hash[:canlogin][@resource.value(:canlogin)])
    stm << (@resource.value(:replication).nil? ? '' : " " <<
            @pg_param_hash[:replication][@resource.value(:replication)])
    stm << (@resource.value(:connection_limit).nil? ? '' : " " <<
            @pg_param_hash[:connection_limit] << " %s" % @resource.value(:connection_limit))

    if @resource.value(:password)
      password = 'md5' + Digest::MD5.hexdigest(@resource.value(:password) + @resource.value(:name))
      stm << " " << @pg_param_hash[:password] << " '%s'" % password
    end

      stm << (@resource.value(:valid_until).nil? ? '' : " " << @pg_param_hash[:valid_until] << " '%s'" % @resource.value(:valid_until))
      stm << (@resource.value(:inrole).nil? ? '' : " " << @pg_param_hash[:inrole] << " %s" % @resource.value(:inrole).join(", "))
    stm << (@resource.value(:role).nil? ? '' : " " << @pg_param_hash[:role] << " %s" % @resource.value(:role).join(", "))

    run_psql(stm)
    @property_hash[:ensure] = :present
  end

  def destroy
    run_psql("DELETE FROM pg_authid where rolname = '%s';" % @resource.value(:name))
    @property_hash.clear
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def flush
    return unless not @property_hash.empty?

    stm = "ALTER ROLE %s WITH" % resource[:name]

    @flush_query.each do |value|
      stm << " " << value
    end

    run_psql(stm)

    @flush_missing_roles.each { |group|
      run_psql("ALTER GROUP %s DROP USER %s" % [ group, resource[:name] ])
    }

    @flush_additional_roles.each { |group|
      run_psql("ALTER GROUP %s ADD USER %s" % [ group, resource[:name] ])
    }

    @property_hash = resource.to_hash
  end


  # Getters/setters for properties

  def superuser=(value)
    @flush_query << @pg_param_hash[:superuser][value]
  end

  def createdb=(value)
    @flush_query << @pg_param_hash[:createdb][value]
  end

  def createrole=(value)
    @flush_query << @pg_param_hash[:createrole][value]
  end

  def inherit=(value)
    @flush_query << @pg_param_hash[:inherit][value]
  end

  def canlogin=(value)
    @flush_query << @pg_param_hash[:canlogin][value]
  end

  def replication=(value)
    @flush_query << @pg_param_hash[:replication][value]
  end

  def connection_limit=(value)
    @flush_query << (@pg_param_hash[:connection_limit] << " %s" % value)
  end

  def password
    # if we are requesting via `puppet resource pg_role` - just return property_hash value
    if not @resource.value(:password)
      return @property_hash[:password]
    end

    password_hash = 'md5' + Digest::MD5.hexdigest(@resource.value(:password) + @resource.value(:name))

    # compare resource password or calculated hash from resource password with db value
    if @resource.value(:password) == @property_hash[:password] or password_hash == @property_hash[:password]
      return @resource.value(:password)
    end

    # no luck - password is different
    return @property_hash[:password]
  end

  def password=(value)
    @flush_query << (@pg_param_hash[:password] << " '%s'" % value)
  end

  def valid_until
    # Dates can be written in different formats. We need to parse and compare them.

    # if user doesn't set value for resource or database value is empty - return one found in database
    if not @resource.value(:valid_until) or @property_hash[:valid_until].empty?
      return @property_hash[:valid_until]
    end

    # parse user requested date and database value
    user_date = Time.mktime(*ParseDate.parsedate(@resource.value(:valid_until)))
    database_date = Time.mktime(*ParseDate.parsedate(@property_hash[:valid_until]))

    # return database value if dates are equal (do not trigger change)
    if user_date == database_date
      return @resource.value(:valid_until)
    end

    return @property_hash[:valid_until]
  end

  def valid_until=(value)
    @flush_query << (@pg_param_hash[:valid_until] << " '%s'" % value)
  end

  def inrole
    if not @resource.value(:inrole)
      return @property_hash[:inrole]
    end

    # compare arrays with element difference - sort is pricey.
    if (@resource.value(:inrole) - @property_hash[:inrole]).empty? and (@property_hash[:inrole] - @resource.value(:inrole)).empty?
      return  @resource.value(:inrole)
    end

    return @property_hash[:inrole]
  end

  def inrole=(value)
    @flush_missing_roles = @property_hash[:inrole] - @resource.value(:inrole)
    @flush_additional_roles =  @resource.value(:inrole) - @property_hash[:inrole]
  end

end
