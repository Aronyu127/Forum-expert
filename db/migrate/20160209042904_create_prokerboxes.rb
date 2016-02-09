class CreateProkerboxes < ActiveRecord::Migration
  def change
    create_table :prokerboxes do |t|
      t.integer :user_id
      t.integer :lastcards, :default=>52
      t.timestamps null: false
    end
  end
end
