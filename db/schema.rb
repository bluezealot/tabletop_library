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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130815041647) do

  create_table "attendees", :id => false, :force => true do |t|
    t.string   "barcode",                       :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "enforcer",   :default => false
    t.string   "handle"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "checkouts", :force => true do |t|
    t.string   "game_id"
    t.string   "attendee_id"
    t.integer  "pax_id"
    t.datetime "check_out_time"
    t.datetime "return_time"
    t.boolean  "closed",         :default => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "games", :id => false, :force => true do |t|
    t.string   "barcode",                       :null => false
    t.integer  "title_id"
    t.integer  "loaner_id"
    t.integer  "section_id", :default => 1
    t.boolean  "checked_in", :default => true
    t.boolean  "returned",   :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "loaners", :force => true do |t|
    t.string   "name"
    t.string   "contact"
    t.string   "phone_number"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "notes", :force => true do |t|
    t.integer  "game_id"
    t.string   "text"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "paxes", :force => true do |t|
    t.string   "name"
    t.string   "location"
    t.date     "start"
    t.date     "end"
    t.boolean  "current",    :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "publishers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sections", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "titles", :force => true do |t|
    t.string   "title"
    t.integer  "publisher_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "user_name"
    t.string   "password_digest"
    t.string   "remember_token"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

end
