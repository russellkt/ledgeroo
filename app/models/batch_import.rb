require 'fastercsv'
class BatchImport < ActiveRecord::Base  
  
  belongs_to :batch
  
  def self.import_claim_checks
    checks_array = import_checks( CLAIM_CHECKS_SRC )
    batch_claim_imports = checks_array.collect{ |check_hash| convert_imported_claim( check_hash ) }
  end
  
  def self.convert_imported_claim claim_hash
    BatchImport.new( :accountable_id   => claim_hash['CLAIM_ID'].to_i,
                     :accountable_type => 'claim check',
                     :document_number  => claim_hash['CHECK_NUMBER'].to_i,
                     :recorded_on      => date_from_as400_date_fields( claim_hash['CHECK_YEAR'], claim_hash['CHECK_MONTH'], claim_hash['CHECK_DAY'] ),
                     :payee            => claim_hash['PAYEE'].to_s.rstrip,
                     :account_number   => claim_hash['ACCOUNT_NUMBER'].to_s.rstrip,
                     :amount           => claim_hash['AMOUNT'].to_d )
  end
  
  def self.date_from_as400_date_fields year, month, day
    date_string = "#{year.to_i + 2000}-#{month.to_i}-#{day.to_i}"
    return Date.parse(date_string)
  end
  
  def self.last_claim_check_number
    maximum( :document_number, :conditions => "accountable_type = 'claim check'" ).to_i
  end
  
  def self.import_legacy_checks
    checks_array = import_checks( LEGACY_CHECKS_SRC )
    beginning_of_month = Time.new.beginning_of_month
    batch_claim_imports = checks_array.collect{ |check_hash| convert_imported_legacy_check( check_hash, beginning_of_month ) }  
  end
  
  def self.convert_imported_legacy_check legacy_hash, beginning_of_month
    BatchImport.new( :accountable_id   => legacy_hash['CHECK_NUMBER'].to_i,
                     :accountable_type => 'legacy check',
                     :document_number  => legacy_hash['CHECK_NUMBER'].to_s.to_i,
                     :recorded_on      => beginning_of_month,
                     :payee            => legacy_hash['PAYEE'].to_s.rstrip,
                     :account_number   => legacy_hash['ACCOUNT_NUMBER'].to_i.to_s.rstrip,
                     :amount           => legacy_hash['AMOUNT'].to_d )
  end
  
  def self.import_checks checks_src
    checks = checks_src.retrieve_checks
    fields = checks.shift
    checks_array = checks.collect{ |record| Hash[*fields.zip(record).flatten ] }
    checks_array
  end
  
  def create_accounting_transaction
    entry_attributes = [ {'debit' => amount, 'account_number' => account_number.to_i.to_s },
                         {'credit' => amount, 'account_number' => '1104' } ]
    at = AccountingTransaction.new( :recorded_on => recorded_on, :name => payee, :accountable_id => accountable_id, 
                                    :accountable_type => accountable_type, :document_number => document_number,
                                    :transaction_type => 'check', :new_entry_attributes => entry_attributes )
  end
  
end
