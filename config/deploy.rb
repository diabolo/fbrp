set :application, "NewProject22"

#############################################################
#	Repository
#############################################################
default_run_options[:pty] = true  
set :use_sudo, false

set :repository,  "git@little-un:/srv/git/np22.git"
set :scm, :git
set :git_enable_submodules,1

set :repository_cache, "remote_cache"

# stops git cloning entire repository for every checkout
set :deploy_via, :remote_cache

# TODO find out what this does
set :ssh_options, { :forward_agent => true }


#############################################################
#	Servers
#############################################################

set :user, "deploy"
set :domain, "little-un"
server domain, :app, :web
role :db, domain, :primary => true

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/srv/rails-apps/#{application}"

#############################################################
#	Passenger
#############################################################

namespace :passenger do
  desc "Restart Application"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

#############################################################
#	Database.yml
#############################################################

require 'erb'

before "deploy:setup", :db
after "deploy:update_code", "db:symlink"

namespace :db do
  desc "Create database yaml in shared path"
  task :default do
    db_config = ERB.new <<-EOF
    base: &base
      adapter: mysql
      socket: /var/run/mysqld/mysql.sock
      host: 127.0.0.1
      username: #{user}
      password: #{password}

    development:
      database: #{application}_dev
      <<: *base

    test:
      database: #{application}_test
      <<: *base

    production:
      database: #{application}_prod
      <<: *base
    EOF

    run "mkdir -p #{shared_path}/config"
    put db_config.result, "#{shared_path}/config/database.yml"
  end

  desc "Make symlink for database yaml"
  task :symlink do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
end


#############################################################
#	Preserve Assets
# from Advanced Rails Recipes (Snack Recipe 76)
#############################################################

namespace :assets do

  task :symlink, :roles => :app do
    assets.create_dirs
    run <<-CMD
      rm -rf  #{release_path}/index &&
      rm -rf  #{release_path}/public/product_images/ &&
      ln -nfs #{shared_path}/index #{release_path}/index &&
      ln -nfs #{shared_path}/product_images #{release_path}/public/product_images
    CMD
  end
  
  task :create_dirs, :roles => :app do
    %w(index pictures).each do |name|
      run "mkdir -p #{shared_path}/#{name}"
    end
  end
end

after "deploy:update_code", "assets:symlink"
after :deploy, "passenger:restart"


