require File.dirname(__FILE__) + '/../test_helper'

class StatementTest < Test::Unit::TestCase
  fixtures :statements, :accounts, :accounting_entries
  def setup
    @checking_statement = statements( :bank_statement )
    @credit = accounting_entries(:checking_credit)
    @deposit = AccountingEntry.new( :debit=>5100 )
  end
  def test_initial
    assert @checking_statement
    assert_equal 0, @checking_statement.total_debits
    assert_equal 0, @checking_statement.total_credits
  end
  def test_total_credits
    assert_equal 0, @checking_statement.total_credits
    @checking_statement.accounting_entries << @credit
    assert_equal 100, @checking_statement.total_credits
  end
  def test_cleared_total
    assert_equal 0, @checking_statement.cleared_total
    @checking_statement.accounting_entries << @credit
    assert_equal -100, @checking_statement.cleared_total    
  end
  def test_balance_difference
    assert_equal -5000, @checking_statement.balance_difference.to_f
    @checking_statement.accounting_entries << @credit
    assert_equal -5100, @checking_statement.balance_difference.to_f
    @checking_statement.accounting_entries << @deposit
    assert_equal 0, @checking_statement.balance_difference.to_f
  end
  def test_balanced?
    assert !@checking_statement.balanced?
    @checking_statement.accounting_entries << @credit    
    assert !@checking_statement.balanced?
    @checking_statement.accounting_entries << @deposit
    assert @checking_statement.balanced?
  end
end
