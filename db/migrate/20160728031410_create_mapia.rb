class CreateMapia < ActiveRecord::Migration[5.0]
  def change
    create_table :mapia do |t|
      t.references :user
      t.string :role
      t.string :status, default: "alive"
      t.integer :game_id

      t.timestamps
    end
  end
end
