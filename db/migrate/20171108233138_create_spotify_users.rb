class CreateSpotifyUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :spotify_users, id: false do |t|
    	t.primary_key :user_id
    	t.string :birthdate
    	t.string :country
    	t.string :name
    end

    change_column :spotify_users, :user_id, :string
  end
end
