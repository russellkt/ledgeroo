# == Schema Information
# Schema version: 13
#
# Table name: statements
#
#  id                :integer         not null, primary key
#  account_id        :integer         
#  started_on        :date            
#  ended_on          :date            
#  beginning_balance :decimal(10, 2)  
#  ending_balance    :decimal(10, 2)  
#  is_closed         :boolean         
#

class Statement < ActiveRecord::Base
  has_many :accounting_entries, :include=>'accounting_transaction', :order=>'accounting_transactions.recorded_on asc'
  belongs_to :account
  validates_presence_of :beginning_balance, :ending_balance, :started_on, :account_id
  def balanced?
    balance_difference == 0
  end
  def total_credits
    credits = self.accounting_entries.inject(0){|s,e| s + e.credit.to_f }
  end
  def total_debits
    debits = self.accounting_entries.inject(0){|s,e| s + e.debit.to_f }
  end
  def cleared_total
    total_debits - total_credits
  end
  def balance_difference
    beginning_balance - ending_balance + cleared_total
  end
end
