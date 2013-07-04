after "deploy:create_symlink", "escobar:create_symlinks"
namespace :escobar do 
  desc "Upload all of the private config files"
  task :upload_configs, :roles => [:app, :worker] do
    rails_root = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))
    run "mkdir -p #{shared_path}/private/services"
   
    # TODO Make this a nice function so that we can reuse it
    source = File.join(rails_root, 'private', 'services', '*')
    destin = File.join(shared_path, 'private', 'services')
    Dir.glob(source).each do |file|
      upload(file, File.join(destin, File.basename(file)))
    end
  end
 
  desc "Copy all upload file folders to the new release maintiaing them through deployments"
  task :create_symlinks, :roles => [:app, :worker] do 
    # Configs
    if rails_env == 'production'
      run "rm -rf #{release_path}/config/services"
      run "ln -nfs #{shared_path}/private/services #{release_path}/config/services"
      # run "ln -nfs #{shared_path}/private/services/database.yml #{release_path}/config/database.yml"
    end
    run "if [ ! -d #{shared_path}/tmp ]; then mkdir #{shared_path}/tmp ; fi;"
    run "if [ ! -d #{shared_path}/pids ]; then mkdir #{shared_path}/pids ; fi;"
    run "if [ ! -d #{shared_path}/sockets ]; then mkdir #{shared_path}/sockets ; fi;"
    run "ln -nfs #{shared_path}/tmp #{release_path}/tmp"
    run "ln -nfs #{shared_path}/pids #{release_path}/tmp/pids"
    run "ln -nfs #{shared_path}/sockets #{release_path}/tmp/sockets"
    run "ln -nfs #{shared_path}/.rvmrc #{current_path}/.rvmrc"
    
  end
end