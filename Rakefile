$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require 'bundler/version'
require 'sandman/version'
require "bundler/gem_tasks"
 
task :build do
  system 'gem build sandman.gemspec'
end

task :install do
  system "gem install sandman-#{Sandman::VERSION}.gem"
end
