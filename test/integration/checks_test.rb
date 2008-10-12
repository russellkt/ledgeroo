require File.dirname(__FILE__) + '/../integration/needing_fixtures_test'

class ChecksTest < NeedingFixturesTest
  def setup
    @check_params = { "recorded_on(1i)"=>"2007", 
                       "recorded_on(2i)"=>"12", 
                       "recorded_on(3i)"=>"4", 
                       "name"=>"Kevin Russell",
                       "document_number"=>"15" }
    @credit_params = { "account_id"=>"1",
                      "credit"=>"1500", 
                      "id"=>"1" } 
    @debit_params =  [ {"debit"=>"1000", "account_id"=>"2", "memo"=>""}, 
                     {"debit"=>"500", "account_id"=>"3", "memo"=>""},
                     {"debit"=>"", "account_id"=>"3", "memo"=>""},
                     {"debit"=>"", "account_id"=>"3", "memo"=>""} ]
  end
  def test_new
    get new_check_url
    assert_response :success
    assert_template 'checks/new'
    assert_equal 4, elements('.entryrow').length # there should be four debit entries on the default form
    assert_equal 1, elements('.creditentry').length # there should be one credit entry on the default form
    account_select = element('#debit_entries__account_id')
    assert account_select
    assert account_select/'option'
  end
  def test_save_and_new
    post checks_url, { :check => @check_params,
                      :credit_entry => @credit_params,
                      :debit_entries => @debit_params,
                      :commit => "Save and new" }
    assert check = AccountingTransaction.find_by_transaction_type( 'check' )
    assert_response :redirect
    follow_redirect!
    assert_template 'new'
  end
  def test_save
    post checks_url, { :check => @check_params,
                      :credit_entry => @credit_params,
                      :debit_entries => @debit_params,
                      :commit => "Save" }
    assert check = AccountingTransaction.find_by_transaction_type( 'check' )
    assert_response :redirect
    follow_redirect!
    assert_template 'index'
  end
  def test_update
    debit_params = {"2"=>{"debit"=>"5000", "account_id"=>"2", "memo"=>""}}
    get checks_url(:id=>1)
    post "/checks/update", { :check=>@check_params,
                             :credit_entry => @credit_params,
                             :debit_entries => debit_params,
                             :id => "1",
                             :method=>"_put" }
    assert_response :success
    assert_template 'edit'
    assert elements('.errorExplanation')/'p'
    debit_params = {"2"=>{"debit"=>"1500", "account_id"=>"2", "memo"=>""}}
    get checks_url(:id=>1)
    post "/checks/update", { :check=>@check_params,
                             :credit_entry => @credit_params,
                             :debit_entries => debit_params,
                             :id => "1",
                             :method=>"_put" }
    assert_response :redirect
  end
end
