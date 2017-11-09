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

ActiveRecord::Schema.define(version: 20171109001119) do

  create_table "album_bies", force: :cascade do |t|
    t.string "album_id"
    t.string "artist_id"
  end

  create_table "albums", force: :cascade do |t|
    t.string "album_id"
    t.string "album_name"
    t.date   "release_date"
  end

  create_table "artists", force: :cascade do |t|
    t.string "artist_id"
    t.string "name"
  end

  create_table "follows_playlists", force: :cascade do |t|
    t.string "user_id"
    t.string "playlist_id"
  end

  create_table "in_albums", force: :cascade do |t|
    t.string "track_id"
    t.string "album_id"
  end

  create_table "playlist_contains", force: :cascade do |t|
    t.string "playlist_id"
    t.string "track_id"
  end

  create_table "playlists", force: :cascade do |t|
    t.string "playlist_id"
    t.string "creator_id"
    t.string "playlist_name"
  end

  create_table "saveds", force: :cascade do |t|
    t.string "user_id"
    t.string "track_id"
  end

  create_table "spotify_users", force: :cascade do |t|
    t.string "user_id"
    t.date   "birthdate"
    t.string "name"
    t.string "image"
  end

  create_table "track_bies", force: :cascade do |t|
    t.string "track_id"
    t.string "artist_id"
  end

  create_table "tracks", force: :cascade do |t|
    t.string  "track_id"
    t.string  "song_name"
    t.date    "releasedate"
    t.integer "tempo"
    t.string  "genre"
  end

end
