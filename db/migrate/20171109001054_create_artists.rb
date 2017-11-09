class CreateArtists < ActiveRecord::Migration[5.0]
  def change
    create_table :artists do |t|
    	t.string :artist_id
    	t.string :name
    	t.integer :popularity
    	t.string :genre
    end
  end
end
