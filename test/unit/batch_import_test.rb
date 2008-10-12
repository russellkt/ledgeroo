require File.dirname(__FILE__) + "/../test_helper"
class BatchImportTest < ActiveSupport::TestCase
  fixtures :batch_imports, :accounts
  
  def setup
    @bi = batch_imports(:claim_import)
  end
  
  def test_import_claim_checks_should_retrieve_claims_csv_source_and_return_array_of_batch_imports
    assert claims = BatchImport.import_claim_checks
    assert claims[0][:accountable_type] = 'claim check'
  end
  
  def test_convert_imported_claim_should_return_a_batch_import_from_a_hash
    claim_hash = { "CHECK_NUMBER"=>"199001.0",
                  "CHECK_YEAR"=>"8.0",
                  "PERIL"=>"F",
                  "ACCOUNT_NUMBER"=>"5142.0",
                  "IS_ADJUSTING_COST"=>"Y",
                  "PAYEE"=>"GLEN BODIFORD                      ",
                  "CLAIM_ID"=>"1002   ",
                  "CHECK_DAY"=>"15.0",
                  "CHECK_MONTH"=>"7.0",
                  "AMOUNT" => "100.0" }
    assert bi = BatchImport.convert_imported_claim(claim_hash)
    assert bi.document_number = 199001
    assert bi.account_number = "5142"
    assert bi.payee = "GLEN BODIFORD"
    assert bi.accountable_type = "claim check"
    assert bi.accountable_id = 1002
    assert bi.amount = 100.00.to_d
  end
  
  def test_date_from_as400_date_fields_should_return_valid_date
    assert_equal Date.parse('2008-04-01'), BatchImport.date_from_as400_date_fields( "8.0","4.0","1.0" )
  end
  
  def test_create_accounting_transaction_should_create_accounting_transaction_from_itself
    assert at = @bi.create_accounting_transaction
    assert at.accounting_entries[0]
    assert at.accounting_entries[1]
    assert at.valid?
  end
  
  def test_last_claim_check_number_should_return_the_highest_claim_check_number
    assert_equal 199881, BatchImport.last_claim_check_number
  end
  
  def test_import_legacy_checks_should_retrieve_legacy_checks_and_return_array_of_batch_imports
    assert legacy_checks = BatchImport.import_legacy_checks
    assert legacy_checks[0].is_a?( BatchImport )
  end
  
  def test_convert_imported_legacy_should_return_a_batch_import_from_a_hash
    beginning_of_month = Time.new.beginning_of_month
    legacy_hash = { "CHECK_NUMBER"=>"199001.0",
                    "ACCOUNT_NUMBER"=>"5142.0",
                    "PAYEE"=>"KEVIN RUSSELL                    ",
                    "AMOUNT" => "100.0" }
    assert bi = BatchImport.convert_imported_legacy_check(legacy_hash, beginning_of_month)
    assert_equal bi.document_number, 199001
    assert_equal bi.account_number, "5142"
    assert_equal bi.payee, "KEVIN RUSSELL"
    assert_equal bi.accountable_type, "legacy check"
    assert_equal bi.accountable_id, 199001
    assert_equal bi.amount, 100.00.to_d
    assert_equal bi.recorded_on, Time.new.beginning_of_month
  end
  
end
