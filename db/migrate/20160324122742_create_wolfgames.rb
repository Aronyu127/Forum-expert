class CreateWolfgames < ActiveRecord::Migration
  def change
    create_table :wolfgames do |t|
      t.integer :player_number
      t.timestamps null: false
    end
  end
end
