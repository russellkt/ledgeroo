class AddFinalizedToBatches < ActiveRecord::Migration
  def self.up
    add_column :batches, :finalized, :boolean, :default => false
  end

  def self.down
    remove_column :batches, :finalized
  end
end
