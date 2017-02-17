# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160518061012) do

  create_table "counts", force: :cascade do |t|
    t.integer  "i"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "deeper_nested_counts", force: :cascade do |t|
    t.integer  "count_id",                    null: false
    t.integer  "nested_count_id",             null: false
    t.integer  "z",               default: 0
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "nested_counts", force: :cascade do |t|
    t.integer  "count_id",               null: false
    t.integer  "y",          default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

end
