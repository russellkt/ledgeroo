require 'fastercsv'
require 'httparty'

class RemoteClaimChecks
  include HTTParty
  
  def initialize uri
    self.class.base_uri uri
  end
  
  def retrieve_checks
    last_claim_check_number = BatchImport.last_claim_check_number
    last_claim_check_number = 199379 if last_claim_check_number < 100
    checks_csv = self.class.get( '/claimChecks.groovy', :query => {:lastCheck => last_claim_check_number} )
    FasterCSV.parse(checks_csv)
  end
  
end