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

ActiveRecord::Schema[7.0].define(version: 2023_01_23_152924) do
  create_table "user_settings", force: :cascade do |t|
    t.string "user_uuid"
    t.integer "widget_id", null: false
    t.string "name"
    t.text "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["widget_id"], name: "index_user_settings_on_widget_id"
  end

  create_table "user_widgets", force: :cascade do |t|
    t.string "user_uuid"
    t.integer "widget_id", null: false
    t.integer "row_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["widget_id"], name: "index_user_widgets_on_widget_id"
  end

  create_table "widgets", force: :cascade do |t|
    t.string "component"
    t.string "partner"
    t.string "name"
    t.string "description"
    t.string "logo_link_url"
    t.string "status"
    t.datetime "activation_date"
    t.boolean "internal"
    t.string "updated_by_uuid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "user_settings", "widgets"
  add_foreign_key "user_widgets", "widgets"
end
