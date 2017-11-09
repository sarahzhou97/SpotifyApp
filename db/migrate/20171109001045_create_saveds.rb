class CreateSaveds < ActiveRecord::Migration[5.0]
  def change
    create_table :saveds do |t|
    	t.string :user_id
    	t.string :track_id
    end
  end
end
