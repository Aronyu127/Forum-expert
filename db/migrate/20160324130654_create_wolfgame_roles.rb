class CreateWolfgameRoles < ActiveRecord::Migration
  def change
    create_table :wolfgame_roles do |t|
      t.string :name
      t.string :description
      t.integer :order
      t.string :ability
      t.string :faction
      t.timestamps null: false
    end
  end
end
