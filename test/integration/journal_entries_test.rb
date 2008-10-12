require File.dirname(__FILE__) + '/../integration/needing_fixtures_test'

class JournalEntryTest < NeedingFixturesTest
  def setup
    @controller = JournalEntriesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  def test_new
    get new_journal_entry_url
    assert_response :success
    assert_template 'new'
    assert assigns(:journal_entry)
    assert 5, assigns(:entries).size
  end
  def test_show
    get journal_entry_url(:id=>2)
    assert_response :success
    assert_template 'show'
  end
  def test_edit
    get '/journal_entries/2;edit'
    assert_response :success
    assert_equal 2, assigns(:entries).size
    assert assigns(:journal_entry)
  end
  def test_update
    @journal_entry = accounting_transactions(:journal_entry)
    debit = accounting_entries(:journal_entry_debit).attributes
    credit = accounting_entries(:journal_entry_credit).attributes
    entries_params = {}
    entries_params[debit['id']] = debit.merge({'debit'=>2000.0})
    entries_params[credit['id']] = credit.merge({'credit'=>2000.0})
    post '/journal_entries/update', { :journal_entry=>@journal_entry.attributes,
                   :entries=>entries_params,
                   :id => "2",
                   :method => "put" }
    assert_response :redirect
    assert_equal @journal_entry.total_debits, 2000                        
  end
  def test_unbalanced_update
    journal_entry = accounting_transactions(:journal_entry)
    debit = accounting_entries(:journal_entry_debit).attributes
    credit = accounting_entries(:journal_entry_credit).attributes
    entries_params = {}
    entries_params[debit['id']] = debit
    entries_params[credit['id']] = credit.merge({'credit'=>2000.0})
    put :update, { :journal_entry=>journal_entry.attributes,
                   :entries=>entries_params,
                   :id => "2" }
    assert_response :success
    assert elements('.errorExplanation')/'p'
    assert_template 'edit'
  end
end