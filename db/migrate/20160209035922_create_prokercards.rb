class CreateProkercards < ActiveRecord::Migration
  def change
    create_table :prokercards do |t|
      t.string :suit 
      t.integer :number
      t.integer :prokerbox_id
      t.timestamps null: false
      t.integer :position
    end
  end
end
