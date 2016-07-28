class CreateMapia < ActiveRecord::Migration[5.0]
  def change
    create_table :mapia do |t|
      t.references :user
      t.string :role
      t.string :status
      t.integer :game_id
      t.string :game_result

      t.timestamps
    end
  end
end
