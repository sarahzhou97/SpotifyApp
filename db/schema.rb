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

ActiveRecord::Schema.define(version: 20171109001054) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "albums", primary_key: "album_id", force: :cascade do |t|
    t.string  "album_type"
    t.string  "artist_id"
    t.string  "genre"
    t.string  "release_date"
    t.string  "album_name"
    t.integer "popularity"
  end

  create_table "artists", primary_key: "artist_id", force: :cascade do |t|
    t.string  "name"
    t.integer "popularity"
    t.string  "genre"
  end

  create_table "follows_playlists", primary_key: ["user_id", "playlist_id"], force: :cascade do |t|
    t.string "user_id",     null: false
    t.string "playlist_id", null: false
  end

  create_table "playlist_contains", primary_key: ["playlist_id", "track_id"], force: :cascade do |t|
    t.string "playlist_id", null: false
    t.string "track_id",    null: false
  end

  create_table "playlists", primary_key: "playlist_id", force: :cascade do |t|
    t.string "creator_id"
    t.string "playlist_name"
  end

  create_table "saveds", primary_key: ["user_id", "track_id"], force: :cascade do |t|
    t.string "user_id",  null: false
    t.string "track_id", null: false
  end

  create_table "spotify_users", primary_key: "user_id", force: :cascade do |t|
    t.string "birthdate"
    t.string "country"
    t.string "name"
  end

  create_table "tracks", primary_key: "track_id", force: :cascade do |t|
    t.string  "album_id"
    t.string  "song_name"
    t.integer "popularity"
    t.string  "artist_id"
    t.float   "acousticness"
    t.float   "danceability"
    t.float   "energy"
    t.float   "instrumentalness"
    t.integer "key"
    t.float   "liveness"
    t.float   "loudness"
    t.integer "mode"
    t.float   "speechiness"
    t.float   "tempo"
    t.integer "time_signature"
    t.float   "valence"
  end

end
