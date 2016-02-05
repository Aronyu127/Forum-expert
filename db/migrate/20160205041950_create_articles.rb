class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.string :content
      t.integer :category_id, :index => true
      t.integer :user_id, :index => true
      t.integer :viewer, :index => true
      t.string :status, :default => "draft"
      t.string :image_url

      t.timestamps null: false
    end
  end
end
