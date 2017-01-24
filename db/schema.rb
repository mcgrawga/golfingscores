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

ActiveRecord::Schema.define(version: 20170121155058) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "courses", force: :cascade do |t|
    t.string   "name",       default: "", null: false
    t.string   "city",       default: "", null: false
    t.string   "state",      default: "", null: false
    t.integer  "user_id",                 null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "scores", force: :cascade do |t|
    t.integer  "tee_id",               null: false
    t.datetime "date_played",          null: false
    t.integer  "score_hole_1"
    t.integer  "score_hole_2"
    t.integer  "score_hole_3"
    t.integer  "score_hole_4"
    t.integer  "score_hole_5"
    t.integer  "score_hole_6"
    t.integer  "score_hole_7"
    t.integer  "score_hole_8"
    t.integer  "score_hole_9"
    t.integer  "score_hole_10"
    t.integer  "score_hole_11"
    t.integer  "score_hole_12"
    t.integer  "score_hole_13"
    t.integer  "score_hole_14"
    t.integer  "score_hole_15"
    t.integer  "score_hole_16"
    t.integer  "score_hole_17"
    t.integer  "score_hole_18"
    t.integer  "putts_hole_1"
    t.integer  "putts_hole_2"
    t.integer  "putts_hole_3"
    t.integer  "putts_hole_4"
    t.integer  "putts_hole_5"
    t.integer  "putts_hole_6"
    t.integer  "putts_hole_7"
    t.integer  "putts_hole_8"
    t.integer  "putts_hole_9"
    t.integer  "putts_hole_10"
    t.integer  "putts_hole_11"
    t.integer  "putts_hole_12"
    t.integer  "putts_hole_13"
    t.integer  "putts_hole_14"
    t.integer  "putts_hole_15"
    t.integer  "putts_hole_16"
    t.integer  "putts_hole_17"
    t.integer  "putts_hole_18"
    t.integer  "fairways_hit"
    t.integer  "greens_in_regulation"
    t.integer  "penalties"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.text     "notes"
  end

  create_table "tees", force: :cascade do |t|
    t.string   "name",          default: "", null: false
    t.decimal  "course_rating",              null: false
    t.integer  "slope_rating",               null: false
    t.integer  "course_id",                  null: false
    t.integer  "par_hole_1",                 null: false
    t.integer  "par_hole_2",                 null: false
    t.integer  "par_hole_3",                 null: false
    t.integer  "par_hole_4",                 null: false
    t.integer  "par_hole_5",                 null: false
    t.integer  "par_hole_6",                 null: false
    t.integer  "par_hole_7",                 null: false
    t.integer  "par_hole_8",                 null: false
    t.integer  "par_hole_9",                 null: false
    t.integer  "par_hole_10"
    t.integer  "par_hole_11"
    t.integer  "par_hole_12"
    t.integer  "par_hole_13"
    t.integer  "par_hole_14"
    t.integer  "par_hole_15"
    t.integer  "par_hole_16"
    t.integer  "par_hole_17"
    t.integer  "par_hole_18"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "stripe_customer_id"
    t.string   "stripe_plan"
    t.string   "landing_page"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
