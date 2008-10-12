# == Schema Information
# Schema version: 13
#
# Table name: accounting_entries
#
#  id                        :integer         not null, primary key
#  accounting_transaction_id :integer         
#  account_id                :integer         
#  debit                     :decimal(10, 2)  
#  credit                    :decimal(10, 2)  
#  memo                      :string(255)     
#  has_cleared               :boolean         
#  created_at                :datetime        
#  updated_at                :datetime        
#  accountable_id            :integer         
#  accountable_type          :string(255)     
#  statement_id              :integer         
#

class AccountingEntry < ActiveRecord::Base
  belongs_to :accounting_transaction
  belongs_to :account
  belongs_to :accountable, :polymorphic => true
  belongs_to :statement
  
  attr_reader :account_number

  def validate 
    errors.add_to_base( "Entry cannot contain both a credit and a debit amount." ) if( has_both_credit_and_debit_amounts )
    errors.add_to_base( "Entry must contain either a credit or debit amount.") unless( has_credit_or_debit_amount )
  end
  
  def self.uncleared
    find_all_by_statement_id( nil )
  end
  
  def memo_or_transaction_memo
    memo || accounting_transaction.memo
  end

  def has_both_credit_and_debit_amounts
     has_credit && has_debit
  end

  def has_credit
    ( credit && credit.to_i != 0 )
  end

  def has_debit
    ( debit && debit.to_i != 0 )
  end

  def has_credit_or_debit_amount
    self.credit || self.debit
  end
  
  def is_debit?
    debit
  end
  
  def is_credit?
    credit
  end
  
  def reversal_method
    is_debit? ? :credit : :debit
  end
  
  def reversal_amount
    is_debit? ? self.debit.to_f : self.credit.to_f
  end
  
  def reversal_entry
    AccountingEntry.new( reversal_method => reversal_amount,
                         :account_id => self.account_id )
  end

  def void
    update_attributes( :credit => 0, :debit => 0 )
  end
  
  def account_number= acct_number
    self.account = Account.find_by_number(acct_number)
  end
  
  def account_number_with_name
    self.account ? account.number_with_name : ''
  end

end
