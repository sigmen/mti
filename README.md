# PG Inheritance
[![Gem Version](https://badge.fury.io/rb/pg_inheritance.svg)](https://badge.fury.io/rb/pg_inheritance)[![Build Status](https://travis-ci.com/sigmen/pg_inheritance.svg?branch=master)](https://travis-ci.com/sigmen/pg_inheritance)

# UNDER DEVELOPMENT

## Installation

Add this line to your application's Gemfile:

    gem 'pg_inheritance'

And then execute:

    $ bundle install

Or install with:

    $ gem install pg_inheritance

### Migrations

In your migration declare iherited_from option for create_table method call:

```ruby
class CreateMembers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
    end

    create_table :members, inherited_from: :users do |t|
      t.string :logo_url
    end
  end
end
```

After migrations members has available both columns.

### Drop inheritance

In your migration call drop_inheritance method. This has no options.

```ruby
class DropMemberUsersInheritance < ActiveRecord::Migration
  def change
    drop_inheritance :members, :users
  end
end
```

If inheritance exists this will be undeclared, but columns at inherited table will still be available. Otherwise will be raised an exception.
