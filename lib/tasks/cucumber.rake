$LOAD_PATH.unshift(RAILS_ROOT + '/vendor/plugins/cucumber/lib') if File.directory?(RAILS_ROOT + '/vendor/plugins/cucumber/lib')

begin
  require 'cucumber/rake/task'

  Cucumber::Rake::Task.new(:features) do |t|
    t.fork = true
    t.cucumber_opts = ['--format', (ENV['CUCUMBER_FORMAT'] || 'pretty')]  
    t.step_list = %w{features/support/env.rb features/step_definitions}
  end
  task :features => 'db:test:prepare'
  
  namespace :features do
    Cucumber::Rake::Task.new(:rcov, "Run Cucumber features with RCov") do |t|
      t.fork = true
      t.cucumber_opts = ['--format', (ENV['CUCUMBER_FORMAT'] || 'pretty')]
      t.rcov = true
      t.rcov_opts << '-o coverage'
      t.rcov_opts << '--text-report'
      t.rcov_opts << '--exclude features\/,spec\/'
      t.rcov_opts << '--sort coverage'    
    end
    task :features_rcov => 'db:test:prepare' 
  end
  
  namespace :rcov do
    Cucumber::Rake::Task.new(:redundant, "Search for unused step definitions using RCov") do |t|
      t.fork = true
      t.cucumber_opts = ['--format', (ENV['CUCUMBER_FORMAT'] || 'pretty')]
      t.rcov = true
      t.rcov_opts << '-o coverage'
      t.rcov_opts << '--text-report'
      t.rcov_opts << '--exclude spec\/'
      t.rcov_opts << '--sort coverage'
    end
    task :redundant => 'db:test:prepare'
  end
rescue LoadError
  desc 'Cucumber rake task not available'
  task :features do
    abort 'Cucumber rake task is not available. Be sure to install cucumber as a gem or plugin'
  end
end
