require "bundler/gem_tasks"
require 'rake'
require 'rspec/core/rake_task'

namespace :spec do

  RSpec::Core::RakeTask.new(:coverage) do |t|
    t.pattern = 'spec/**/*_spec.rb'
	t.rcov = true
	t.rcov_opts = '--exclude osx\/objc,spec,gems\/'

  end
 end