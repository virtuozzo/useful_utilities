class CreateCounts < ActiveRecord::Migration
  def change
    create_table :counts do |t|
      t.integer :i

      t.timestamps
    end
  end
end