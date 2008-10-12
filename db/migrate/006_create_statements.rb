class CreateStatements < ActiveRecord::Migration
  def self.up
    create_table :statements do |t|
      t.column :account_id, :integer
      t.column :started_on, :date
      t.column :ended_on, :date
      t.column :beginning_balance, :decimal, :precision => 10, :scale => 2
      t.column :ending_balance, :decimal, :precision => 10, :scale => 2
      t.column :is_closed, :boolean
    end
  end

  def self.down
    drop_table :statements
  end
end
