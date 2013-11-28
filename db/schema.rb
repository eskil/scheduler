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

ActiveRecord::Schema.define(version: 20131127235543) do

  create_table "activities", force: true do |t|
    t.string   "name"
    t.string   "vendor"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schedules", force: true do |t|
    t.integer  "activity_id"
    t.boolean  "recurring",   default: false
    t.boolean  "on_sun",      default: false
    t.boolean  "on_mon",      default: false
    t.boolean  "on_tue",      default: false
    t.boolean  "on_wed",      default: false
    t.boolean  "on_thu",      default: false
    t.boolean  "on_fri",      default: false
    t.boolean  "on_sat",      default: false
    t.date     "date_at"
    t.integer  "time_at"
    t.integer  "slots"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
