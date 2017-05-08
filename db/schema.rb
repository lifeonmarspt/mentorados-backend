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

ActiveRecord::Schema.define(version: 20170504102820) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "careers", force: :cascade do |t|
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["description"], name: "index_careers_on_description", unique: true
  end

  create_table "locations", force: :cascade do |t|
    t.string "description"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["description"], name: "index_locations_on_description", unique: true
  end

  create_table "mentors", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "gender", null: false
    t.text "bio", null: false
    t.string "picture"
    t.string "password_digest"
    t.integer "year_in", null: false
    t.integer "year_out"
    t.boolean "admin", default: false
    t.string "confirmation_token", null: false
    t.datetime "confirmed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_mentors_on_email", unique: true
  end

  create_table "mentors_careers", force: :cascade do |t|
    t.integer "mentor_id"
    t.integer "career_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mentors_locations", force: :cascade do |t|
    t.integer "mentor_id"
    t.integer "location_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "mentors_careers", "careers", on_update: :cascade, on_delete: :cascade
  add_foreign_key "mentors_careers", "mentors", on_update: :cascade, on_delete: :cascade
  add_foreign_key "mentors_locations", "locations", on_update: :cascade, on_delete: :cascade
  add_foreign_key "mentors_locations", "mentors", on_update: :cascade, on_delete: :cascade
end
