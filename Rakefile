# frozen_string_literal: true

require 'rake/testtask'

desc 'run tests'
task default: :test

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/**/*_spec.rb', 'test/**/test_*.rb']
  t.warning = false
end
