class AddTotalToAccountingTransaction < ActiveRecord::Migration
  def self.up
    add_column :accounting_transactions, :total, :decimal, :precision => 10, :scale => 2
  end

  def self.down
    remove_column :accounting_transactions, :total
  end
end
