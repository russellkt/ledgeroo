require File.dirname(__FILE__) + "/../test_helper"
class RemoteClaimChecksTest < ActiveSupport::TestCase
  fixtures :batch_imports
  
  def test_retrieve_checks_should_return_array_of_claim_checks
    remote = RemoteClaimChecks.new( 'localhost:8081/NewPolicies' )
    assert csv = remote.retrieve_checks
    assert csv.is_a?( Array )
  end
end