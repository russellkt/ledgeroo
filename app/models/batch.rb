# == Schema Information
# Schema version: 13
#
# Table name: batches
#
#  id         :integer         not null, primary key
#  date       :date            
#  created_at :datetime        
#  updated_at :datetime        
#  finalized  :boolean         
#
require 'fastercsv'

class Batch < ActiveRecord::Base
  has_many :accounting_transactions, :dependent => :destroy, :order => "document_number asc"
  has_many :accounting_entries,      :through   => :accounting_transactions
  has_many :batch_imports,           :dependent => :destroy

  def import_claim_checks
    BatchImport.import_claim_checks.each do |imported_check|
      batch_imports << imported_check
      accounting_transactions << imported_check.create_accounting_transaction
    end
  end
  
  def import_legacy_checks
    BatchImport.import_legacy_checks.each do |imported_check|
      batch_imports << imported_check
      accounting_transactions << imported_check.create_accounting_transaction
    end
  end

  def self.any_unfinalized?
    find_by_finalized(false)
  end
  
  def is_finalized?
    finalized
  end

  def total_credits
    accounting_entries.sum(:credit).to_f
  end

  def total_debits
    accounting_entries.sum(:debit).to_f
  end

  def difference
    total_credits - total_debits
  end
end