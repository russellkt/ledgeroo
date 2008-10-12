require "#{File.dirname(__FILE__)}/../test_helper"
require 'hpricot_test_extension'
require 'authenticated_test_helper'
class NeedingFixturesTest < ActionController::IntegrationTest
  fixtures :accounting_transactions, :accounting_entries, :accounts, 
           :account_groups, :account_types, :statements,
           :users, :roles
  include AuthenticatedTestHelper
  def remove_id( att )
    att.delete("id")
    att
  end           
  def property_policy_item_params
    policy_item_params = { "coverage"=>["150000","75000"],
                            "item_type"=>["Dwelling", "Contents"], 
                            "construction"=>["Frame", "Frame"],
                            "description"=>["Big House in the city, the great city","Contents in dwelling listed with me"] }
  end
end