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


ActiveRecord::Schema.define(version: 20170309114916) do

  create_table "authentication_tokens", force: :cascade do |t|
    t.string   "body",         limit: 255
    t.integer  "user_id",      limit: 4
    t.datetime "last_used_at"
    t.string   "ip_address",   limit: 255
    t.string   "user_agent",   limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "authentication_tokens", ["user_id"], name: "index_authentication_tokens_on_user_id", using: :btree

  create_table "bookings", force: :cascade do |t|
    t.string   "status",         limit: 255, default: "processing", null: false
    t.integer  "user_id",        limit: 4
    t.string   "user_name",      limit: 255
    t.string   "user_cell",      limit: 255
    t.string   "user_email",     limit: 255
    t.string   "user_signature", limit: 255
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
  end

  create_table "line_items", force: :cascade do |t|
    t.integer  "order_id",   limit: 4
    t.string   "name",       limit: 255
    t.integer  "quantity",   limit: 4
    t.string   "image",      limit: 255
    t.integer  "price",      limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "locations", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.decimal  "lat",                         precision: 15, scale: 10
    t.decimal  "lon",                         precision: 15, scale: 10
    t.integer  "place_id",        limit: 4
    t.integer  "locateable_id",   limit: 4
    t.string   "locateable_type", limit: 255
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.string   "address",         limit: 255,                           null: false
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "booking_id",          limit: 4
    t.boolean  "pay_by_sender"
    t.text     "instruction",         limit: 65535
    t.integer  "amount",              limit: 4
    t.string   "tracking_id",         limit: 255
    t.string   "status",              limit: 255,   default: "processing", null: false
    t.integer  "driver_id",           limit: 4
    t.integer  "recipient_id",        limit: 4
    t.string   "recipient_name",      limit: 255
    t.string   "recipient_cell",      limit: 255
    t.string   "recipient_email",     limit: 255
    t.string   "recipient_signature", limit: 255
    t.integer  "small",               limit: 4
    t.integer  "medium",              limit: 4
    t.integer  "large",               limit: 4
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
  end

  create_table "social_logins", force: :cascade do |t|
    t.string   "platform_name",     limit: 255
    t.string   "authentication_id", limit: 255
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "user_id",           limit: 4
  end

  add_index "social_logins", ["user_id"], name: "index_social_logins_on_user_id", using: :btree

  create_table "time_slots", force: :cascade do |t|
    t.date     "date"
    t.string   "start_time", limit: 255
    t.string   "end_time",   limit: 255
    t.integer  "charges",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "name",                   limit: 255
    t.string   "password",               limit: 255
    t.string   "cell",                   limit: 255
    t.boolean  "verified",                           default: false
    t.string   "verified_token",         limit: 255
    t.string   "role",                   limit: 255
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "authentication_tokens", "users"
  add_foreign_key "social_logins", "users"
end
