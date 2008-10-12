class CreateBatchImports < ActiveRecord::Migration
  def self.up
    create_table :batch_imports do |t|
      t.integer     :batch_id
      t.integer     :accountable_id
      t.string      :accountable_type
      t.string      :document_number
      t.date        :recorded_on
      t.string      :payee
      t.string      :account_number
      t.decimal     :amount, :precision => 10, :scale => 2
      t.timestamps
    end
  end

  def self.down
    drop_table :batch_imports
  end
end