require File.dirname(__FILE__) + '/../integration/needing_fixtures_test'

class AccountsTest < NeedingFixturesTest

  def setup
    @controller = AccountsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login_as :quentin
  end

  def test_should_get_index
    get 'accounts'
    assert_response :success
  end

  def test_new
    get 'accounts/new'
    assert_response :success
    assert_equal 17, assigns(:account_types).size
    assert assigns(:accounts)
    assert assigns(:parent_accounts)
  end

  def test_should_get_edit
    get 'accounts/1;edit'
    assert_response :success

  end
end