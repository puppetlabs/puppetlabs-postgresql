Warning: these spec tests are pretty resource intensive!

You will need the following in order to run them:

* Virtualbox
* vagrant
* 'sahara' gem
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