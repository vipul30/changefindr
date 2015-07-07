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

ActiveRecord::Schema.define(version: 20150127233247) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: true do |t|
    t.string   "company_name", limit: 500
    t.string   "api_key",      limit: 200
    t.string   "company_url",  limit: 500
    t.datetime "created"
    t.datetime "modified"
    t.integer  "is_active",    limit: 2
  end

  create_table "bhnacquire", primary_key: "bhnacquireid", force: true do |t|
    t.integer  "donationid"
    t.datetime "created"
    t.datetime "responseTimestamp"
    t.float    "actualCardValue"
    t.float    "exchangeCardValue"
    t.string   "transactionId",     limit: 500
    t.string   "errorCode",         limit: 100
    t.string   "errorMessage",      limit: 1000
    t.string   "customerId",        limit: 500
    t.string   "responsecode",      limit: 100
    t.string   "isCompleted",       limit: 100
  end

  create_table "bhnmerchantcrossref", primary_key: "crossrefid", force: true do |t|
    t.string "ProductLine",        limit: 500
    t.string "ProductLineID",      limit: 500
    t.string "CardPoolMerchantID", limit: 500
  end

  create_table "bhnquote", primary_key: "bhnquoteid", force: true do |t|
    t.integer  "giftcardid"
    t.datetime "responseTimestamp"
    t.datetime "created"
    t.float    "actualCardValue"
    t.float    "exchangeCardValue"
    t.string   "transactionId",     limit: 500
    t.string   "responsecode",      limit: 50
    t.string   "errorCode",         limit: 1000
    t.string   "errorMessage",      limit: 1000
  end

  create_table "blog_comments", force: true do |t|
    t.integer "blog_id"
    t.string  "first_name", limit: nil
    t.string  "last_name",  limit: nil
    t.string  "email",      limit: 100
    t.string  "comment",    limit: 50000
    t.integer "user_id"
  end

  create_table "blogs", primary_key: "blog_id", force: true do |t|
    t.string   "title",       limit: 500
    t.string   "first_name",  limit: 100
    t.string   "last_name",   limit: 100
    t.string   "email",       limit: 100
    t.string   "description", limit: 50000
    t.integer  "user_id"
    t.datetime "created"
    t.datetime "modified"
    t.integer  "is_active",   limit: 2
    t.string   "keywords",    limit: 1000
  end

  create_table "campaigns", primary_key: "campaignid", force: true do |t|
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
    t.integer  "account_id"
    t.integer  "is_listed",           limit: 2
  end

  create_table "donations", primary_key: "donationid", force: true do |t|
    t.integer  "charityid"
    t.integer  "giftcardid"
    t.integer  "userid"
    t.datetime "created"
    t.datetime "modified"
    t.integer  "donationwall", limit: 2
    t.string   "firstname",    limit: 100
    t.string   "lastname",     limit: nil
    t.string   "comments",     limit: 1000
    t.string   "email",        limit: 100
  end

  create_table "giftcards", primary_key: "giftcardid", force: true do |t|
    t.integer  "merchantid"
    t.datetime "created"
    t.datetime "modified"
    t.string   "encrypted_cardnumber", limit: 1000
    t.date     "expdate"
    t.string   "eventnumber",          limit: 100
    t.float    "balance"
    t.integer  "userid"
    t.datetime "balancecheckdate"
    t.integer  "isdeleted",            limit: 2
    t.integer  "isdonated",            limit: 2
    t.string   "encrypted_pin",        limit: 500
  end

  create_table "giftcardstats", primary_key: "statsid", force: true do |t|
    t.string "description", limit: 5000
  end

  create_table "merchants", primary_key: "merchantid", force: true do |t|
    t.integer  "merchantid_bak",                 null: false
    t.string   "merchantname",      limit: 500,  null: false
    t.string   "logo",              limit: 50
    t.string   "checkbalanceurl",   limit: 1000
    t.string   "phonenumber",       limit: 50
    t.string   "description",       limit: 500
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "entityId",          limit: 1000
    t.string   "productLineName",   limit: 500
    t.string   "brandId",           limit: 500
    t.string   "brandCode",         limit: 500
    t.string   "brandLogoImage",    limit: 1000
    t.string   "productLineStatus", limit: 500
    t.string   "accountType",       limit: 500
    t.datetime "startDate"
    t.datetime "endDate"
    t.string   "locale",            limit: 100
    t.string   "entityIdUrl",       limit: 1000
    t.datetime "modified"
    t.float    "minAcceptedValue"
    t.float    "maxAcceptedValue"
    t.float    "discount"
    t.integer  "productLineId"
  end

  create_table "newsletters", primary_key: "newsletterid", force: true do |t|
    t.string   "email",    limit: 100
    t.datetime "created"
    t.datetime "modified"
    t.integer  "userid"
    t.integer  "isactive", limit: 2
  end

  create_table "roles", primary_key: "roleid", force: true do |t|
    t.string   "name",     limit: 50
    t.datetime "created"
    t.datetime "modified"
  end

  create_table "shortened_urls", force: true do |t|
    t.integer  "owner_id"
    t.string   "owner_type", limit: 20
    t.string   "url",                               null: false
    t.string   "unique_key", limit: 10,             null: false
    t.integer  "use_count",             default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shortened_urls", ["owner_id", "owner_type"], name: "index_shortened_urls_on_owner_id_and_owner_type", using: :btree
  add_index "shortened_urls", ["unique_key"], name: "index_shortened_urls_on_unique_key", unique: true, using: :btree
  add_index "shortened_urls", ["url"], name: "index_shortened_urls_on_url", using: :btree

  create_table "users", primary_key: "userid", force: true do |t|
    t.string   "gender",            limit: 50
    t.datetime "created"
    t.datetime "modified"
    t.string   "email",             limit: 50
    t.string   "firstname",         limit: 50
    t.string   "lastname",          limit: 50
    t.string   "password_hash",     limit: 1000
    t.string   "salt",              limit: 1000
    t.string   "location",          limit: 250
    t.string   "provider",          limit: 100
    t.string   "imageurl",          limit: 500
    t.date     "birthday"
    t.string   "providerurl",       limit: 250
    t.string   "locale",            limit: 250
    t.string   "providerusername",  limit: 250
    t.string   "timezone",          limit: 50
    t.string   "provideruid",       limit: 100
    t.integer  "roleid"
    t.integer  "isVerified",        limit: 2
    t.string   "verifysalt",        limit: 1000
    t.string   "passwordresetsalt", limit: 1000
    t.datetime "lastlogin"
    t.string   "facebookresponse",  limit: 50000
    t.integer  "account_id"
  end

  create_table "widgets", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "stock"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
