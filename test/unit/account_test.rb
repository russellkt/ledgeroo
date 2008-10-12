require File.dirname(__FILE__) + '/../test_helper'

class AccountTest < Test::Unit::TestCase
  fixtures :accounts, :account_groups, :account_types, :accounting_entries
  def setup
    @checking = accounts(:checking)
    @expense = accounts(:expense)
    @child_expense = accounts(:child_expense)
    @grandchild_expense = accounts(:grandchild_expense)
  end
  def test_parent_and_children_ids
    assert_equal @expense.descendant_ids, [4,3]
    assert_equal @expense.family_ids, [4,3,2]
    assert_equal @expense.string_of_family_ids, "4,3,2"
  end
  def test_debit_entries
    assert @expense.debit_entries.size == 1
    assert @checking.credit_entries.size == 1 
  end
  def test_debits_and_credits
    assert_equal @expense.debits, 100
    assert_equal @expense.credits, 0
  end
  def test_balance
    assert_equal @expense.balance, 100
    assert_equal @checking.balance, -100
  end
  def test_account_finders
    assert_equal 1, Account.bank_accounts.length
    assert Account.expense_accounts
  end
  def test_map_for_select
    assert_equal ['1100 - Colonial Checking', 1], Account.map_for_select(/bank/)[0]
  end
  def test_available_parents
    assert @checking.available_parents.size < Account.find(:all).size
  end
end
