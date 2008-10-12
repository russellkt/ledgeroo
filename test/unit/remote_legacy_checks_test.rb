require File.dirname(__FILE__) + "/../test_helper"
class RemoteLegacyChecksTest < ActiveSupport::TestCase
  
  def test_retrieve_checks_should_return_array_of_claim_checks
    remote = RemoteLegacyChecks.new( 'localhost:8081/BmicExtended' )
    assert csv = remote.retrieve_checks[1]
    assert csv.is_a?(Array)
  end
  
end