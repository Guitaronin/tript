set_default(:mysql_host, "localhost")
set_default(:mysql_user) { application }
set_default(:mysql_password) { 
  if File.exist?(tmp_pw)
    File.read(tmp_pw).strip
  else
    tmp = Capistrano::CLI.password_prompt "MySQL Password: "   
    %x(echo '#{tmp}' > #{tmp_pw})
    tmp
  end
}
set_default(:mysql_database) { "#{application}_#{stage}" }
set_default(:tmp_pw){ File.join(File.expand_path('../../../', __FILE__), 'tmp', "dbpw_#{stage}") }


namespace :mysql do
  desc "Install the latest stable release of MySQL."
  task :install, roles: :db, only: {primary: true} do
    run "#{sudo} rpm -Uhv http://www.percona.com/downloads/percona-release/percona-release-0.0-1.x86_64.rpm"
    run "#{sudo} yum install --nogpgcheck -y Percona-Server-devel-55.x86_64 Percona-Server-client-55.x86_64 Percona-Server-server-55.x86_64 Percona-Server-shared-compat"
    # run "#{sudo} sudo kill -9  `ps aux | grep [m]ysql | grep -v grep | cut -c 10-16`"
    run "#{sudo} /etc/init.d/mysql start"
    
    mysql_users = <<-MYSQL
    CREATE USER '#{mysql_user}'@'localhost' IDENTIFIED BY '#{mysql_password}';
    GRANT ALL PRIVILEGES ON *.* TO '#{mysql_user}'@'localhost' WITH GRANT OPTION;
    CREATE USER '#{mysql_user}'@'%' IDENTIFIED BY '#{mysql_password}';
    GRANT ALL PRIVILEGES ON *.* TO '#{mysql_user}'@'%' WITH GRANT OPTION; 
    CREATE DATABASE #{mysql_database};
    MYSQL
    
    upload(StringIO.new(mysql_users), '/tmp/mysql_setup.sql')
    run "mysql -u root < /tmp/mysql_setup.sql"
  end
  # after "deploy:install", "mysql:install"
  
  desc 'Create the db'
  task :create_database, roles: :db, only: {primary: true} do
    run "#{sudo} mysql -u root --execute 'create database #{application}_#{stage}'"
  end
  # after "deploy:setup", "mysql:create_database"

  desc 'Drop the db'
  task :drop_database, roles: :db, only: {primary: true} do
    run "#{sudo} mysql -u root --execute 'drop database #{application}_#{stage}'"
  end


  desc "Generate the database.yml configuration file."
  task :setup, roles: :app do
    run "mkdir -p #{shared_path}/config"
    template "database.yml.erb", "#{shared_path}/config/database.yml"
  end
  after "deploy:setup", "mysql:setup"

  desc "Symlink the database.yml file into latest release"
  task :symlink, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  after "deploy:finalize_update", "mysql:symlink"
end
