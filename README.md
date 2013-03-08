# VersionGuard

[![Build Status](https://travis-ci.org/kenn/version_guard.png)](https://travis-ci.org/kenn/version_guard)

A gem-like version checker to prevent unsupported versions from processing.

For instance, suppose you have the following lines in `config/initializers/patches.rb` for a Rails app:

```ruby
VersionGuard.abort('ActiveRecord::VERSION::STRING', '3.2.9')
# Monkey patches for ActiveRecord 3.2.9...
```

The ruby process terminates immediately with a warning message if the version is not 3.2.9. The first argument can be either a version string like "1.2.3" or a name that can be converted to the constant that holds the version string. For most gems, it should be something like `GemName::VERSION`.

VersionGuard has two methods: `abort` and `check`. While `abort` terminates the process, `check` just returns true / false so that you can choose what to do with the failed version.

## Installation

As usual.

```ruby
require 'version_guard'
```

## Usage

```ruby
# For mobile app backend
if VersionGuard.check request.headers['x-ios-app-version'], '< 1.2.1'
  # Your mobile app is too old, upgrade now!
end


# For capistrano with RVM
VersionGuard.abort ENV['rvm_version'].split(/\s/).first, '>= 1.18.5'


# Multiple version requirements are supported
VersionGuard.abort 'MyGem::VERSION', ['> 0.9.0', '< 1.1.0']
```
