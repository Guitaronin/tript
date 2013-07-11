require "rvm/capistrano"
require "bundler/capistrano"
require 'capistrano/ext/multistage'

set :rvm_ruby_string, 'ruby-1.9.3-p194@tript'
set :rvm_type, :user

set :stages, %w(production staging)
set :default_stage, "staging"

set :application, "tript"
set :repository,  "git@github.com:Guitaronin/#{application}.git"
set :scm, :git
set :deploy_to, "/www/#{application}"
set :user, "tript"
set :scm_username, "Guitaronin"
set :use_sudo, false
set :deploy_via, :remote_cache
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:finalize_update"
after "deploy", "deploy:cleanup" # keep only the last 5 releases


set :default_environment, {'LD_LIBRARY_PATH' => '/usr/local/lib'}

namespace :rvm do
  task :trust_rvmrc do
    run "rvm rvmrc trust #{release_path}"
  end
end

after "deploy", "rvm:trust_rvmrc"

set :shared_children, shared_children << 'tmp/sockets'
