class CreateWolfgamePlayers < ActiveRecord::Migration
  def change
    create_table :wolfgame_players do |t|
      t.string :name
      t.integer :user_id
      t.integer :wolfgame_id
      t.integer :role_id
      t.timestamps null: false
    end
  end
end
