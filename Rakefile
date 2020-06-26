require "bundler/gem_tasks"
require "rspec/core/rake_task"

task :default => :spec

desc "opens interactive console for this program"
task :console do 
    require 'pry'
    require_relative('./lib/byteman')
    Pry.start
end