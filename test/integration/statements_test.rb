require File.dirname(__FILE__) + '/../integration/needing_fixtures_test'

class StatementsTest < NeedingFixturesTest
  
  def test_new
    get "/statements/new"
    assert_response :success
    assert_template 'statements/new'
    account_select = elements('#statement_account_id')
    assert account_select
    assert account_select/'option'
  end
  def test_create
    statement_params = { "started_on(1i)"=>"2007", 
                         "started_on(2i)"=>"1", 
                         "started_on(3i)"=>"4",
                         "beginning_balance"=>"0",
                         "ending_balance"=>"5000",
                         "account_id"=>"1"}
    post "/statements", { :statement => statement_params }
    assert_response :redirect
    follow_redirect!
    assert_template 'show'
    assert Statement.find(:all).size > 1
  end
  def test_edit
    get "/statements/1;edit"
    assert_response :success
    assert_template 'edit'
    entries_checkboxes = elements('.statement_entries')
    assert 1, entries_checkboxes.size
  end
  def test_update
    post "/statements/1", { "entries"=>["1"], "_method"=>"put", "id"=>"1" }
    assert_response :redirect
    follow_redirect!
    assert_template 'show'
    assert_equal 0,Account.find(1).uncleared_entries.size
    get "statements/1;edit"
    assert_response :success
    assert_template 'edit'
    entries_checkboxes = elements('.statement_entries')
    assert 1, entries_checkboxes.size
    post "/statements/1", { "_method"=>"put", "id"=>"1" }
    assert_response :redirect
    follow_redirect!
  end
end