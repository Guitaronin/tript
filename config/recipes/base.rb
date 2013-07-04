def template(from, to)
  erb = File.read(File.expand_path("../templates/#{from}", __FILE__))
  put ERB.new(erb).result(binding), to
end

def set_default(name, *args, &block)
  set(name, *args, &block) unless exists?(name)
end

def sudo_group(commands=[])
  commands.each do |command|
    sudo command
  end
end

def random_password(size = 16)
  chars = (('a'..'z').to_a + ('0'..'9').to_a) - %w(i o 0 1 l 0)
  (1..size).collect{|a| chars[rand(chars.size)] }.join
end

after "rvm:install_rvm", "deploy:add_user_to_rvm_group"

namespace :deploy do

  task :change_ownership do 
    # run "#{sudo} chown -R #{user}:#{user} #{current_path}"
    # run "#{sudo} chown -R #{user}:#{user} #{shared_path}"
    run "#{sudo} chown -R #{user}:#{user} #{shared_path}/../"
  end
  after "deploy:setup", "deploy:change_ownership"

  task :add_rvmrc do
    run "echo 'rvm use #{rvm_ruby_string}' > #{shared_path}/.rvmrc"
    # run "cd #{shared_path} && rvm --rvmrc --create #{rvm_ruby_string}" # not sure how to make this work
  end
  after "deploy:setup", "deploy:add_rvmrc"


  desc "Install everything onto the server"
  task :install do
    set :default_shell, "sh"
    system_update
    root_certificate
  end
  
  desc "System Updates"
  task :system_update do
    commands = [# 'rpm -Uvh http://download.fedora.redhat.com/pub/epel/5/i386/epel-release-5-4.noarch.rpm',
      # 'rpm -Uvh http://download.elff.bravenet.com/5/i386/elff-release-5-3.noarch.rpm',
      'rpm -Uvh http://mirrors.servercentral.net/fedora/epel/5/i386/epel-release-5-4.noarch.rpm']
    sudo_group commands
    
    commands = ['yum update -y',
      "yum groupinstall 'Development Tools' -y",
      "yum install -y bash zsh curl openssl-devel readline-devel libxslt-devel gpg java curl-devel cyrus-sasl cyrus-sasl-devel screen libicu-devel",
      'yum install git -y',
      "mv /etc/localtime /etc/localtime.bak",
      "cp /usr/share/zoneinfo/US/Eastern /etc/localtime",
      "hostname #{application}",
      "perl -pi -e 's/HOSTNAME=(.*?)/HOSTNAME=#{application}/g' /etc/sysconfig/network"]
    sudo_group commands
  end
  
  desc "Install Python"
  task :install_python26 do
    sudo "yum -y install python26"
  end
  
  

  desc "Root certificates"
  task :root_certificate do
    commands = ["cp /etc/pki/tls/certs/ca-bundle.crt /etc/pki/tls/certs/ca-bundle.crt.`date +%s`",
      "mkdir -p /etc/ssl/certs/",
      "cp /etc/pki/tls/certs/ca-bundle.crt /etc/ssl/certs/ca-bundle.crt",
      "curl http://curl.haxx.se/ca/cacert.pem -o /etc/pki/tls/certs/ca-bundle.crt"]
    sudo_group commands
  end

  after "deploy:system_update", "deploy:root_certificate"

  desc "generate the add user commands"
  task :add_user do
    set :public_keys, Dir.glob("private/public_keys/*").inject("") {|sum, key| sum << File.read(key) }
    
    # set :public_key, File.read("/Users/jasonamster/.ssh/id_rsa.pub")
    erb = File.read(File.expand_path("../templates/user_add.sh.erb", __FILE__))
    puts ERB.new(erb).result(binding)
  end
  
  desc "add user to rvm group"
  task :add_user_to_rvm_group do
  
    sudo "/usr/sbin/usermod -a -G rvm #{user}"
  
  end
  
  desc "generate sudoers"
  task :sudoers do
    template "sudoers.erb",  "/tmp/sudoers"
    puts "
    # AS ROOT
    mv /etc/sudoers /etc/sudoers.bak
    mv /tmp/sudoers /etc/sudoers
    chmod 0440 /etc/sudoers
    chown root:root /etc/sudoers"
  end
  
end
