cache_migration
===============

CacheMigration is an ActiveSupport::Cache::Store implementation to aid in the transition between a hot cache server and a new cold cache server.

If you don't have a process for warming a new cache server, this process can be difficult. Switching your application "cold-turkey" to a new cache server can have a detrimental effect on performance and usability.

The CacheMigration gem will allow you to keep both the old and new cache servers online for a transition period, while the new cache server gradually becomes warmed through normal usage.

During the transition period, all writes will be sent to both cache servers.

When a read occurs, CacheMigration will first try to read from the new server. If there is a miss, the gem will fall back to the old server. If there is a hit on the new server, the data will be written back to the new server, thus warming it.

After enough time, when the new cache server is sufficiently warm, you can remove this gem and move back to using your normal cache interface. The old servers can be safely taken offline.

Gemfile

```ruby
gem 'cache_migration'
```

production.rb

```ruby
require 'active_support/cache/dalli_store'

old_cache = ActiveSupport::Cache::DalliStore.new(
    ENV["OLD_MEMCACHE_SERVERS"].split(","),
    :username => ENV['OLD_MEMCACHE_USERNAME'],
    :password => ENV['OLD_MEMCACHE_PASSWORD'])

new_cache = ActiveSupport::Cache::DalliStore.new(
    ENV["NEW_MEMCACHE_SERVERS"].split(","),
    :username => ENV['NEW_MEMCACE_USERNAME'],
    :password => ENV['NEW_MEMCACHE_PASSWORD'])

cache_migrations = CacheMigration.new(new_cache, old_cache)

config.cache_store = cache_migrations
```

This gem was designed to work with DalliStore, but it should work with any API compliant cache store.
