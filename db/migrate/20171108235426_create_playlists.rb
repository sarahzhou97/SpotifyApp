class CreatePlaylists < ActiveRecord::Migration[5.0]
  def change
    create_table :playlists do |t|
    	t.string :playlist_id
    	t.string :creator_id
    	t.string :playlist_name
    end
  end
end
