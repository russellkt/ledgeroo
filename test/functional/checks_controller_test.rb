require File.dirname(__FILE__) + '/../test_helper'
require 'checks_controller'
require 'authenticated_test_helper'
# Re-raise errors caught by the controller.
class ChecksController; def rescue_action(e) raise e end; end

class ChecksControllerTest < Test::Unit::TestCase
  fixtures :users, :accounts, :account_types, :account_groups, :roles,
           :accounting_transactions, :accounting_entries

  include AuthenticatedTestHelper
  def setup
    @controller = ChecksController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login_as( :quentin )
    @check = accounting_transactions(:checking_expense)
  end

  def test_new_should_be_success
    get :new
    assert_response :success
    assert_template 'new'
  end

  def test_void_should_void_check_and_redirect_to_checks_url
    post :void, :id => '1'
    assert_redirected_to( {"action"=>"index", "controller"=>"checks"} )
    @check.reload
    assert @check.is_void?
  end

end
