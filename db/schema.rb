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

ActiveRecord::Schema.define(version: 20150104033943) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "campaign", primary_key: "campaignid", force: true do |t|
    t.integer  "charityid",                                           null: false
    t.string   "title",         limit: 500
    t.string   "description",   limit: 5000
    t.decimal  "raiseamount",                precision: 19, scale: 4
    t.datetime "startdate"
    t.datetime "enddate"
    t.integer  "isapproved",    limit: 2
    t.integer  "isactive",      limit: 2
    t.decimal  "currentamount",              precision: 19, scale: 4
    t.integer  "userid"
  end

  create_table "charity", primary_key: "charityid", force: true do |t|
    t.string   "charityname",         limit: 50
    t.string   "website",             limit: 500
    t.string   "logo",                limit: 1000
    t.string   "description",         limit: 5000
    t.string   "facebookurl",         limit: 500
    t.string   "twitterurl",          limit: 500
    t.string   "googleplusurl",       limit: 500
    t.string   "contantname",         limit: 500
    t.string   "email",               limit: 500
    t.integer  "isapproved",          limit: 2
    t.integer  "isfeatured",          limit: 2
    t.integer  "userid"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "logoimage",           limit: 500
  end

  create_table "facebook_user", force: true do |t|
    t.string "first_name", limit: 100
    t.string "last_name",  limit: nil
    t.string "email",      limit: nil
    t.string "location",   limit: 100
    t.string "uid",        limit: 100
    t.string "image",      limit: 500
    t.string "gender",     limit: 50
    t.date   "birthday"
    t.string "url",        limit: 500
    t.string "locale",     limit: 100
    t.string "username",   limit: nil
    t.string "time_zone",  limit: 50
  end

  create_table "merchant", primary_key: "merchantid", force: true do |t|
    t.string "merchantname",    limit: 500,  null: false
    t.string "logo",            limit: 50
    t.string "checkbalanceurl", limit: 1000
    t.string "phonenumber",     limit: 50
    t.string "description",     limit: 500
  end

  create_table "user", primary_key: "userid", force: true do |t|
    t.string   "gender",        limit: 1
    t.date     "birthdate"
    t.datetime "created"
    t.datetime "modified"
    t.string   "email",         limit: 50
    t.string   "firstname",     limit: 50
    t.string   "lastname",      limit: 50
    t.string   "password_hash", limit: 1000
    t.string   "salt",          limit: 1000
  end

  create_table "widgets", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "stock"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
