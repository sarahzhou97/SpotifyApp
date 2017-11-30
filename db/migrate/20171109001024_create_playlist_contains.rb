class CreatePlaylistContains < ActiveRecord::Migration[5.0]
  def change
    create_table :playlist_contains, id: false do |t|
    	t.string :playlist_id
    	t.string :track_id
    end

    execute "ALTER TABLE playlist_contains ADD PRIMARY KEY (playlist_id, track_id);"
  end
end
