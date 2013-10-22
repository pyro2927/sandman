# Sandman

Sandman is meant to help manage ssh keys on [GitHub](https://github.com/) and [BitBucket](https://bitbucket.org/).

## Table of Contents
* [Installation](#installation)
* [Usage](#usage)
    * [Setup](#setup)
    * [Adding keys](#adding-keys)
    * [Removing keys](#removing-keys)
    * [Viewing keys](#viewing-keys)
* [TODO](#todo)
* [Contributing](#contributing)

_Generated with [tocify](https://github.com/pyro2927/tocify)_

## Installation

Add this line to your application's Gemfile:

    gem 'sandman'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sandman

## Usage

Sandman is generally meant to be used from the command line, though I guess you could use it through a script if you want.

### Setup

To allow access to your GitHub and BitBucket accounts, you'll need to create a YAML formatted config file at `~/.sandman`.  Sample config shown below:

    ---
    :accounts:
    - :login: pyro2927
      :password: PASSWORD1
      :type: Github
    - :login: pyro2927
      :password: LULZPASSWORD
      :type: BitBucket

You can create a sample config by running `sandman createconfig`.

### Adding keys

Sandman can add keys pasted into the terminal, though it can also read them from a file.  The name isn't required, though if you don't input one it will use the system's `hostname`.

    $ sandman add "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC3d5LXLEAOQBVooFVAxWHsolr..." awesomekey
    $ sandman add ~/.ssh/id_rsa.pub

### Removing keys

Removing keys is just about as easy.  To remove a key, you must pass in a string it starts with, or the name/title of the key.

    $ sandman rem "ssh-rsa AAAAB3NzaC1yc2E"
    $ sandman rem oldkey

**Warning: This checks against the starting text of your public key.  If you run `sandman rem ssh`, it will remove all of them.**

### Viewing keys

Viewing keys will show your existing keys in any authenticated systems.  By default, keys will be truncated to prevent wrapping in the terminal, though they can be printed fully with `showfull`.

    $ sandman show
    $ sandman showfull

## TODO

- [ ] Enable public key marging, syncing all accounts specified
- [ ] Allow arbitrary config file location
- [ ] Support OAuth
- [ ] Add in safeguards to prevent people from deleting all of their public keys

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
