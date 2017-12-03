class CreateAlbums < ActiveRecord::Migration[5.0]
  def change
    create_table :albums, id: false do |t|
        t.primary_key :album_id, null: false
    	#t.string :album_id, null: false
    	t.string :album_type
    	t.string :artist_id
    	t.string :genre
    	t.string :release_date
    	t.string :album_name
        t.integer :popularity
    end

    change_column :albums, :album_id, :string
  end
end

