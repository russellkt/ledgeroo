class CreateAccountTypes < ActiveRecord::Migration
  def self.up
    create_table :account_types, :force => true do |t|
      t.column :name, :string
      t.column :account_group_id, :integer
    end
  end

  def self.down
    drop_table :account_types
  end
end
