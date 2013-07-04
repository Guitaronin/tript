namespace :redis do
  
  desc "Install Redis"
  task :install do
    run "#{sudo} yum install redis -y"
    run "#{sudo} /sbin/chkconfig --add redis"
    run "#{sudo} /sbin/chkconfig --level 345 redis on"
    run "#{sudo} /sbin/service redis start"
  end
  
  desc "Start Redis server"
  task :start do
    init_cmd 'start'
  end
  
  desc "Stop Redis server"
  task :stop do
    init_cmd 'stop'
  end
  
  def init_cmd(cmd)
    run "#{sudo} /etc/init.d/redis #{cmd}"
  end
end