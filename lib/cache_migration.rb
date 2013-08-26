require 'active_support/cache'

class CacheMigration
  attr_accessor :new_cache, :old_cache

  def initialize(new_cache, old_cache)
    @new_cache = new_cache
    @old_cache = old_cache
  end

  def fetch(name, options=nil)
    @new_cache.fetch(name, options) do
      @old_cache.fetch(name, options) do
        yield
      end
    end
  end

  def read(name, options=nil)
    value = @new_cache.read(name, options)
    if !value
      value = @old_cache.read(name, options)
      if value
        @new_cache.write(name, value, options)
      end
    end
    value
  end

  def write(name, value, options=nil)
    @new_cache.write(name, value, options)
    @old_cache.write(name, value, options)
  end

  def exist?(name, options=nil)
    @new_cache.exist?(name, options) || @old_cache.exist?(name, options)
  end

  def delete(name, options=nil)
    @new_cache.delete(name, options)
    @old_cache.delete(name, options)
  end

  def read_multi(*names)
    @new_cache.read_multi(*names).tap do |result|
      if result.length < names.length
        result.reverse_merge!(@old_cache.read_multi(*names))
      end
    end
  end

  def fetch_multi(*names, &proc)
    @new_cache.fetch_multi(*names) do |key|
      @old_cache.fetch(key, &proc)
    end
  end

  def clear(options = nil)
    @new_cache.clear(options)
    @old_cache.clear(options)
  end

  def cleanup(options = nil)
    @new_cache.cleanup(options)
    @old_cache.cleanup(options)
  end

  def increment(name, amount = 1, options = nil)
    @new_cache.increment(name, amount, options)
    @old_cache.increment(name, amount, options)
  end

  def decrement(name, amount = 1, options = nil)
    @new_cache.decrement(name, amount, options)
    @old_cache.decrement(name, amount, options)
  end

  def delete_matched(matcher, options = nil)
    @new_cache.delete_matched(matcher, options)
    @old_cache.delete_matched(matcher, options)
  end
end
