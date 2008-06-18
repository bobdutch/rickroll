# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 5) do

  create_table "hits", :force => true do |t|
    t.string   "referrer"
    t.integer  "roll_id",                   :null => false
    t.integer  "count",      :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hits", ["roll_id", "referrer"], :name => "index_hits_on_roll_id_and_referrer", :unique => true

  create_table "rolls", :force => true do |t|
    t.string   "destination_url",    :limit => 2083
    t.string   "snip_url"
    t.string   "roll_url",           :limit => 2083
    t.integer  "probability"
    t.integer  "hits_until_expired"
    t.integer  "user_id"
    t.datetime "expires_at"
    t.boolean  "expired",                            :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rolls", ["user_id"], :name => "index_rolls_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "country"
    t.string   "gender"
    t.integer  "number_of_rolls"
    t.integer  "age"
    t.string   "email"
    t.string   "password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
