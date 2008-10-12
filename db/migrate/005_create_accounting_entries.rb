class CreateAccountingEntries < ActiveRecord::Migration
  def self.up
    create_table :accounting_entries, :force => true do |t|
      t.column :accounting_transaction_id, :integer
      t.column :account_id, :integer
      t.column :debit, :decimal, :precision => 10, :scale => 2
      t.column :credit, :decimal, :precision => 10, :scale => 2
      t.column :memo, :string
      t.column :has_cleared, :boolean, :default => false
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :accountable_id, :integer
      t.column :accountable_type, :string
    end
  end

  def self.down
    drop_table :accounting_entries
  end
end
