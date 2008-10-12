require File.dirname(__FILE__) + '/../test_helper'

class AccountingEntryTest < Test::Unit::TestCase
  fixtures :accounting_entries, :statements, :accounts
  def setup
    @ck_entry = accounting_entries(:checking_credit)
    @expense = accounting_entries(:expense_100)
  end
  
  def test_is_debit
    assert @expense.is_debit?
  end
  
  def test_is_credit
    assert @ck_entry.is_credit?
  end
  
  def test_reversal_method
    assert_equal :debit, @ck_entry.reversal_method
    assert_equal :credit, @expense.reversal_method
  end
  
  def test_reversal_entry
    re = AccountingEntry.new(:account_id => @ck_entry.account_id, :debit => @ck_entry.credit )
    assert_equal re.credit.to_f, @ck_entry.reversal_entry.credit.to_f
    assert_equal re.account_id, @ck_entry.reversal_entry.account_id
  end
  
  def test_uncleared
    uncleared = AccountingEntry.uncleared
    @ck_entry.statement_id = 1
    @ck_entry.save 
    assert_equal AccountingEntry.uncleared.size, uncleared.size - 1 
  end  
  
end
