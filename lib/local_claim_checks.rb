require 'fastercsv'

class LocalClaimChecks
  
  def retrieve_checks
    FasterCSV.read( File.dirname(__FILE__) + "/../bmic/claim_checks.csv" ) 
  end
  
end