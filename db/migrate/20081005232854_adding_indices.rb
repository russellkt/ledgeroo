class AddingIndices < ActiveRecord::Migration
  @entry_fields_needing_indexed = ['account_id','accounting_transaction_id','accountable_id']
  @transaction_fields_needing_indexed = ['transaction_type','batch_id','accountable_id']
  def self.up
    @entry_fields_needing_indexed.each{ |f| add_index( :accounting_entries, f )}
    @transaction_fields_needing_indexed.each{ |f| add_index( :accounting_transactions, f )}
  end

  def self.down
    @entry_fields_needing_indexed.each{ |f| remove_index( :accounting_entries, f )}
    @transaction_fields_needing_indexed.each{ |f| remove_index (:accounting_transactions, f )}
  end
end
