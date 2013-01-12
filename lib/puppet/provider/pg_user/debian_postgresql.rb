require 'digest/md5'

Puppet::Type.type(:pg_user).provide(:debian_postgresql) do

  desc "Manage users for a postgres database cluster"

  defaultfor :operatingsystem => [:debian, :ubuntu]

  commands :psql => 'psql'
  commands :su => 'su'

  # generate getters for properties
  mk_resource_methods

  def initialize(value={})
      super(value)

      @flush_query = []

      @pg_param_hash = {
          :superuser  => {:true => "SUPERUSER", :false=>"NOSUPERUSER"},
          :createdb   => {:true => "CREATEDB", :false=>"NOCREATEDB"},
          :createrole => {:true => "CREATEROLE", :false=>"NOCREATEROLE"},
          :inherit    => {:true => "INHERIT", :false=>"NOINHERIT"},
          :canlogin   => {:true => "LOGIN", :false=>"NOLOGIN"},
          :connlimit  => "CONNECTION LIMIT",
          :password   => "ENCRYPTED PASSWORD",
          :validuntil => "VALID UNTIL"
      }
  end


  def run_psql(query)
      su("-", "postgres", "-c", "psql --quiet -A -t -c \"%s\"" % query)
  end

  def self.instances
      instances = []
      roles = su("-", "postgres", "-c", "psql --quiet -A -t -c \"select rolname, rolsuper, rolcreatedb, rolcreaterole, rolinherit, rolcanlogin, rolconnlimit, rolpassword, rolvaliduntil from pg_authid;\"")

      roles.each_line do |line| 
          data = line.split('|')
          instances << new( :name      => data[0],
                           :ensure     => :present,
                           :superuser  => data[1] == 't' ? :true : :false,
                           :createdb   => data[2] == 't' ? :true : :false,
                           :createrole => data[3] == 't' ? :true : :false,
                           :inherit    => data[4] == 't' ? :true : :false,
                           :canlogin   => data[5] == 't' ? :true : :false,
                           :connlimit  => data[6],
                           :password   => data[7],
                           :validuntil => data[8]
          )
      end

      return instances
  end

  def self.prefetch(resources)
      resources.keys.each do |name|
        if provider = instances.find{ |role| role.name == name }
            resources[name].provider = provider
        end
      end
  end


  def create

    stm = "CREATE ROLE %s WITH" % @resource.value(:name)

    stm << (@resource.value(:superuser).nil? ? '' : " " << @pg_param_hash[:superuser][@resource.value(:superuser)])
    stm << (@resource.value(:createdb).nil? ? '' : " " << @pg_param_hash[:createdb][@resource.value(:createdb)])
    stm << (@resource.value(:createrole).nil? ? '' : " " << @pg_param_hash[:createrole][@resource.value(:createrole)])
    stm << (@resource.value(:inherit).nil? ? '' : " " << @pg_param_hash[:inherit][@resource.value(:inherit)])
    stm << (@resource.value(:canlogin).nil? ? '' : " " << @pg_param_hash[:canlogin][@resource.value(:canlogin)])
    stm << (@resource.value(:connlimit).nil? ? '' : " " << @pg_param_hash[:connlimit] << " %s" % @resource.value(:connlimit))

    if @resource.value(:password)
        password = 'md5' + Digest::MD5.hexdigest(@resource.value(:password) + @resource.value(:name))
        stm << " " << @pg_param_hash[:password] << " '%s'" % password
    end

    stm << (@resource.value(:validuntil).nil? ? '' : " " << @pg_param_hash[:validuntil] << " '%s'" % @resource.value(:validuntil))

    run_psql(stm)
    @property_hash[:ensure] = :present
  end

  def destroy
    su("-", "postgres", "-c", "dropuser %s" % [ @resource.value(:name) ])
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

  def connlimit=(value)
    @flush_query << (@pg_param_hash[:connlimit] << " %s" % value)
  end

  def password
      # if we are requesting via `puppet resource pg_user` - just return property_hash value
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

  def validuntil=(value)
    @flush_query << (@pg_param_hash[:validuntil] << " '%s'" % value)
  end

end
