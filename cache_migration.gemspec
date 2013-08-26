# -*- encoding: utf-8 -*-
Gem::Specification.new do |gem|
  gem.name          = "cache_migration"
  gem.version       = '0.0.1'
  gem.authors       = ["Jonathan Baudanza"]
  gem.email         = ["jon@jonb.org"]
  gem.description   = %q{ActiveSupport::Cache::Store implementation to help migrating caches}
  gem.summary       = %q{ActiveSupport::Cache::Store implementation to help migrating caches}
  gem.homepage      = "https://github.com/jbaudanza/cache_migration"

  gem.add_dependency('activesupport', '>= 3.0.0')

  gem.files         = `git ls-files`.split($/).collect{ |str| str[0] == '"' ? eval(str) : str }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
