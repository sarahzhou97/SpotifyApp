class CreateArtists < ActiveRecord::Migration[5.0]
  def change
    create_table :artists, id: false do |t|
    	t.primary_key :artist_id
    	t.string :name
    	t.integer :popularity
    	t.string :genre
    end

    change_column :artists, :artist_id, :string
  end
end
