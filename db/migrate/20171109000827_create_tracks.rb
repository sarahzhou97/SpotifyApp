class CreateTracks < ActiveRecord::Migration[5.0]
  def change
    create_table :tracks do |t|
    	t.string :track_id
    	t.string :song_name
    	t.date :releasedate
    	t.integer :tempo
   		t.string :genre
    end
  end
end
