# This has to be a separate type to enable collecting
Puppet::Type.newtype(:pg_user) do
  @doc = "Manage a Postgresql database user/role."

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
    desc "Role may log in, that is, this role can be given as the initial session authorization identifier."
    newvalues(:true, :false)
  end

  newproperty(:connlimit) do
    desc "If role can log in, this specifies how many concurrent connections the role can make. -1 (the default) means no limit."
  end

  newproperty(:password) do
    desc "Role's password"
  end

  newproperty(:validuntil) do
    desc "Sets a date and time after which the role's password is no longer valid"
  end

#  newproperty(:inrole) do
#    desc "Lists one or more existing roles to which the new role will be immediately added as a new member"
#  end
#
#  newproperty(:role) do
#    desc "Lists one or more existing roles which are automatically added as members of the new role. (This in effect makes the new role a 'group'.)"
#  end
#
#  newproperty(:admin) do
#    desc "Like ROLE, but the named roles are added to the new role WITH ADMIN OPTION, giving them the right to grant membership in this role to others"
#  end

end
