class CreateTracks < ActiveRecord::Migration[5.0]
  def change
    create_table :tracks do |t|
    	t.string :track_id
    	t.string :album_id
    	t.string :song_name
    	t.integer :popularity
    	t.string  :artist
    end
  end
end
