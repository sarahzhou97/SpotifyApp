class CreateTrackBies < ActiveRecord::Migration[5.0]
  def change
    create_table :track_bies do |t|
    	t.string :track_id
    	t.string :artist_id
    end
  end
end
