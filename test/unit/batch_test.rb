require File.dirname(__FILE__) + '/../test_helper'

class BatchTest < ActiveSupport::TestCase
  fixtures :accounts
  
  def test_import_claim_checks_should_add_claim_batch_imports
    b = Batch.new
    assert b.import_claim_checks
    assert_equal b.batch_imports[0][:accountable_type], 'claim check'
  end
  
  def test_import_claim_checks_should_add_accounting_entries_based_on_batch_imports
    b = Batch.new
    b.import_claim_checks
    assert b.accounting_transactions[0].valid?
  end
  
  def test_import_legacy_checks_should_add_legacy_batch_imports
    b = Batch.new
    assert b.import_legacy_checks
    assert_equal b.batch_imports[50][:accountable_type], 'legacy check'
    assert_equal b.batch_imports[50][:document_number], 199431
  end
  
  def test_import_legacy_checks_should_add_accounting_entries_based_on_batch_imports
    b = Batch.new
    b.import_legacy_checks
    b.accounting_transactions.each do |at|
      assert at.valid?
    end
    assert b.save
  end
  
end
