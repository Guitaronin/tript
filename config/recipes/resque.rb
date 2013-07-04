namespace :resque do
  
  desc "Start Resque workers"
  task :start do
    run "cd #{current_path} && bundle exec resque-pool --daemon --environment #{rails_env}"
  end
  
  desc "Stop Resque workers"
  task :stop do
    pid_file = File.join(shared_path, 'pids', 'resque-pool.pid')
    run "cd #{shared_path} && kill -QUIT `cat #{pid_file}`"
  end
  
  desc "Stop/Start Resque workers"
  task :restart do
    stop
    start
  end
end