class CreateAlbumBies < ActiveRecord::Migration[5.0]
  def change
    create_table :album_bies do |t|
    	t.string :album_id
    	t.string :artist_id
    end
  end
end
