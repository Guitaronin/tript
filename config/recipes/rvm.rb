# set_default :ruby_version, "1.9.2"

def rvm_installer_run(command)
  run "/usr/local/rvm/bin/rvm #{command}"
end

namespace :ruby do
  desc "Install rvm, Ruby, and the Bundler gem"
  
  task :setup, roles: :app do


    # remote_script = "/home/#{user}/rvm_installer.sh"
    # template "rvm_installer.sh.erb", remote_script
    # run "sh #{remote_script}"
    # # rvm_installer_run "install #{ruby_version}"
    # rvm_installer_run "use <%= ruby_version %> --default"
    # rvm_installer_run "install rubygems 1.5.3"
    run "gem install bundler --no-ri --no-rdoc"
    
  end
  
  # after "deploy:install", "rbenv:install"
end
