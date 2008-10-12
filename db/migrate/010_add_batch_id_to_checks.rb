class AddBatchIdToChecks < ActiveRecord::Migration
  def self.up
    add_column :accounting_transactions, :batch_id, :integer
  end

  def self.down
    remove_column :accounting_transactions, :batch_id
  end
end
