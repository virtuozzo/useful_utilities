# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2016_05_18_061012) do

  create_table "counts", force: :cascade do |t|
    t.integer "i"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "deeper_nested_counts", force: :cascade do |t|
    t.integer "count_id", null: false
    t.integer "nested_count_id", null: false
    t.integer "z", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "nested_counts", force: :cascade do |t|
    t.integer "count_id", null: false
    t.integer "y", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
