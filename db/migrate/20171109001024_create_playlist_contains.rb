class CreatePlaylistContains < ActiveRecord::Migration[5.0]
  def change
    create_table :playlist_contains do |t|
    	t.string :playlist_id
    	t.string :track_id
    end
  end
end
