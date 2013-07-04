namespace :rails do 
  desc "Show rails logs"
  task :show_rails_logs do 
    stream "tail -f #{current_path}/log/#{stage}.log"
  end
  
  desc "precompile assets" 
  task :precompile, :role => :app do
    run "cd #{current_path} && bundle exec rake assets:precompile --trace RAILS_ENV=#{stage}"
  end
  
  before "deploy:restart", "rails:precompile"
  
end

namespace :db do 
  desc "db migrate"
  task :migrate do 
    run "cd #{current_path} && bundle exec rake RAILS_ENV=#{stage} db:migrate"
  end
  
  desc "reseeed"
  task :reseed do
    run "cd #{current_path} && bundle exec rake RAILS_ENV=#{stage} db:drop db:create db:migrate db:seed --trace"
  end
  
  desc "db seed"
  task :seed do 
    run "cd #{current_path} && bundle exec rake RAILS_ENV=#{stage} db:seed --trace"
  end
  
end