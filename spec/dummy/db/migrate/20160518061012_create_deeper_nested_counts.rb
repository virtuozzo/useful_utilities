class CreateDeeperNestedCounts < ActiveRecord::Migration
  def change
    create_table :deeper_nested_counts do |t|
      t.integer :count_id, null: false
      t.integer :nested_count_id, null: false
      t.integer :z, default: 0
      t.timestamps
    end
  end
end