require 'minitest/unit'
require 'minitest/autorun'
require 'cache_migration'
require 'active_support/cache/memory_store'

class CacheMigrationTest < MiniTest::Unit::TestCase
  def setup
    @old_cache = ActiveSupport::Cache::MemoryStore.new
    @new_cache = ActiveSupport::Cache::MemoryStore.new
    @migration = CacheMigration.new(@new_cache, @old_cache)
  end

  def test_it_writes_to_both_caches
    @migration.write('hello', 'world')
    assert_equal 'world', @old_cache.read('hello')
    assert_equal 'world', @new_cache.read('hello')
  end

  def test_hit
    @new_cache.write('hello', 'world')
    assert_equal 'world', @migration.read('hello')
  end

  def test_half_miss
    @old_cache.write('hello', 'world')
    assert_equal 'world', @migration.read('hello')
    assert_equal 'world', @new_cache.read('hello')
  end

  def test_full_miss
    assert_nil @migration.read('hello')
  end

  def test_exists
    @old_cache.write('hello', 'world')
    @new_cache.write('foo', 'bar')

    assert @migration.exist?('hello')
    assert @migration.exist?('foo')
    assert !@migration.exist?('goodbye')
  end

  def test_fetch
    @migration.fetch('hello') { 'world' }
    assert_equal 'world', @old_cache.read('hello')
    assert_equal 'world', @new_cache.read('hello')
  end

  def test_delete
    @old_cache.write('hello', 'world')
    @new_cache.write('hello', 'world')
    @migration.delete('hello')
    assert_nil @new_cache.read('hello')
    assert_nil @old_cache.read('hello')
  end

  def test_read_multi
    @new_cache.write('hello', 'world')
    @old_cache.write('foo', 'bar')

    expected = {'hello' => 'world', 'foo' => 'bar'}

    assert_equal expected, @migration.read_multi('foo', 'hello')
  end

  # Commenting this test out because MemoryStore won't support fetch_multi
  # until Rails 4.1
  # def test_fetch_multi
  #   expected = {'hello' => 'world', 'foo' => 'bar'}

  #   @migration.fetch_multi('hello', 'world') do |key|
  #     case key
  #     when 'hello'; 'world'
  #     when 'foo'; 'bar'
  #     end
  #   end

  #   assert_equal 'world', @old_cache.read('hello')
  #   assert_equal 'world', @new_cache.read('hello')
  #   assert_equal 'foo', @old_cache.read('black')
  #   assert_equal 'foo', @new_cache.read('black')
  # end
end
