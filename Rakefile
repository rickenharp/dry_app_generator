require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task :ci do
  sh 'git config --global user.email "git@example.com"' if `git config user.email`.empty?
  sh 'git config --global user.name "GitExample"' if `git config user.name`.empty?
  Rake::Task[:spec].invoke
end
