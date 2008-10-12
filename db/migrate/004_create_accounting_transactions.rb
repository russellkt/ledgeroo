class CreateAccountingTransactions < ActiveRecord::Migration
  def self.up
    create_table :accounting_transactions, :force => true do |t|
      t.column :name, :string
      t.column :document_id, :integer
      t.column :document_number, :integer
      t.column :memo, :string
      t.column :recorded_on, :date
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :transaction_type, :string
      t.column :is_void, :boolean, :default => false
      t.column :department_id, :integer
      t.column :class_id, :integer
      t.column :location_id, :integer
      t.column :accountable_type, :string
      t.column :accountable_id, :integer
    end
  end

  def self.down
    drop_table :accounting_transactions
  end
end
