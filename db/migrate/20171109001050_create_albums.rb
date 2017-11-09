class CreateAlbums < ActiveRecord::Migration[5.0]
  def change
    create_table :albums do |t|
    	t.string :album_id
    	t.string :album_name
    	t.date :release_date
    end
  end
end
