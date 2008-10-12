# == Schema Information
# Schema version: 13
#
# Table name: account_types
#
#  id               :integer         not null, primary key
#  name             :string(255)     
#  account_group_id :integer         
#

class AccountType < ActiveRecord::Base
  
  has_many   :accounts, :order=>'number'
  belongs_to :account_group
  has_many   :accounting_entries, :through => :accounts
  
  def self.map_for_select
    AccountType.find(:all).map{|a| [a.name, a.id]}
  end
  
  def is_debit?
    self.account_group.is_debit?
  end
  
  def is_credit?
    self.account_group.is_credit?
  end
  
  def balance
    accounts.sum{ |acct| acct.balance }
  end
end
