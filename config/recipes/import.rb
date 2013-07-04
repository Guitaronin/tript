APP_PATH = File.expand_path('../../application',  __FILE__)
require File.expand_path('../../boot',  __FILE__)
require File.expand_path('../../environment',  __FILE__)
namespace :import do

  desc "Import Adwords Names Costs"
  task :adwords_cost do
    (Date.parse(start_date)..Date.parse(end_date)).each do |date|
      sdate = date.strftime("%Y-%m-%d")
      puts "\n\nSTARTING NEW RAKE: #{sdate}"
      run("cd #{current_path} && bundle exec rake import:adwords_cost start=#{sdate} end=#{sdate} RAILS_ENV=#{rails_env}")
    end
  end
  
  desc "Import Hasoffers Costs"
  task :hasoffers_cost do
    run("cd #{current_path} && bundle exec rake import:hasoffers_cost start=#{start_date} end=#{end_date} RAILS_ENV=#{rails_env}")
  end
  
  desc "Import Peekyou Costs"
  task :peekyou_cost do
    run("cd #{current_path} && bundle exec rake import:peekyou_cost start=#{start_date} end=#{end_date} RAILS_ENV=#{rails_env}")
  end
  
  desc "Import Hasoffers Costs with long date range"
  task :hasoffers_cost_historical do
    start = start_date.to_date
    while start < end_date.to_date
      finish = start.end_of_month
      run("cd #{current_path} && bundle exec rake import:hasoffers_cost start=#{start.strftime("%Y-%m-%d")} end=#{finish.strftime("%Y-%m-%d")} RAILS_ENV=#{rails_env}")
      start = start.next_month.beginning_of_month
    end
  end

  desc "Import Sitescout Costs"
  task :sitescout_cost do
    (Date.parse(start_date)..Date.parse(end_date)).each do |date|
      sdate = date.strftime("%Y-%m-%d")
      puts "\n\nSTARTING NEW RAKE: #{sdate}"
      run("cd #{current_path} && bundle exec rake import:sitescout_cost start=#{sdate} end=#{sdate} RAILS_ENV=#{rails_env}")
    end
  end
  
  desc "Import 50onRed Costs"
  task :fiftyonred_cost do
    (Date.parse(start_date)..Date.parse(end_date)).each do |date|
      sdate = date.strftime("%Y-%m-%d")
      puts "\n\nSTARTING NEW RAKE: #{sdate}"
      run("cd #{current_path} && bundle exec rake import:fiftyonred_cost start=#{sdate} end=#{sdate} RAILS_ENV=#{rails_env}")
    end
  end
  
  desc "Import Whitepages Costs"
  task :whitepages_cost do
    run("cd #{current_path} && bundle exec rake import:whitepages_cost start=#{start_date} end=#{end_date} RAILS_ENV=#{rails_env}")
  end
  
  desc "Import Bing Costs"
  task :bing_cost do
    (start_date..end_date).each do |date|
      run("cd #{current_path} && bundle exec rake import:bing_cost start=#{date} end=#{date} RAILS_ENV=#{rails_env}")
    end
  end
  
  desc "Import Facebook Costs"
  task :facebook_cost do
    (start_date..end_date).each do |date|
      run("cd #{current_path} && bundle exec rake import:facebook_cost start=#{date} end=#{date} RAILS_ENV=#{rails_env}")
    end
  end
  
  desc "Import Admarketplace Costs"
  task :admarketplace_cost do
    (start_date..end_date).each do |date|
      run("cd #{current_path} && bundle exec rake import:admarketplace_cost start=#{date} end=#{date} RAILS_ENV=#{rails_env}")
    end
  end
  
  desc "Import Mercury Media Costs"
  task :mercury_cost do
    run("cd #{current_path} && bundle exec rake import:mercury_cost RAILS_ENV=#{rails_env}")
  end
  
  desc "Import Pipl Costs"
  task :pipl_cost do
    run("cd #{current_path} && bundle exec rake import:pipl_cost start=#{start_date} end=#{end_date} RAILS_ENV=#{rails_env}")
  end
  
  namespace :processed do
    
    desc "Add to processed imports"
    task :insert do
      run("cd #{current_path} && bundle exec rake import:processed:insert type=#{type} import=#{job} #{rake_args} RAILS_ENV=#{rails_env}")
    end
    
  end
  
  
  namespace :ktc do
    
    desc "Run import:ktc:historical task"
    task :historical do
      run("cd #{current_path} && bundle exec rake import:ktc:historical start=#{start_date} #{rake_args} RAILS_ENV=#{rails_env}")
    end
    
  end
  
  
  
  def rake_args
    if type == 'date'
      "start=#{start_date} end=#{end_date}"
    elsif type == 'file'
      "files='#{files}'"
    end
  end
    
  
end
