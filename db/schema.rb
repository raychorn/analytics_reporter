# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100903233746) do

  create_table "area_codes", :primary_key => "area_code", :force => true do |t|
    t.string  "location",     :limit => 50, :null => false
    t.string  "city",         :limit => 30
    t.string  "country",      :limit => 30
    t.date    "service_date"
    t.string  "time_zone",    :limit => 10
    t.integer "prior_code"
  end

  add_index "area_codes", ["area_code"], :name => "index_area_code"

  create_table "daily_handset_swap", :id => false, :force => true do |t|
    t.date    "server_date"
    t.string  "hand_set_from",          :limit => 100
    t.string  "hand_set_sw_rel_from",   :limit => 100
    t.string  "hand_set_firmware_from", :limit => 100
    t.string  "hand_set_to",            :limit => 100
    t.string  "hand_set_sw_rel_to",     :limit => 100
    t.string  "hand_set_firmware_to",   :limit => 100
    t.integer "server_count"
  end

  create_table "daily_provisions", :force => true do |t|
    t.date     "server_date"
    t.integer  "server_count"
    t.string   "server_handset"
    t.string   "server_release"
    t.string   "server_version"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "daily_swaps", :force => true do |t|
    t.date     "server_date"
    t.integer  "cumm_count"
    t.integer  "inc_count"
    t.string   "from_handset"
    t.string   "from_release"
    t.string   "from_version"
    t.string   "to_handset"
    t.string   "to_release"
    t.string   "to_version"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "geographic_provisions", :force => true do |t|
    t.date     "service_date"
    t.integer  "service_hour"
    t.integer  "handset_count"
    t.integer  "area_code"
    t.string   "handset"
    t.string   "server_version"
    t.string   "sw_release"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "first_name",                :limit => 80
    t.string   "last_name",                 :limit => 80
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
  end

end
