require 'fastercsv'
require 'httparty'

class RemoteLegacyChecks
  include HTTParty
  
  def initialize uri
    self.class.base_uri uri
  end
  
  def retrieve_checks
    last_claim_check_number = BatchImport.last_claim_check_number
    checks_csv = self.class.get( '/legacyChecks.groovy' )
    FasterCSV.parse(checks_csv)
  end
  
end