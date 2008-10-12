require "#{File.dirname(__FILE__)}/../test_helper"

class RoutesTest < ActionController::IntegrationTest
  
  def test_transactions_route
    route "transactions"
  end
  private
  def route name
    get "#{name}/"
    assert_response :success
    get "#{name}/new"
    assert_response :success  
  end

end
