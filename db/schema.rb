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

ActiveRecord::Schema.define(version: 2021_01_18_193949) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "episodes", force: :cascade do |t|
    t.datetime "release_date"
    t.integer "number", null: false
    t.text "title", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "episodes_people", id: false, force: :cascade do |t|
    t.bigint "episode_id", null: false
    t.bigint "person_id", null: false
    t.index ["episode_id", "person_id"], name: "index_episodes_people_on_episode_id_and_person_id"
    t.index ["person_id", "episode_id"], name: "index_episodes_people_on_person_id_and_episode_id"
  end

  create_table "people", force: :cascade do |t|
    t.text "first_name", null: false
    t.text "last_name", null: false
    t.text "bio_link"
    t.text "twitter_handle"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_current_host", default: false
    t.boolean "is_former_host", default: false
  end

  create_table "recommendations", force: :cascade do |t|
    t.text "name"
    t.text "imdb_path"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "episode_id"
    t.bigint "person_id"
    t.index ["episode_id"], name: "index_recommendations_on_episode_id"
    t.index ["person_id"], name: "index_recommendations_on_person_id"
  end

end
