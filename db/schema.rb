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

ActiveRecord::Schema.define(version: 20131130224054) do

  create_table "activities", force: true do |t|
    t.string   "name"
    t.string   "vendor"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: true do |t|
    t.date     "date_at"
    t.integer  "time_at"
    t.integer  "spots"
    t.integer  "activity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["activity_id"], name: "index_events_on_activity_id", using: :btree
  add_index "events", ["date_at"], name: "index_events_on_date_at", using: :btree
  add_index "events", ["time_at"], name: "index_events_on_time_at", using: :btree

  create_table "schedules", force: true do |t|
    t.integer  "activity_id"
    t.boolean  "on_sun",      default: false
    t.boolean  "on_mon",      default: false
    t.boolean  "on_tue",      default: false
    t.boolean  "on_wed",      default: false
    t.boolean  "on_thu",      default: false
    t.boolean  "on_fri",      default: false
    t.boolean  "on_sat",      default: false
    t.date     "date_at"
    t.integer  "time_at"
    t.integer  "spots"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "schedules", ["activity_id"], name: "index_schedules_on_activity_id", using: :btree
  add_index "schedules", ["date_at"], name: "index_schedules_on_date_at", using: :btree
  add_index "schedules", ["on_fri"], name: "index_schedules_on_on_fri", using: :btree
  add_index "schedules", ["on_mon"], name: "index_schedules_on_on_mon", using: :btree
  add_index "schedules", ["on_sat"], name: "index_schedules_on_on_sat", using: :btree
  add_index "schedules", ["on_sun"], name: "index_schedules_on_on_sun", using: :btree
  add_index "schedules", ["on_thu"], name: "index_schedules_on_on_thu", using: :btree
  add_index "schedules", ["on_tue"], name: "index_schedules_on_on_tue", using: :btree
  add_index "schedules", ["on_wed"], name: "index_schedules_on_on_wed", using: :btree

end
