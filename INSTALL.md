bundle exec cap staging deploy:add_user > config/user_add.sh
scp config/user_add.sh vagrant@33.33.33.10:/home/vagrant/user_add.sh

# SSH IN and run all them commands
bundle exec cap staging deploy:sudoers
# SSH IN and run all them commands
(^ cmds that are printed out by the previous bundle exec; also you have to `sudo su` as vagrant)

bundle exec cap staging deploy:install
bundle exec cap staging rvm:install_rvm
bundle exec cap staging rvm:install_ruby
bundle exec cap staging nginx:install
bundle exec cap staging mysql:install
bundle exec cap staging deploy:setup
bundle exec cap staging mysql:setup
<!-- bundle exec cap staging nodejs:install --> <!-- # broken due to rpm host down -->
bundle exec cap staging deploy:install_python26
bundle exec cap staging nodejs:install_from_source
bundle exec cap staging mysql:create_database #Can't create database 'escobar_staging'; database exists
bundle exec cap staging nginx:setup
bundle exec cap staging redis:install
bundle exec cap staging unicorn:setup
bundle exec cap staging iptables:install
<!-- bundle exec cap staging iptables:setup --> <!-- Don't do this, it fucks everything up -->
bundle exec cap staging deploy:cold
bundle exec cap staging deploy:migrations
bundle exec cap staging deploy
bundle exec cap staging resque:start
bundle exec cap staging unicorn:start


############################################################
######## Production 
############################################################

bundle exec cap production deploy:add_user > config/user_add.sh
<!-- scp config/user_add.sh root@198.61.183.199:/home/escobar/user_add.sh -->

# SSH IN and run all them commands
bundle exec cap production deploy:sudoers
# SSH IN and run all them commands
(^ cmds that are printed out by the previous bundle exec; MAKE SURE YOU'RE LOGGED IN AS ROOT (i.e. if you just did `su escobar` you better exit))

bundle exec cap production deploy:install
bundle exec cap production rvm:install_rvm
bundle exec cap production rvm:install_ruby
bundle exec cap production nginx:install
bundle exec cap production mysql:install
bundle exec cap production deploy:setup
bundle exec cap production mysql:setup
bundle exec cap production deploy:install_python26
bundle exec cap production nodejs:install_from_source
bundle exec cap production mysql:create_database #Can't create database 'escobar_development'; database exists
bundle exec cap production mysql:setup
bundle exec cap production nginx:setup
bundle exec cap production redis:install
bundle exec cap production unicorn:setup
bundle exec cap production iptables:setup
bundle exec cap production deploy:cold
bundle exec cap production deploy:migrations
bundle exec cap production deploy
bundle exec cap production resque:start
bundle exec cap production unicorn:start