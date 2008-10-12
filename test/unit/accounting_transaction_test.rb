require File.dirname(__FILE__) + '/../test_helper'

class AccountingTransactionTest < Test::Unit::TestCase
  fixtures :accounting_transactions, :accounting_entries, :accounts, :account_groups, :account_types

  def setup
    @check = accounting_transactions(:checking_expense)
  end
  
  def test_unbalanced
    trns = AccountingTransaction.new( )
    trns.accounting_entries << accounting_entries(:checking_wo_trns)
    assert !trns.is_balanced?
    trns.accounting_entries << accounting_entries(:expense_wo_trns)
    assert trns.is_balanced?
  end
  
  def test_total_credits
    assert_equal 100, accounting_transactions(:checking_expense).total_credits
  end
  
  def test_total_debits
    assert_equal 100, accounting_transactions(:checking_expense).total_debits
  end
  
  def test_balanced
    assert accounting_transactions(:checking_expense).is_balanced?
  end
  
  def test_entries
    assert_equal 1,accounting_transactions(:checking_expense).debit_entries.size
    assert_equal 1,accounting_transactions(:checking_expense).credit_entries.size
  end
  
  def test_next_document_number
    another_check = AccountingTransaction.new(:transaction_type=>'check')
    assert_equal 13001, another_check.next_document_number
  end
  
  def test_reversal_transaction
    assert reversal_transaction = @check.reversal_transaction
    assert_equal 2, reversal_transaction.accounting_entries.size
    assert_equal Date.today, reversal_transaction.recorded_on
  end
  
  def test_void_and_reverse
    assert reversal_transaction = @check.void_and_reverse
    assert @check.is_void?
    assert_equal @check.reversal_id, reversal_transaction.id
    assert_equal 1, reversal_transaction.reversal_id
  end
  
  def test_void
    assert !@check.is_void?
    @check.void
    assert_equal 0, @check.total_credits.to_i
    assert_equal 0, @check.total_debits.to_i
  end

  def test_void_should_cause_total_accounting_entry_debits_to_change
    before_balance = AccountingEntry.sum(:debit).to_i
    @check.void
    after_balance = AccountingEntry.sum(:debit).to_i
    assert_not_equal before_balance, after_balance
  end
  
  def test_offset_quickie_should_work_with_zero_amounts
    assert at = AccountingTransaction.create( "name"=>"kevin", 
                                              "recorded_on"=>"2008-08-20", 
                                              "document_number"=>"200026", 
                                              "offsetting_account"=>"1104", 
                                              "new_entry_attributes"=>[ {"debit"=>"0", "account_id"=>"2"} ] )
    assert at.displayed_debit_account
    assert at.displayed_credit_account
  end
  
  def test_offsetting_quickie_should_set_transaction_to_void_if_zero
    assert at = AccountingTransaction.create( "name"=>"kevin", 
                                              "recorded_on"=>"2008-08-20", 
                                              "document_number"=>"200026", 
                                              "offsetting_account"=>"1104", 
                                              "new_entry_attributes"=>[ {"debit"=>"0", "account_id"=>"2"} ] )
    assert at.is_void?
  end

end
