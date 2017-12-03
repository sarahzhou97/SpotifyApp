class CreateFollowsPlaylists < ActiveRecord::Migration[5.0]
  def change
    create_table :follows_playlists, id: false do |t|
    	t.string :user_id
    	t.string :playlist_id
    end

    execute "ALTER TABLE follows_playlists ADD PRIMARY KEY (user_id, playlist_id);"
  end
end
