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

ActiveRecord::Schema.define(version: 20150105185049) do

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
    t.string   "contactname",         limit: 500
    t.string   "email",               limit: 500
    t.integer  "isapproved",          limit: 2
    t.integer  "isfeatured",          limit: 2
    t.integer  "userid"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.datetime "created"
    t.datetime "modified"
    t.string   "image1_file_name"
    t.string   "image1_content_type"
    t.integer  "image1_file_size"
    t.datetime "image1_updated_at"
    t.string   "image2_file_name"
    t.string   "image2_content_type"
    t.integer  "image2_file_size"
    t.datetime "image2_updated_at"
    t.string   "image3_file_name"
    t.string   "image3_content_type"
    t.integer  "image3_file_size"
    t.datetime "image3_updated_at"
  end

  create_table "merchant", primary_key: "merchantid", force: true do |t|
    t.string "merchantname",    limit: 500,  null: false
    t.string "logo",            limit: 50
    t.string "checkbalanceurl", limit: 1000
    t.string "phonenumber",     limit: 50
    t.string "description",     limit: 500
  end

  create_table "user", primary_key: "userid", force: true do |t|
    t.string   "gender",           limit: 50
    t.datetime "created"
    t.datetime "modified"
    t.string   "email",            limit: 50
    t.string   "firstname",        limit: 50
    t.string   "lastname",         limit: 50
    t.string   "password_hash",    limit: 1000
    t.string   "salt",             limit: 1000
    t.string   "location",         limit: 250
    t.string   "provider",         limit: 100
    t.string   "imageurl",         limit: 500
    t.date     "birthday"
    t.string   "providerurl",      limit: 250
    t.string   "locale",           limit: 250
    t.string   "providerusername", limit: 250
    t.string   "timezone",         limit: 50
    t.string   "provideruid",      limit: 100
  end

  create_table "widgets", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "stock"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
