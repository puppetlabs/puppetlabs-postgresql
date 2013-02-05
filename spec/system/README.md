Warning: these spec tests are pretty resource intensive!

You will need the following in order to run them:

* Virtualbox
* vagrant
* 'sahara' gem
* The source code for all of the dependent modules; you should clone a copy of each of these at the same level in your directory structure as your copy of puppet-postgresql.  For best results you should check out the same tag that is specified as the dependency in the puppet-postgresql `Modulefile`.  At the time of this writing, here are the github repos you'll need (but check the `Modulefile` to make sure you're up to date):
    * stdlib : https://github.com/puppetlabs/puppetlabs-stdlib
    * firewall : https://github.com/puppetlabs/puppetlabs-firewall
    * apt : https://github.com/puppetlabs/puppetlabs-apt
* A decent chunk of free disk space (~300MB per distro tested)
* Patience :)

If you just run:

    rspec ./spec

then, for each distro that has a Vagrantfile in the spec/distros directory,
vagrant will download a base image from the web, fire up a VM, and run
the suite of tests against the VM.

If you only want to run the tests against an individual distro, you can
instead do something like:

    rspec ./spec/distros/ubuntu_lucid_64

For some options that might speed up the testing process a bit during development,
please see `spec/support/postgres_test_config.rb`.

By default the sahara gem restores VMs to a snapshot state after each test,
to make sure that the individual tests aren't polluting the ones that are run later.
If you want to disable this during development, you can set HardCoreTesting to false
in `spec/support/postgres_test_config.rb`.
