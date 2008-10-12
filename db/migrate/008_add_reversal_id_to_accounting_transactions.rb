class AddReversalIdToAccountingTransactions < ActiveRecord::Migration
  def self.up
    add_column :accounting_transactions, :reversal_id, :integer
  end

  def self.down
    remove_column :accounting_transactions, :reversal_id
  end
end
