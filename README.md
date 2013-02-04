# augeasfacter, a Facter plugin to dynamically declare facts using Augeas

This is a [Facter](http://projects.puppetlabs.com/projects/facter) plugin to dynamically declare facts using [Augeas](http://augeas.net), without using a single line of code.


## Using outside of Puppet

This plugin does not strictly depend on Puppet. If you want to use it outside of Puppet, simply copy `lib/facter/augeasfacter.rb` in your `FACTERLIB` directory and use `/etc/augeasfacter.conf` (or the value of the `AUGEASFACTER_CONF` environment variable) as the configuration file for new facts.


## Using in Puppet

When used inside Puppet, the plugin will still load facts defined in `/etc/augeasfacter.conf`. However, it will also allow you to deploy facts using [pluginsync](http://docs.puppetlabs.com/guides/plugins_in_modules.html).

In order to do so, simply create `.conf` files in the `lib/augeasfacter/` directory of your modules:

    {modulepath}
    └── {module}
        └── lib
            └── augeasfacter
                ├── foo.conf
                └── bar.conf

Puppet will automatically sync the `augeasfacter` directory into its `:libdir` directory and `augeasfacter` will start using the declared facts immediatly.


## Fact declaration

The configuration files (whether `/etc/augeasfacter.conf` or configuration files in `{module}/lib/augeasfacter/` are INI files, similar to `puppet.conf`.

### Simple value

Here is an example of a simple fact:

    [augeasversion]
    path = /augeas/version

When querying `facter` for the `augeasversion` fact, it will output the value of the `/augeas/version` node in the Augeas tree.

### Simple labels

If you need to retrieve a node label rather than its value, you can use `method = label`:

    [user_1000]
    path   = /files/etc/passwd/*[uid='1000']
    method = label

will output the name of the user with uid 1000.

### Lists

You can also concatenate several values with a separator:

    [users]
    type   = multiple
    path   = /files/etc/passwd/*
    sep    = :
    method = label

will output the list of all users in `/etc/passwd`, concatenated with `:`.

See `examples/augeasfacter.conf` for a sample configuration file.

### Loading a specific lens

As with any Augeas-based tool, one might use a given lens on a specific file without having to modify the standard include statements of the lens. In order to achieve this, you can add `lens` and `incl` parameters to any fact, just as you would with the `augeas` type in Puppet:

    [json_entry]
    path = example.json/dict/entry[8]
    lens = Json.lns
    incl = /example.json

This will associate `/example.json` to the `Json.lns` lens before doing the query on `path`. Note that relative `path`s as used here will only work with Augeas 0.10.0 or greater, since `/augeas/context` is defined to `/files` by default in these versions.

## Issues

Please file any issues or suggestions [on GitHub](https://github.com/hercules-team/augeasfacter/issues).
