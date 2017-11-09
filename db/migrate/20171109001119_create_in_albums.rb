class CreateInAlbums < ActiveRecord::Migration[5.0]
  def change
    create_table :in_albums do |t|
    	t.string :track_id
    	t.string :album_id
    end
  end
end
