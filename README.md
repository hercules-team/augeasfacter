puppet-augeasfacter
===================

This module provides a simple way of generating Facter facts using Augeas.

Adding facts
------------

Once this plugin is deployed on clients, you can create new files by adding to `/etc/puppet/augeasfacter.conf`
(replace with your value of `Puppet[:confdir]` if it is different).

This configuration file is an INI file, similar to `puppet.conf`.

Here is an example of a simple fact:

    [augeasversion]
    path = /augeas/version

When querying `facter` for the `augeasversion` fact, it will output the value of the `/augeas/version` node in the Augeas tree.

If you need to retrieve a node label rather than its value, you can use `method = label`:

    [user_1000]
    path   = /files/etc/passwd/*[uid="1000"]
    method = label

will output the name of the user with uid 1000.

You can also concatenate several values with a separator:

    [users]
    type   = multiple
    path   = /files/etc/passwd/*
    sep    = :
    method = label

will output the list of all users in /etc/passwd, concatenated with `:`.

See examples/augeasfacter.conf for a sample configuration file.
