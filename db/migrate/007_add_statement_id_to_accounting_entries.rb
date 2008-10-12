class AddStatementIdToAccountingEntries < ActiveRecord::Migration
  def self.up
    add_column :accounting_entries, :statement_id, :integer
  end

  def self.down
    remove_column :accounting_entries, :statement_id
  end
end
