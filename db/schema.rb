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

ActiveRecord::Schema.define(version: 20131126044401) do

  create_table "activities", force: true do |t|
    t.string   "name"
    t.string   "vendor"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "on_mon"
    t.boolean  "on_tue"
    t.boolean  "on_wed"
    t.boolean  "on_thu"
    t.boolean  "on_fri"
    t.boolean  "on_sat"
    t.boolean  "on_sun"
  end

end
