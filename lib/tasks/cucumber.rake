$:.unshift(RAILS_ROOT + '/vendor/plugins/cucumber/lib')
require 'cucumber/rake/task'

desc "Run Cucumber features"
Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = '--format pretty'
end
task :features => 'db:test:prepare'

desc "Run Cucumber features with RCov"
Cucumber::Rake::Task.new(:features_rcov) do |t|
  t.cucumber_opts = '--format pretty'
  t.rcov = true
  t.rcov_opts << '-o coverage'
  t.rcov_opts << '--text-report'
  t.rcov_opts << '--exclude features\/,spec\/'
  t.rcov_opts << '--sort coverage'
end
task :features_rcov => 'db:test:prepare'
