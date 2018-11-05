class CreateNestedCounts < ActiveRecord::Migration[4.2]
  def change
    create_table :nested_counts do |t|
      t.integer :count_id, null: false
      t.integer :y, default: 0

      t.timestamps null: false
    end
  end
end
