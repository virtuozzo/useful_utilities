class CreateNestedCounts < ActiveRecord::Migration
  def change
    create_table :nested_counts do |t|
      t.integer :count_id, null: false
      t.integer :y, default: 0
      t.timestamps
    end
  end
end