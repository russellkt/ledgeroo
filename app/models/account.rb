# == Schema Information
# Schema version: 13
#
# Table name: accounts
#
#  id              :integer         not null, primary key
#  name            :text            
#  description     :text            
#  account_type_id :integer         
#  number          :text            
#  bank_number     :text            
#  is_inactive     :boolean         
#  parent_id       :integer         
#  created_at      :datetime        
#  updated_at      :datetime        
#  company_id      :integer         
#

class Account < ActiveRecord::Base
  belongs_to :account_type
  has_many   :accounting_entries
  has_many   :accounting_transactions, :through => :accounting_entries
  has_many   :statements
  acts_as_tree :order => :number
  
  validates_presence_of   :name, :number
  validates_uniqueness_of :number
  
  def uncleared_entries
    accounting_entries.find_all_by_statement_id(nil)
  end
  
  def self.expense_accounts
    Account.map_for_select /expense/i
  end
  
  def self.bank_accounts
    Account.map_for_select /bank/i
  end
  
  def self.find_by_account_type_name regexp
    Account.find(:all, :include => :account_type, :order => 'number').select{|a| a.account_type.name =~ regexp }
  end
  
  def self.map_for_select regexp
    Account.find_by_account_type_name(regexp).map{|a| [a.number_with_name, a.id]}
  end  
  
  def types_of_accounts
    AccountType.find( :all, :order => :account_group_id )
  end
  
  def debits
    debit_entries ? debit_entries.sum(&:debit).to_f : 0
  end
  
  def credits 
    credit_entries ? credit_entries.sum(&:credit).to_f : 0
  end
  
  def debit_entries
    entries 'debit'
  end
  
  def credit_entries
    entries 'credit'
  end
  
  def entries debit_or_credit
    AccountingEntry.find( :all, :conditions => "account_id in (#{string_of_family_ids}) and #{debit_or_credit} > 0")
  end
  
  def balance
    balance = account_type.is_debit? ? debits - credits : credits - debits
  end
  
  def number_with_name
    "#{self.number} - #{self.name}"
  end
  
  def descendants
    self.children.map(&:descendants).flatten + self.children
  end
  
  def descendant_ids
    descendants.collect{|d| d.id}
  end
  
  def family_ids
    descendant_ids << id
  end
  
  def string_of_family_ids
    family_ids.join(",")
  end
  
  def number_of_ancestors
    ancestors.size.to_i
  end
  
  def available_parents
    ( Account.find_by_account_type_name( // ) - [self] )
  end
end
