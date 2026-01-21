# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2024_01_17_000000) do

  create_table "active_storage_attachments", charset: "latin1", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "latin1", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "latin1", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "duser_metrics", charset: "latin1", force: :cascade do |t|
    t.integer "value", null: false
    t.datetime "occur_dttm", null: false
    t.bigint "duser_id", null: false
    t.bigint "metric_id", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["duser_id"], name: "index_duser_metrics_on_duser_id"
    t.index ["metric_id"], name: "index_duser_metrics_on_metric_id"
  end

  create_table "duser_roles", id: false, charset: "latin1", force: :cascade do |t|
    t.bigint "duser_id", null: false
    t.bigint "role_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["duser_id", "role_id"], name: "index_dusers_roles_on_dusers_id_and_roles_id"
    t.index ["duser_id"], name: "index_dusers_roles_on_dusers_id"
  end

  create_table "dusers", charset: "latin1", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.date "birthdate", null: false
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.integer "sys_setup_complete", limit: 1, default: 0
    t.index ["email"], name: "index_dusers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_dusers_on_reset_password_token", unique: true
  end

  create_table "metrics", charset: "latin1", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.bigint "duser_id", null: false
    t.bigint "unit_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "series_color"
    t.string "series_type", limit: 45, default: "event", null: false
    t.boolean "visible", default: true
    t.index ["duser_id"], name: "index_metrics_on_duser_id"
    t.index ["name", "duser_id"], name: "index_metrics_on_name", unique: true
    t.index ["unit_id"], name: "index_metrics_on_unit_id"
  end

  create_table "reviews", charset: "latin1", force: :cascade do |t|
    t.bigint "metric_id", null: false
    t.bigint "duser_id", null: false
    t.bigint "event_id", null: false
    t.date "start_dt", null: false
    t.date "end_dt", null: false
    t.integer "span"
    t.boolean "significant"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "roles", charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "units", charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.string "displ_name"
    t.bigint "duser_id", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", charset: "latin1", force: :cascade do |t|
    t.string "first_name", limit: 30, null: false
    t.string "last_name", limit: 50, null: false
    t.date "birthdate"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", null: false
    t.string "username", null: false
    t.bigint "role_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
