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

ActiveRecord::Schema.define(version: 20170609031835) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "changes", force: :cascade do |t|
    t.json    "payload"
    t.string  "register_name"
    t.integer "user_id"
    t.index ["user_id"], name: "index_changes_on_user_id", using: :btree
  end

  create_table "statuses", force: :cascade do |t|
    t.string  "status"
    t.string  "comment"
    t.integer "reviewed_by_id"
    t.integer "change_id",      null: false
    t.index ["change_id"], name: "index_statuses_on_change_id", using: :btree
    t.index ["reviewed_by_id"], name: "index_statuses_on_reviewed_by_id", using: :btree
  end

  create_table "team_members", force: :cascade do |t|
    t.string   "role"
    t.integer  "team_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_team_members_on_team_id", using: :btree
    t.index ["user_id"], name: "index_team_members_on_user_id", using: :btree
  end

  create_table "teams", force: :cascade do |t|
    t.string   "registers",  default: [],              array: true
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
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
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.string   "invited_by_type"
    t.integer  "invited_by_id"
    t.integer  "invitations_count",      default: 0
    t.string   "full_name"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["full_name"], name: "index_users_on_full_name", unique: true, using: :btree
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
    t.index ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "changes", "users"
  add_foreign_key "statuses", "changes"
  add_foreign_key "statuses", "users", column: "reviewed_by_id"
  add_foreign_key "team_members", "teams"
  add_foreign_key "team_members", "users"
end
