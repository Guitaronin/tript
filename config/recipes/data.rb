namespace :data do
  
  desc "Runs data:update_source_aliases rake task"
  task :update_source_aliases do
    run "cd #{current_path} && bundle exec rake data:update_source_aliases RAILS_ENV=#{rails_env}"
  end
      
end