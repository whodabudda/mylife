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

ActiveRecord::Schema.define(version: 20151024005934) do

  create_table "duser_metrics", id: false, force: :cascade do |t|
    t.integer  "value",      limit: 4
    t.datetime "occur_dttm"
    t.integer  "duser_id",   limit: 4
    t.integer  "metric_id",  limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "duser_metrics", ["duser_id"], name: "index_duser_metrics_on_duser_id", using: :btree
  add_index "duser_metrics", ["metric_id"], name: "index_duser_metrics_on_metric_id", using: :btree

  create_table "duser_roles", id: false, force: :cascade do |t|
    t.integer  "duser_id",   limit: 4, null: false
    t.integer  "role_id",    limit: 4, null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "duser_roles", ["duser_id", "role_id"], name: "index_dusers_roles_on_dusers_id_and_roles_id", using: :btree
  add_index "duser_roles", ["duser_id"], name: "index_dusers_roles_on_dusers_id", using: :btree

  create_table "dusers", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "username",               limit: 255,              null: false
    t.date     "birthdate",                                       null: false
    t.integer  "failed_attempts",        limit: 4,   default: 0,  null: false
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
  end

  add_index "dusers", ["email"], name: "index_dusers_on_email", unique: true, using: :btree
  add_index "dusers", ["reset_password_token"], name: "index_dusers_on_reset_password_token", unique: true, using: :btree

  create_table "metrics", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.integer  "duser_id",    limit: 4
    t.integer  "unit_id",     limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "metrics", ["duser_id"], name: "index_metrics_on_duser_id", using: :btree
  add_index "metrics", ["unit_id"], name: "index_metrics_on_unit_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "units", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "displ_name", limit: 255
    t.integer  "duser_id",   limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "units", ["duser_id"], name: "index_units_on_duser_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name",      limit: 30,  null: false
    t.string   "last_name",       limit: 50,  null: false
    t.date     "birthdate"
    t.string   "password_digest", limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "email",           limit: 255, null: false
    t.string   "username",        limit: 255, null: false
    t.integer  "role_id",         limit: 4
  end

  add_index "users", ["role_id"], name: "index_users_on_role_id", using: :btree

  add_foreign_key "duser_metrics", "dusers"
  add_foreign_key "duser_metrics", "metrics"
  add_foreign_key "metrics", "dusers"
  add_foreign_key "metrics", "units"
  add_foreign_key "units", "dusers"
  add_foreign_key "users", "roles"
end
