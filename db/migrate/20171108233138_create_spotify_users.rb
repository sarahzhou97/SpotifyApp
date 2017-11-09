class CreateSpotifyUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :spotify_users do |t|
    	t.string :user_id
    	t.date :birthdate
    	t.string :name
    	t.string :image
    end
  end
end
