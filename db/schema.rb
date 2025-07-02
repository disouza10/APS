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

ActiveRecord::Schema[7.2].define(version: 2025_06_27_153248) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "audits", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "auditable_id"
    t.string "auditable_type"
    t.uuid "associated_id"
    t.string "associated_type"
    t.uuid "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.jsonb "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "children", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.date "birth_date"
    t.integer "cpf"
    t.text "notes"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "team_id"
    t.uuid "institution_id"
    t.index ["id", "deleted_at"], name: "index_children_on_id_and_deleted_at", unique: true
    t.index ["institution_id"], name: "index_children_on_institution_id"
    t.index ["team_id"], name: "index_children_on_team_id"
  end

  create_table "formation_reports", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.date "date"
    t.integer "active_volunteers_count"
    t.integer "inactive_volunteers_count"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id", "deleted_at"], name: "index_formation_reports_on_id_and_deleted_at", unique: true
  end

  create_table "formations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "answered_at"
    t.string "feedback"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.uuid "team_id"
    t.uuid "volunteer_id"
    t.uuid "formation_report_id"
    t.index ["formation_report_id"], name: "index_formations_on_formation_report_id"
    t.index ["id", "deleted_at"], name: "index_formations_on_id_and_deleted_at", unique: true
    t.index ["team_id"], name: "index_formations_on_team_id"
    t.index ["volunteer_id"], name: "index_formations_on_volunteer_id"
  end

  create_table "institutions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "phone"
    t.string "email"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id", "deleted_at"], name: "index_institutions_on_id_and_deleted_at", unique: true
  end

  create_table "teams", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "status", default: "active"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "institution_id"
    t.string "sanitized_name"
    t.index ["id", "deleted_at"], name: "index_teams_on_id_and_deleted_at", unique: true
    t.index ["institution_id"], name: "index_teams_on_institution_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
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
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["id", "deleted_at"], name: "index_users_on_id_and_deleted_at", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "volunteers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "full_name"
    t.date "birth_date"
    t.text "notes"
    t.string "secondary_email"
    t.string "phone"
    t.string "occupation"
    t.string "emergency_contact_phone"
    t.string "emergency_contact_name"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "address"
    t.string "coordination_notes"
    t.string "email"
    t.uuid "current_team_id"
    t.uuid "original_team_id"
    t.string "status", default: "active"
    t.index ["current_team_id"], name: "index_volunteers_on_current_team_id"
    t.index ["id", "deleted_at"], name: "index_volunteers_on_id_and_deleted_at", unique: true
    t.index ["original_team_id"], name: "index_volunteers_on_original_team_id"
  end

  add_foreign_key "children", "institutions"
  add_foreign_key "children", "teams"
  add_foreign_key "formations", "formation_reports"
  add_foreign_key "formations", "teams"
  add_foreign_key "formations", "volunteers"
  add_foreign_key "teams", "institutions"
  add_foreign_key "volunteers", "teams", column: "current_team_id"
  add_foreign_key "volunteers", "teams", column: "original_team_id"
end
