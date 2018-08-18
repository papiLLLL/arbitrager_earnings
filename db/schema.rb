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

ActiveRecord::Schema.define(version: 2018_08_18_001942) do

  create_table "bitcoin_informations", force: :cascade do |t|
    t.text "date"
    t.integer "total_jpy_balance"
    t.integer "btc_balance"
    t.integer "btc_price"
    t.integer "profit"
    t.integer "profit_rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "coinchecks", force: :cascade do |t|
    t.text "date"
    t.integer "total_jpy_balance"
    t.integer "btc_balance"
    t.integer "btc_price"
    t.integer "profit"
    t.integer "profit_rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "exchange_informations", force: :cascade do |t|
    t.text "date"
    t.text "name"
    t.integer "jpy_balance"
    t.float "btc_balance"
    t.integer "btc_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "profits", force: :cascade do |t|
    t.text "date"
    t.integer "total_jpy_balance"
    t.integer "profit"
    t.float "profit_rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
