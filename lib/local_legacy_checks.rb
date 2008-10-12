require 'fastercsv'

class LocalLegacyChecks
  
  def retrieve_checks
    FasterCSV.read( File.dirname(__FILE__) + "/../bmic/legacy_checks.csv" ) 
  end
  
end