
server "173.246.40.28", :app, :web, :db, :primary => true
set :use_sudo, true
set :rails_env, 'production'
set :repository,  "git@github.com:Guitaronin/#{application}.git"