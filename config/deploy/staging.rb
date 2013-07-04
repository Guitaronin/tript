server "33.33.33.10", :web, :app, :db, primary: true
set :use_sudo, true
set :repository,  "git@github.com:Guitaronin/#{application}.git"

set :rails_env, 'staging'
set :rack_env, 'staging'

