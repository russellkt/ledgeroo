require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")

calculator_tables = ['accounts']
namespace :bmic do                
  desc "load fixtures into #{ENV['RAILS_ENV']} database" 

  task :load_fixtures => :environment do 
     require 'active_record/fixtures'
     ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
     calculator_tables.each do |t|
       Fixtures.create_fixtures('bmic/fixtures', t)
     end
  end
end