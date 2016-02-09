class AddColumnToUser < ActiveRecord::Migration
  def change
  	add_column :users, :first_number, :integer
  	add_column :users, :second_number, :integer    
  end
end
