class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.column :name, :text
      t.column :description, :text
      t.column :account_type_id, :integer
      t.column :number, :text
      t.column :bank_number, :text
      t.column :is_inactive, :boolean, :default => false
      t.column :parent_id, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :company_id, :integer
    end
  end

  def self.down
    drop_table :accounts
  end
end
