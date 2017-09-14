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

ActiveRecord::Schema.define(version: 20170914023539) do

  create_table "fulfillment_services", force: :cascade do |t|
    t.string "username_encrypted", limit: 255
    t.string "password_encrypted", limit: 255
    t.string "shop", limit: 255
    t.string "username_encrypted_iv"
    t.string "password_encrypted_iv"
    t.string "role"
    t.index ["shop"], name: "index_fulfillment_services_on_shop"
  end

  create_table "shop_items", force: :cascade do |t|
    t.string "title", limit: 255
    t.string "size", limit: 255
    t.string "url", limit: 255
    t.integer "edition"
    t.integer "total_editions"
    t.index ["title", "size"], name: "index_shop_items_on_title_and_size", unique: true
  end

  create_table "shops", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "token_encrypted", limit: 255
    t.string "token_encrypted_iv"
    t.index ["name"], name: "index_shops_on_name"
  end

end
