require File.dirname(__FILE__) + "/../test_helper"
class BatchImportTest < ActiveSupport::TestCase
  
  def test_retrieve_checks_should_retrieve_checks_from_sample_csv_file
    lc = LocalLegacyChecks.new
    assert lc.retrieve_checks[1]
  end
  
end