
server "198.61.183.199", :app, :web, :db, :primary => true
set :use_sudo, true
set :rails_env, 'production'
set :repository,  "git@github.com:BeenVerifiedInc/#{application}.git"


__END__
　

require "bundler/capistrano"
load 'deploy/assets'

set :application, "escobar"
set :repository,  "git@github.com:BeenVerifiedInc/escobar.git"
set :scm, :git
set :deploy_to, "/www/#{application}"
set :user, "escobar"
set :scm_username, "beenverified"
set :use_sudo, false
server "198.61.183.199", :app, :web, :db, :primary => true

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

set :rvm_ruby_string, 'ruby-1.9.3-p194@escobar'
set :rvm_type, :user
require "rvm/capistrano"

set :default_environment, {
  'LD_LIBRARY_PATH' => '/usr/local/lib',
}

namespace :rvm do
  task :trust_rvmrc do
    run "rvm rvmrc trust #{release_path}"
  end
end

after "deploy", "rvm:trust_rvmrc"

set :shared_children, shared_children << 'tmp/sockets'

namespace :deploy do
  desc "Start the application"
  task :start, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && RAILS_ENV=#{stage} bundle exec puma -b 'unix://#{shared_path}/sockets/puma.sock' -S #{shared_path}/sockets/puma.state --control 'unix://#{shared_path}/sockets/pumactl.sock' >> #{shared_path}/log/puma-#{stage}.log 2>&1 &", :pty => false
  end

  desc "Stop the application"
  task :stop, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && RAILS_ENV=#{stage} bundle exec pumactl -S #{shared_path}/sockets/puma.state stop"
  end

  desc "Restart the application"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && RAILS_ENV=#{stage} bundle exec pumactl -S #{shared_path}/sockets/puma.state restart"
  end

  desc "Status of the application"
  task :status, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && RAILS_ENV=#{stage} bundle exec pumactl -S #{shared_path}/sockets/puma.state stats"
  end
end