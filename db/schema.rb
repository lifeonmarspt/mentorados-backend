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

ActiveRecord::Schema.define(version: 20170601101351) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "careers", force: :cascade do |t|
    t.string "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["description"], name: "index_careers_on_description", unique: true
  end

  create_table "mentors", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name", null: false
    t.string "email", null: false
    t.string "gender", null: false
    t.text "bio", null: false
    t.string "picture"
    t.integer "year_in", null: false
    t.integer "year_out"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "links", default: [], array: true
    t.text "location"
    t.boolean "active", default: false
    t.index ["email"], name: "index_mentors_on_email", unique: true
    t.index ["user_id"], name: "index_mentors_on_user_id", unique: true
  end

  create_table "mentors_careers", force: :cascade do |t|
    t.bigint "mentor_id"
    t.bigint "career_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["career_id"], name: "index_mentors_careers_on_career_id"
    t.index ["mentor_id"], name: "index_mentors_careers_on_mentor_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest"
    t.boolean "admin", default: false
    t.string "confirmation_token", null: false
    t.datetime "confirmed_at"
    t.datetime "last_login_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_reset_token"
    t.datetime "password_reset_token_expires_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "mentors", "users"
  add_foreign_key "mentors_careers", "careers"
  add_foreign_key "mentors_careers", "mentors"
end
