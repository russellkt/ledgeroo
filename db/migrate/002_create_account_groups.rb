class CreateAccountGroups < ActiveRecord::Migration
  def self.up
    create_table :account_groups, :force => true do |t|
      t.column :name, :string
      t.column :is_debit, :boolean, :default => false
      t.column :is_credit, :boolean, :default => false
    end
  end

  def self.down
    drop_table :account_groups
  end
end
