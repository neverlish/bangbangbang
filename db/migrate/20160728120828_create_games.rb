class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
    	t.integer :master_id
      t.string :status, defalut: "none료"
      t.string :daynight, default: "day"
      t.string :result, default: "draw"

      t.timestamps
    end
  end
end
