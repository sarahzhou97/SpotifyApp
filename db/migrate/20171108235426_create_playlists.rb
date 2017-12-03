class CreatePlaylists < ActiveRecord::Migration[5.0]
  def change
    create_table :playlists, id: false do |t|
    	t.primary_key :playlist_id
    	t.string :creator_id
    	t.string :playlist_name
    end

    change_column :playlists, :playlist_id, :string
  end
end
