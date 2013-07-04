namespace :iptables do
  desc "Setup new iptables rules set"
  task :setup, roles: :web do
    flush
    configure
    save
    restart
    list
  end
  
  desc "Print current iptables rules"
  task :list, roles: :web do
    run "#{sudo} /sbin/iptables -L"
  end
  
  desc "Flush existing iptables rules"
  task :flush, roles: :web do
    run "#{sudo} /sbin/iptables -P INPUT ACCEPT" # don't get locked out of ssh
    run "#{sudo} /sbin/iptables -F"
  end
  
  desc "Append new iptables rules"
  task :configure, roles: :web do
    rules = File.open(  File.join( File.dirname(__FILE__), 'templates', 'iptables.erb' )  ).readlines
    rules.each do |rule|
      run "#{sudo} #{rule}"
    end
  end
  
  desc "Print current iptables rules"
  task :save, roles: :web do
    run "#{sudo} /sbin/service iptables save"
  end
  
  desc "Install iptables"
  task :install, roles: :web do
    run "#{sudo} yum -y install iptables"
  end
  
  %w[start stop restart].each do |command|
    desc "#{command} iptables"
    task command, roles: :web do
      run "#{sudo} /etc/init.d/iptables #{command}"
    end
  end
end
