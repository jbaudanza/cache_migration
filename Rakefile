require 'rake'
require 'rake/testtask'
require 'bundler/gem_tasks'

Rake::TestTask.new do |t|
  t.libs << "lib"
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
  t.warning = true
end

task :default => :test
