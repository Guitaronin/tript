# Add our vendored gems to the load path
Dir["#{File.expand_path(File.dirname(__FILE__))}/vendor/gems/**"].each do |dir| 
 $: << (File.directory?(lib = "#{dir}/lib") ? lib : dir)
end

# Load the deploy mechanism
load 'deploy' if respond_to?(:namespace) # cap2 differentiator

# Add the vendored recipes
Dir['config/recipes/*.rb', 'vendor/plugins//recipes/*.rb'].each { |plugin| load(plugin) }

# Load the rest of the tasks for Capistrano
load 'config/deploy'

default_run_options[:pty] = true