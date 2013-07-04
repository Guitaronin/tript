namespace :nodejs do
  desc "Install the latest relase of Node.js"
  task :install, roles: :app do
    # run "#{sudo} add-apt-repository ppa:chris-lea/node.js"
    # run "#{sudo} apt-get -y update"
    run "wget http://nodejs.tchol.org/repocfg/el/nodejs-stable-release.noarch.rpm"
    run "#{sudo} yum localinstall --nogpgcheck nodejs-stable-release.noarch.rpm -y"
    run "sudo yum install nodejs-compat-symlinks npm -y"
    # run "#{sudo} yum -y install nodejs"
  end
  # after "deploy:install", "nodejs:install"
  
  desc "Install from source"
  task :install_from_source, roles: :app do
    # http://server-support.co/blog/sysadmin/centos5-quick-howto-install-node-js/
    # http://orion98mc.blogspot.com/2012/08/two-hours-ill-never-get-back.html
    version = "0.8.15"
    run "mkdir -p /usr/src"
    run "cd /usr/src && #{sudo} wget http://nodejs.org/dist/v#{version}/node-v#{version}.tar.gz"
    run "cd /usr/src && #{sudo} tar -zxf node-v#{version}.tar.gz" #Download this from nodejs.org
    run "cd /usr/src/node-v#{version} && #{sudo} python26 ./configure --prefix=/usr"
    run "cd /usr/src/node-v#{version} && export PYTHON=python26 && #{sudo} make  2>&1 && #{sudo} sudo python26 tools/install.py install"
    run "echo 'export PATH=/usr/local/bin/node:$PATH' >> ~/.zshrc"
    run "echo 'export PATH=/usr/local/bin/node:$PATH' >> ~/.bashrc"
    # run "cd /usr/src/node-v#{version} && #{sudo} make install"
       
  end
end
