class CreateFollowsPlaylists < ActiveRecord::Migration[5.0]
  def change
    create_table :follows_playlists do |t|
    	t.string :user_id
    	t.string :playlist_id
    end
  end
end
