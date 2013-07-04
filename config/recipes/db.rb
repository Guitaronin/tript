namespace :db do
  namespace :lhm do
  
    desc "Runs db:lhm:check rake task"
    task :check do
      run "cd #{current_path} && bundle exec rake db:lhm:check RAILS_ENV=#{rails_env}"
    end
    
    desc "Runs db:lhm:cleanup rake task"
    task :cleanup do
      run "cd #{current_path} && bundle exec rake db:lhm:cleanup RAILS_ENV=#{rails_env}"
    end
    
  end
end
