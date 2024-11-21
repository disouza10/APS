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

ActiveRecord::Schema[7.2].define(version: 2024_11_21_001032) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "child", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.date "birth_date"
    t.integer "cpf"
    t.text "notes"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id", "deleted_at"], name: "index_child_on_id_and_deleted_at", unique: true
  end

  create_table "formations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "answered_at"
    t.string "email"
    t.string "name"
    t.string "team"
    t.string "feedback"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["id", "deleted_at"], name: "index_formations_on_id_and_deleted_at", unique: true
  end

  create_table "institutions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "phone"
    t.string "email"
    t.uuid "responsibles_id", null: false
    t.uuid "child_id", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["child_id"], name: "index_institutions_on_child_id"
    t.index ["id", "deleted_at"], name: "index_institutions_on_id_and_deleted_at", unique: true
    t.index ["responsibles_id"], name: "index_institutions_on_responsibles_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.date "birth_date"
    t.integer "cpf"
    t.text "notes"
    t.string "secondary_email"
    t.string "phone"
    t.string "occupation"
    t.string "emergency_contact_phone"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.text "emergency_contact_name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["id", "deleted_at"], name: "index_users_on_id_and_deleted_at", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "institutions", "child"
  add_foreign_key "institutions", "users", column: "responsibles_id"
end
