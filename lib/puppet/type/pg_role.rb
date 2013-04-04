# This has to be a separate type to enable collecting
Puppet::Type.newtype(:pg_role) do
  @doc = "Manage a Postgresql database user/role."

  @@near_nodes = []

  ensurable

  newparam(:name, :namevar=>true) do
    desc "The name of the user/role"
  end

  newproperty(:superuser, :boolean => true) do
    desc "Role has superuser privileges"
    newvalues(:true, :false)
  end

  newproperty(:createdb, :boolean => true) do
    desc "Role may create databases"
    newvalues(:true, :false)
  end

  newproperty(:createrole, :boolean => true) do
    desc "Role may create more roles"
    newvalues(:true, :false)
  end

  newproperty(:inherit, :boolean => true) do
    desc "Role automatically inherits privileges of roles it is a member of"
    newvalues(:true, :false)
  end

  newproperty(:canlogin, :boolean => true) do
    desc "Role may log in, that is, this role can be given as the initial
    session authorization identifier."
    newvalues(:true, :false)
  end

  newproperty(:replication, :boolean => true) do
    desc "Role is allowed to initiate streaming replication
    or put the system in and out of backup mode"
    newvalues(:true, :false)
  end

  newproperty(:connection_limit) do
    desc "If role can log in, this specifies how many concurrent connections
    the role can make. -1 (the default) means no limit."
  end

  newproperty(:password) do
    desc "Role's password"
  end

  newproperty(:valid_until) do
    desc "Sets a date and time after which the role's
    password is no longer valid"
  end

 newproperty(:inrole, :array_matching => :all) do
    desc "Lists one or more existing roles to which
    the new role will be immediately added as a new member"
  end


  def graph_depth_walk(nodes, near_nodes)
    # Returns all nodes, avaliable from nodes.
    # near_nodes is hash where keys - name of nodes,
    # values - neighbour nodes.
    visited = []
    depth_sorted = []

    visit = lambda { |v|
      return if visited.include? v
      visited << v

      near_nodes[v].each {|v2|
        visit.call(v2)
      }

      depth_sorted << v
    }

    nodes.each { |key| visit.call(key) }
    return depth_sorted
  end

  autorequire(:pg_role) do
    # Each role can have dependencies in form of role or inrole.
    # Theese dependencies can have other dependenices.
    # To return all dependencies, we have to make a graph.

    # near_nodes is hash of each node with it's dependencies (neighbour nodes)
    if @@near_nodes.empty?
      near_nodes = Hash.new {|h,k| h[k] = [] }
      ObjectSpace.each_object(Puppet::Type::Pg_role) { |resource|

        if resource[:inrole]
          resource[:inrole].each { |inrole|
            near_nodes[resource[:name]].push(inrole)
          }
        end
      }
      @@near_nodes = near_nodes
    end

    # return dependencies for current resource (but without current)
    graph_depth_walk([self[:name]], @@near_nodes) - [self[:name]]
  end

end
