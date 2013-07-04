APP_PATH = File.expand_path('../../application',  __FILE__)
require File.expand_path('../../boot',  __FILE__)
require File.expand_path('../../environment',  __FILE__)
namespace :export do
  
  desc "Export Mercury Daily Report"
  task :mercury_daily do
    run("cd #{current_path} && bundle exec rake export:mercury_daily start=#{start_date} end=#{end_date} RAILS_ENV=#{rails_env}")
  end
  
  desc "Send Yesterday Cost & Conversion Summary"
  task :yesterday_summary do
    run("cd #{current_path} && bundle exec rake export:yesterday_summary RAILS_ENV=#{rails_env}")
  end
  
  desc "Export Conversions"
  task :conversions do
    run("cd #{current_path} && bundle exec rake export:conversions RAILS_ENV=#{rails_env}")
  end
  
end
