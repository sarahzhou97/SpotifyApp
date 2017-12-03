class CreateSaveds < ActiveRecord::Migration[5.0]
  def change
    create_table :saveds, id: false do |t|
    	t.string :user_id
    	t.string :track_id
    end

    execute "ALTER TABLE saveds ADD PRIMARY KEY (user_id, track_id);"
  end
end
