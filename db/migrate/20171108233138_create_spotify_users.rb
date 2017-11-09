class CreateSpotifyUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :spotify_users do |t|
    	t.string :user_id
    	t.string :birthdate
    	t.string :country
    	t.string :name
    end
  end
end
