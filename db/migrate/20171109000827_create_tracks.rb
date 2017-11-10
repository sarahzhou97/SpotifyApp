class CreateTracks < ActiveRecord::Migration[5.0]
  def change
    create_table :tracks do |t|
    	t.string :track_id
    	t.string :album_id
    	t.string :song_name
    	t.integer :popularity
    	t.string  :artist_id
    	t.float :acousticness
    	t.float :danceability
  		t.float :energy
  		t.float :instrumentalness
  		t.integer :key
  		t.float :liveness
  		t.float :loudness
  		t.integer :mode
  		t.float :speechiness
  		t.float :tempo
  		t.integer :time_signature
  		t.float :valence
    end
  end
end
