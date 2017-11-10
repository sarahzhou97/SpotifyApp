class CreateAlbums < ActiveRecord::Migration[5.0]
  def change
    create_table :albums do |t|
    	t.string :album_id
    	t.string :album_type
    	t.string :artist_id
    	t.string :genre
    	t.string :release_date
    	t.string :album_name
        t.integer :popularity
    end
  end
end

