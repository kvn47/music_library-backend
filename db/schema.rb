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

ActiveRecord::Schema.define(version: 2018_01_17_043512) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "albums", force: :cascade do |t|
    t.bigint "artist_id"
    t.string "title", null: false
    t.integer "year"
    t.string "path"
    t.string "cover"
    t.string "album_artist"
    t.string "mb_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artist_id"], name: "index_albums_on_artist_id"
    t.index ["mb_id"], name: "index_albums_on_mb_id"
    t.index ["title"], name: "index_albums_on_title"
  end

  create_table "artists", force: :cascade do |t|
    t.string "name", null: false
    t.string "path"
    t.string "image"
    t.string "mb_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mb_id"], name: "index_artists_on_mb_id"
    t.index ["name"], name: "index_artists_on_name", unique: true
  end

  create_table "export_lists", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "size", default: 0, null: false
    t.integer "capacity"
    t.string "destination_path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notes", force: :cascade do |t|
    t.integer "position"
    t.string "kind"
    t.string "artist"
    t.string "album"
    t.string "download_url"
    t.string "download_path"
    t.date "release_date"
    t.text "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tracklistings", id: false, force: :cascade do |t|
    t.bigint "tracklist_id"
    t.bigint "track_id"
    t.index ["track_id"], name: "index_tracklistings_on_track_id"
    t.index ["tracklist_id"], name: "index_tracklistings_on_tracklist_id"
  end

  create_table "tracklists", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tracklists_on_name", unique: true
  end

  create_table "tracks", force: :cascade do |t|
    t.bigint "album_id", null: false
    t.integer "number", null: false
    t.string "title", null: false
    t.string "path"
    t.integer "size"
    t.integer "length"
    t.string "mb_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["album_id"], name: "index_tracks_on_album_id"
    t.index ["mb_id"], name: "index_tracks_on_mb_id"
  end

  create_table "tracks_exports", id: false, force: :cascade do |t|
    t.bigint "export_list_id"
    t.bigint "track_id"
    t.index ["export_list_id"], name: "index_tracks_exports_on_export_list_id"
    t.index ["track_id", "export_list_id"], name: "index_tracks_exports_on_track_id_and_export_list_id", unique: true
    t.index ["track_id"], name: "index_tracks_exports_on_track_id"
  end

  add_foreign_key "albums", "artists"
  add_foreign_key "tracklistings", "tracklists"
  add_foreign_key "tracklistings", "tracks"
  add_foreign_key "tracks", "albums"
  add_foreign_key "tracks_exports", "export_lists"
  add_foreign_key "tracks_exports", "tracks"
end
